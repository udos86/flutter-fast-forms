import 'package:flutter/material.dart';

import 'form.dart';
import 'form_scope.dart';

@immutable
abstract class FastFormField<T> extends FormField<T> {
  const FastFormField({
    this.adaptive = false,
    this.autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    @required FormFieldBuilder<T> builder,
    this.decoration,
    bool enabled = true,
    this.helper,
    @required this.id,
    T initialValue,
    Key key,
    this.label,
    this.onChanged,
    this.onReset,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: builder,
          enabled: enabled,
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
        );

  final bool adaptive;
  final bool autofocus;
  final InputDecoration decoration;
  final String helper;
  final String id;
  final String label;
  final ValueChanged<T> onChanged;
  final VoidCallback onReset;
}

class FastFormFieldState<T> extends FormFieldState<T> {
  bool focused = false;
  bool touched = false;

  FocusNode focusNode;

  @override
  FastFormField<T> get widget => super.widget as FastFormField<T>;

  FastFormState get formState => FastFormScope.of(context).formState;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode()..addListener(_onFocusChanged);
    setValue(widget.initialValue);
  }

  @override
  void deactivate() {
    super.deactivate();
    formState.unregister(this);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    formState.register(this);
    return super.build(context);
  }

  @override
  void didChange(T value) {
    super.didChange(value);
    onChanged(value);
  }

  @override
  void reset() {
    super.reset();
    onReset();
  }

  void onChanged(T value) {
    if (!touched) setState(() => touched = true);
    setValue(value);
    formState.update(this);
  }

  void onReset() {
    setState(() {
      focused = false;
      touched = false;
      setValue(widget.initialValue);
      formState.update(this);
    });
  }

  void onSaved(T value) {
    setValue(value);
    formState.update(this);
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
