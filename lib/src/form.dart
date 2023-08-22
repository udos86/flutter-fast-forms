import 'dart:collection';

import 'package:flutter/material.dart';

typedef FastInputDecorationBuilder = InputDecoration Function(
    FastFormFieldState field);

typedef FastFormChanged = void Function(
    UnmodifiableMapView<String, dynamic> values);

@immutable
class FastForm extends StatefulWidget {
  const FastForm({
    super.key,
    this.adaptive = false,
    required this.children,
    required this.formKey,
    this.inputDecorationBuilder,
    this.inputDecorationTheme,
    this.onChanged,
  });

  final bool adaptive;
  final List<Widget> children;
  final GlobalKey<FormState> formKey;
  final FastInputDecorationBuilder? inputDecorationBuilder;
  final InputDecorationTheme? inputDecorationTheme;
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
