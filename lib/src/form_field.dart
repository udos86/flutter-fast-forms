import 'package:flutter/material.dart';

import 'form.dart';
import 'form_scope.dart';

typedef FastErrorBuilder<T> = Widget? Function(FastFormFieldState<T> field);
typedef FastHelperBuilder<T> = Widget? Function(FastFormFieldState<T> field);

@immutable
abstract class FastFormField<T> extends FormField<T> {
  const FastFormField({
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    bool enabled = true,
    required FormFieldBuilder<T> builder,
    T? initialValue,
    Key? key,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    this.adaptive,
    this.autofocus = false,
    this.contentPadding,
    this.decoration,
    this.helperText,
    this.label,
    required this.name,
    this.onChanged,
    this.onReset,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: builder,
          enabled: enabled,
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
        );

  final bool? adaptive;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;
  final String? helperText;
  final String? label;
  final String name;
  final ValueChanged<T>? onChanged;
  final VoidCallback? onReset;
}

abstract class FastFormFieldState<T> extends FormFieldState<T> {
  bool focused = false;
  bool touched = false;

  late FocusNode focusNode;

  FastFormScope? formScope;

  @override
  @protected
  FastFormField<T> get widget;

  bool get adaptive => widget.adaptive ?? formScope?.adaptive ?? false;

  String get name => widget.name;

  InputDecoration get decoration {
    final theme = Theme.of(context);
    final decoration = widget.decoration ??
        formScope?.inputDecorator(context, widget) ??
        const InputDecoration();

    return decoration.applyDefaults(theme.inputDecorationTheme);
  }

  FastFormState? get formState => formScope?.formState;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode()..addListener(_onFocusChanged);
    setValue(widget.initialValue);
  }

  @override
  void deactivate() {
    super.deactivate();
    formState?.unregister(this);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    formScope = FastFormScope.of(context);
    formState?.register(this);
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
    formState?.updateValues();
  }

  void onReset() {
    setState(() {
      focused = false;
      touched = false;
      setValue(widget.initialValue);
      formState?.updateValues();
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
  return field.errorText is String ? Text(field.errorText!) : null;
}

Text? helperBuilder<T>(FastFormFieldState<T> field) {
  return field.widget.helperText is String
      ? Text(field.widget.helperText!)
      : null;
}
