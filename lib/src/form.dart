import 'dart:collection';

import 'package:flutter/material.dart';

typedef FastInputDecorationBuilder = InputDecoration Function(
    FastFormFieldState field);

typedef FastFormChanged = void Function(
    UnmodifiableMapView<String, dynamic> values);

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
    this.onPopInvoked,
  });

  final bool adaptive;
  final bool? canPop;
  final List<Widget> children;
  final GlobalKey<FormState> formKey;
  final FastInputDecorationBuilder? inputDecorationBuilder;
  final InputDecorationTheme? inputDecorationTheme;
  final FastFormChanged? onChanged;
  final void Function(bool)? onPopInvoked;

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
/// [FastFormField] changes and passing an [UnmodifiableMapView] of all current
/// [values].
///
/// Typically obtained via [FastForm.of].
class FastFormState extends State<FastForm> {
  final Set<FastFormFieldState<dynamic>> _fields = {};

  UnmodifiableMapView<String, dynamic> get values {
    final map = {for (final field in _fields) field.widget.name: field.value};
    return UnmodifiableMapView(map);
  }

  void register(FastFormFieldState field) => _fields.add(field);

  void unregister(FastFormFieldState field) => _fields.remove(field);

  void onChanged() => widget.onChanged?.call(values);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      canPop: widget.canPop,
      onPopInvoked: widget.onPopInvoked,
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
    this.contentPadding,
    this.decoration,
    this.helperText,
    this.labelText,
    required this.name,
    this.onChanged,
    this.onReset,
  });

  /// null represents a non-adaptive form field widget
  final bool? adaptive;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;
  final String? helperText;
  final String? labelText;
  final String name;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onReset;
}

/// State associated with a [FastFormField] widget.
///
/// Works identical to built-in [FormFieldState].
///
/// Enhances [FormFieldState] by tracking [touched] state via [focusNode].
///
abstract class FastFormFieldState<T> extends FormFieldState<T> {
  /// Indicates if the [FastFormField] is currently focused.
  bool focused = false;

  /// Indicates if the user has touched the [FastFormField].
  ///
  /// The [FastFormField] must have been both focused and unfocused at least
  /// once to be marked as touched.
  bool touched = false;

  late FocusNode focusNode;

  /// Returns the [FastFormField] widget for this [FastFormFieldState] instance.
  /// Must be overriden in the concrete child class.
  @override
  @protected
  FastFormField<T> get widget;

  /// Returns if the [FastFormField.builder] should adapt to the
  /// [TargetPlatform] provided that the [FastFormField] type does support it
  bool get adaptive => widget.adaptive ?? form?.widget.adaptive ?? false;

  bool get enabled => widget.enabled;

  /// Returns the [FastFormState] of the parent [FastForm]
  FastFormState? get form => FastForm.of(context);

  /// Creates the [InputDecoration] based on the current theme and the
  /// corresponding [FastFormField] widget configuration
  InputDecoration get decoration {
    final theme = form?.widget.inputDecorationTheme ??
        Theme.of(context).inputDecorationTheme;

    final decoration = widget.decoration ??
        form?.widget.inputDecorationBuilder?.call(this) ??
        InputDecoration(
          contentPadding: widget.contentPadding ??
              const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          enabled: enabled,
          errorText: errorText,
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

  void onChanged(T? value) {
    if (!touched) setState(() => touched = true);
    setValue(value);
    widget.onChanged?.call(value);
    form?.onChanged();
  }

  void onReset() {
    setState(() {
      focused = false;
      touched = false;
      setValue(widget.initialValue);
      widget.onChanged?.call(widget.initialValue);
      form?.onChanged();
    });
  }

  void _onFocusChanged() {
    setState(() {
      if (focusNode.hasFocus) {
        focused = true;
      } else {
        focused = false;
        touched = true;
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
