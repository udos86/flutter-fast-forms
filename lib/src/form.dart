import 'dart:collection';

import 'package:flutter/material.dart';

typedef FastInputDecorator = InputDecoration Function(
    ThemeData theme, FastFormFieldState field);

typedef FastFormChanged = void Function(
    UnmodifiableMapView<String, dynamic> values);

@immutable
class FastForm extends StatefulWidget {
  const FastForm({
    super.key,
    this.adaptive = false,
    required this.children,
    this.decorator,
    required this.formKey,
    this.onChanged,
  });

  final bool adaptive;
  final List<Widget> children;
  final FastInputDecorator? decorator;
  final GlobalKey<FormState> formKey;
  final FastFormChanged? onChanged;

  static FastFormState? of(BuildContext context) {
    final _FastFormScope? scope =
        context.dependOnInheritedWidgetOfExactType<_FastFormScope>();
    return scope?._formState;
  }

  @override
  FastFormState createState() => FastFormState();
}

class FastFormState extends State<FastForm> {
  final Set<FastFormFieldState<dynamic>> _fields = {};

  UnmodifiableMapView<String, dynamic> get values {
    return UnmodifiableMapView(
        {for (final field in _fields) field.widget.name: field.value});
  }

  void register(FastFormFieldState field) => _fields.add(field);

  void unregister(FastFormFieldState field) => _fields.remove(field);

  void onChanged() {
    widget.onChanged?.call(values);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // Current store cannot be retrieved here due to the framework calling
      // this before widget.onChanged().
      // onChanged: () =>,
      key: widget.formKey,
      child: _FastFormScope(
        formState: this,
        child: Column(
          children: widget.children,
        ),
      ),
    );
  }
}

class _FastFormScope extends InheritedWidget {
  const _FastFormScope({
    required super.child,
    required FastFormState formState,
  }) : _formState = formState;

  final FastFormState _formState;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

typedef FastErrorBuilder<T> = Widget? Function(FastFormFieldState<T> field);

typedef FastHelperBuilder<T> = Widget? Function(FastFormFieldState<T> field);

const defaultContentPadding = EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0);

@immutable
abstract class FastFormField<T> extends FormField<T> {
  const FastFormField({
    EdgeInsetsGeometry? contentPadding,
    bool? enabled,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    required super.builder,
    super.initialValue,
    super.key,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.adaptive,
    this.decoration,
    this.helperText,
    this.labelText,
    required this.name,
    this.onChanged,
    this.onReset,
  })  : contentPadding = contentPadding ?? defaultContentPadding,
        super(enabled: enabled ?? true);

  /// null represents a non-adaptive form field widget
  final bool? adaptive;
  final EdgeInsetsGeometry contentPadding;
  final InputDecoration? decoration;
  final String? helperText;
  final String? labelText;
  final String name;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onReset;
}

abstract class FastFormFieldState<T> extends FormFieldState<T> {
  bool focused = false;
  bool touched = false;

  late FocusNode focusNode;

  @override
  @protected
  FastFormField<T> get widget;

  bool get adaptive => widget.adaptive ?? form?.widget.adaptive ?? false;

  bool get enabled => widget.enabled;

  FastFormState? get form => FastForm.of(context);

  InputDecoration get decoration {
    final theme = Theme.of(context);
    final decoration = widget.decoration ??
        form?.widget.decorator?.call(theme, this) ??
        _decorator(theme, this);

    return decoration.applyDefaults(theme.inputDecorationTheme);
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()..addListener(_onFocusChanged);
    setValue(widget.initialValue);
  }

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

Text? errorBuilder<T>(FastFormFieldState<T> field) {
  final text = field.errorText;
  return text is String ? Text(text) : null;
}

Text? helperBuilder<T>(FastFormFieldState<T> field) {
  final text = field.widget.helperText;
  return text is String ? Text(text) : null;
}

InputDecoration _decorator(ThemeData theme, FastFormFieldState field) {
  final widget = field.widget;

  return InputDecoration(
    contentPadding: widget.contentPadding,
    errorText: field.errorText,
    helperText: widget.helperText,
    labelText: widget.labelText,
    labelStyle: TextStyle(
      color: field.enabled
          ? theme.textTheme.bodyLarge!.color
          : theme.disabledColor,
    ),
    enabled: field.enabled,
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: theme.disabledColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: theme.primaryColor, width: 2),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[500]!, width: 2),
    ),
    filled: false,
    fillColor: Colors.white,
  );
}
