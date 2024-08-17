import 'dart:collection';

import 'package:flutter/material.dart';

/// A record type to aggregate information about the current state of a
/// [FastFormField].
typedef FastFormFieldStatus<T> = ({
  T? value,
  bool enabled,
  bool touched,
  bool interacted,
  bool invalid,
});

typedef FastInputDecorationBuilder = InputDecoration Function(
    FastFormFieldState field);

/// A map whose entries associate a [FastFormFieldState.name] with a
/// [FastFormFieldStatus].
typedef FastFormStatus = Map<String, FastFormFieldStatus<dynamic>>;

typedef FastFormChanged = void Function(FastFormStatus status);

/// Wraps a [Form] widget and passes [FastFormField] widgets as [children] to
/// it.
///
/// Allows configuring uniform adaptiveness and decoration across the entire
/// [Form].
///
/// Optionally accepts a [FastFormChanged] listener that is called whenever a
/// a child [FastFormField] widget changes its value.
@immutable
class FastForm extends StatefulWidget {
  const FastForm({
    super.key,
    this.adaptive = false,
    this.canPop,
    required this.children,
    required this.formKey,
    this.inputDecorationBuilder,
    this.inputDecorationTheme,
    this.onChanged,
    @Deprecated('Use onPopInvokedWithResult instead.') this.onPopInvoked,
    this.onPopInvokedWithResult,
  });

  final bool adaptive;
  final bool? canPop;
  final List<Widget> children;
  final GlobalKey<FormState> formKey;
  final FastInputDecorationBuilder? inputDecorationBuilder;
  final InputDecorationTheme? inputDecorationTheme;
  final FastFormChanged? onChanged;
  final void Function(bool)? onPopInvoked;
  final void Function(bool, Object?)? onPopInvokedWithResult;

  /// Returns the [FastFormState] instance for this [FastForm] widget via
  /// [_FastFormScope] inherited widget.
  static FastFormState? of(BuildContext context) {
    final _FastFormScope? scope =
        context.dependOnInheritedWidgetOfExactType<_FastFormScope>();
    return scope?._formState;
  }

  @override
  FastFormState createState() => FastFormState();
}

/// State associated with a [FastForm] widget.
///
/// Works identical to built-in [FormState].
///
/// Enhances [FormState] by triggering [FastForm.onChanged] whenever a
/// [FastFormField] changes and passing an [UnmodifiableMapView] of the current
/// [status] of the [FastForm].
///
/// Typically obtained via [FastForm.of].
class FastFormState extends State<FastForm> {
  final Map<String, FastFormFieldState> _fields = {};

  /// Returns an [UnmodifiableMapView] which holds an entry for any
  /// descendant [FastFormField] of this [FastForm].
  ///
  /// Every entry holds a [FastFormFieldState.name] as key and the corresponding
  /// [FastFormFieldState.value] as value.
  @Deprecated('use status instead')
  UnmodifiableMapView<String, dynamic> get values {
    final map = _fields.map((name, field) => MapEntry(name, field.value));
    return UnmodifiableMapView(map);
  }

  /// Exposes a [FastFormStatus] map which holds a status entry for any
  /// descendant [FastFormField] of this [FastForm].
  ///
  /// The key of every entry is a [FastFormFieldState.name] and the value the
  /// corresponding [FastFormFieldState.status].
  FastFormStatus get status {
    final entries =
        _fields.entries.map((entry) => MapEntry(entry.key, entry.value.status));
    return Map.fromEntries(entries);
  }

  void register(FastFormFieldState field) {
    if (_fields[field.name] == field) return;
    _fields[field.name] = field;
  }

  void unregister(FastFormFieldState field) => _fields.remove(field.name);

  FastFormFieldState? getFieldByName(String name) => _fields[name];

  /// A function for conveniently scrolling to any descendant [FastFormField] of
  /// this [FastForm].
  ///
  /// Typically used to scroll to an invalid [FastFormField].
  void scrollToField(
    String name, {
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
    double alignment = 0.5,
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.explicit,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final field = getFieldByName(name);
      if (field == null) {
        throw ArgumentError('Field with name $name does not exist.');
      }

      final FastFormFieldState<dynamic>(:context) = field;
      if (context.mounted) {
        Scrollable.ensureVisible(
          context,
          alignment: alignment,
          alignmentPolicy: alignmentPolicy,
          duration: duration,
          curve: curve,
        );
      }
    });
  }

  void onChanged() {
    for (final field in _fields.values) {
      field.testConditions();
    }
    widget.onChanged?.call(status);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      canPop: widget.canPop,
      onPopInvoked: widget.onPopInvoked,
      onPopInvokedWithResult: widget.onPopInvokedWithResult,
      child: _FastFormScope(
        formState: this,
        child: Column(
          children: widget.children,
        ),
      ),
    );
  }
}

/// Inherited widget for passing [FastFormState] down the widget tree.
///
/// Works identical to built-in [_FormScope].
///
/// Typically is used to register / unregister [FastFormFieldState] instances.
@immutable
class _FastFormScope extends InheritedWidget {
  const _FastFormScope({
    required super.child,
    required FastFormState formState,
  }) : _formState = formState;

  final FastFormState _formState;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

/// A [Function] that tests whether a single [FastCondition] is met.
typedef FastConditionTest = bool Function(
  dynamic value,
  FastFormFieldState field,
);

/// A [Function] that defines a conditional state of a [FastFormField].
///
/// Implements, what happens when a condition is met or not.
///
/// Typically linked to [FastConditionList].
///
/// Called at the end of every [FastFormFieldState.testConditions] run.
typedef FastConditionHandler = void Function(
  bool isMet,
  FastFormFieldState field,
);

/// A single condition to be met for a conditional state to occur.
@immutable
class FastCondition {
  const FastCondition({
    required this.target,
    required this.test,
  });

  /// The name of the [FastFormField] this [test] should be called upon.
  final String target;

  final FastConditionTest test;

  /// A [FastConditionHandler] that disables a [FastFormField] based
  /// on whether a [FastCondition] is met.
  static void disabled(bool isMet, FastFormFieldState field) {
    field.enabled = !isMet;
  }

  /// A [FastConditionHandler] that enables a [FastFormField] based
  /// on whether a [FastCondition] is met.
  static void enabled(bool isMet, FastFormFieldState field) {
    field.enabled = isMet;
  }
}

/// An enum to define a match logic for a [List] of multiple [FastCondition]
/// elements.
///
/// Typically specifies how all individual [FastCondition.test] results in a
/// [FastConditionList] are evaluated to determine whether a condition in
/// [FastFormField.conditions] is met.
enum FastConditionMatch {
  /// Every [FastCondition.test] in a [FastConditionList] must be true to met
  /// the condition.
  every,

  /// At least one [FastCondition.test] in a [FastConditionList] must be true to
  /// met the condition.
  any,
}

/// A wrapper class for a [List] of [FastCondition] elements.
@immutable
class FastConditionList {
  const FastConditionList(
    this.conditions, {
    this.match = FastConditionMatch.any,
  });

  final List<FastCondition> conditions;

  /// Defaults to [FastConditionMatch.any].
  final FastConditionMatch match;
}

/// A single fast form field.
///
/// Works identical to built-in [FormField].
///
/// Enhances [FormField] by adding additional parameters for configuring
/// adaptiveness and description texts.
@immutable
abstract class FastFormField<T> extends FormField<T> {
  const FastFormField({
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    required super.builder,
    super.enabled = true,
    super.initialValue,
    super.key,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.adaptive,
    this.conditions,
    this.contentPadding,
    this.decoration,
    this.helperText,
    this.labelText,
    required this.name,
    this.onChanged,
    this.onReset,
    this.onTouched,
  });

  /// null represents a non-adaptive form field widget
  final bool? adaptive;
  final Map<FastConditionHandler, FastConditionList>? conditions;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;
  final String? helperText;
  final String? labelText;
  final String name;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onReset;
  final void Function()? onTouched;
}

/// State associated with a [FastFormField] widget.
///
/// Works identical to built-in [FormFieldState].
///
/// Enhances [FormFieldState] by tracking [touched] state via [focusNode].
///
abstract class FastFormFieldState<T> extends FormFieldState<T> {
  bool? _enabled;

  /// Indicates if the user has touched the [FastFormField].
  ///
  /// The [FastFormField] must have been both focused and unfocused at least
  /// once to be marked as touched.
  ///
  /// This is not identical to [FormFieldState.hasInteractedByUser]
  /// which indicates that the value of the field has been changed at least once
  /// by the user.
  bool _touched = false;

  /// Indicates if the [FastFormField] is currently focused.
  bool focused = false;

  late FocusNode focusNode;

  /// Returns the [FastFormField] widget for this [FastFormFieldState] instance.
  /// Must be overridden in the concrete child class.
  @override
  @protected
  FastFormField<T> get widget;

  /// Returns if the [FastFormField.builder] should adapt to the
  /// [TargetPlatform] provided that the [FastFormField] type does support it.
  bool get adaptive => widget.adaptive ?? form?.widget.adaptive ?? false;

  set enabled(bool value) {
    if (value != _enabled) setState(() => _enabled = value);
  }

  bool get enabled => _enabled ?? widget.enabled;

  bool get touched => _touched;

  String get name => widget.name;

  FastFormFieldStatus<T> get status => (
        value: value,
        enabled: enabled,
        touched: touched,
        interacted: hasInteractedByUser,
        invalid: !isValid
      );

  /// Returns the [FastFormState] of the parent [FastForm].
  FastFormState? get form => FastForm.of(context);

  /// Creates the [InputDecoration] based on the current theme and the
  /// corresponding [FastFormField] widget configuration.
  InputDecoration get decoration {
    final theme = form?.widget.inputDecorationTheme ??
        Theme.of(context).inputDecorationTheme;

    final decoration = widget.decoration ??
        form?.widget.inputDecorationBuilder?.call(this) ??
        InputDecoration(
          contentPadding: widget.contentPadding ??
              const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          enabled: enabled,
          errorText: enabled ? errorText : null,
          helperText: widget.helperText,
          labelText: widget.labelText,
        );

    return decoration.applyDefaults(theme);
  }

  /// Adds the [_onFocusChanged] listener to [focusNode] and sets the initial
  /// [FormFieldState] value.
  @override
  void initState() {
    super.initState();
    _enabled = widget.enabled;
    focusNode = FocusNode()..addListener(_onFocusChanged);
    setValue(widget.initialValue);
  }

  /// Unregisters this [FastFormFieldState] instance on the [FastFormState].
  @override
  void deactivate() {
    super.deactivate();
    form?.unregister(this);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  /// Registers this [FastFormFieldState] instance on the [FastFormState] and
  /// builds the widget.
  ///
  /// Registration cannot be done in [initState] as [form] is retrieved via an
  /// [InheritedWidget] which is not available outside the widget tree.
  @override
  Widget build(BuildContext context) {
    form?.register(this);
    return super.build(context);
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    onChanged(value);
  }

  @override
  void reset() {
    super.reset();
    onReset();
  }

  /// A function that sets [FastFormFieldState.touched] to true and calls
  /// [FastFormField.onTouched] if provided.
  ///
  /// Should only be called when the [FastFormField] is to be considered
  /// touched.
  ///
  /// Typically used when the touched state of a [FastFormField] cannot directly
  /// be tracked via [FastFormFieldState.focusNode].
  void wasTouched() {
    if (!_touched) {
      setState(() {
        _touched = true;
        widget.onTouched?.call();
      });
    }
  }

  void onChanged(T? value) {
    wasTouched();
    setValue(value);
    widget.onChanged?.call(value);
    form?.onChanged();
  }

  void onReset() {
    setState(() {
      _enabled = null;
      _touched = false;
      focused = false;
      setValue(widget.initialValue);
      widget.onChanged?.call(widget.initialValue);
      form?.onChanged();
    });
  }

  /// Determines for every [MapEntry] in [FastFormField.conditions] if the
  /// respective condition is met.
  ///
  /// Finally calls the corresponding [FastConditionHandler], passing the
  /// result of the condition matching.
  void testConditions() {
    final FastFormField<T>(:conditions) = widget;
    if (conditions == null || conditions.isEmpty) return;

    for (final MapEntry(key: handler, value: list) in conditions.entries) {
      final FastConditionList(:conditions, :match) = list;
      final bool isMet;

      switch (match) {
        case FastConditionMatch.any:
          isMet = conditions.any(_testCondition);
        case FastConditionMatch.every:
          isMet = conditions.every(_testCondition);
      }

      handler(isMet, this);
    }
  }

  bool _testCondition(FastCondition condition) {
    final FastCondition(:target, :test) = condition;
    final field = form?.getFieldByName(target);
    if (field == null) throw ArgumentError('Target $target is null.');

    return test(field.value, field);
  }

  void _onFocusChanged() {
    setState(() {
      if (focusNode.hasFocus) {
        focused = true;
      } else {
        focused = false;
        wasTouched();
      }
    });
  }
}

typedef FastWidgetBuilder<State extends FastFormFieldState> = Widget? Function(
    State field);

/// A function typically used for building a [CupertinoFormRow] error widget.
///
/// Returns a [Text] widget when [FastFormFieldState.errorText] is a [String]
/// otherwise `null`.
Text? cupertinoErrorBuilder<T>(FastFormFieldState<T> field) {
  final FastFormFieldState<T>(:errorText) = field;
  return errorText is String ? Text(errorText) : null;
}

/// A function typically used for building a [CupertinoFormRow] helper widget.
///
/// Returns a [Text] widget when [FastFormField.helperText] is a [String]
/// otherwise `null`.
Text? cupertinoHelperBuilder<T>(FastFormFieldState<T> field) {
  final FastFormField<T>(:helperText) = field.widget;
  return helperText is String ? Text(helperText) : null;
}

/// A function typically used for building a [CupertinoFormRow] error widget.
///
/// Returns a [Text] widget when [FastFormField.labelText] is a [String]
/// otherwise `null`.
Text? cupertinoPrefixBuilder<T>(FastFormFieldState<T> field) {
  final FastFormField<T>(:labelText) = field.widget;
  return labelText is String ? Text(labelText) : null;
}
