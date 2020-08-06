import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:provider/provider.dart';

typedef FastFormFieldBuilder = Widget Function(
    BuildContext context, FastFormFieldState state);

@immutable
abstract class FastFormField<T> extends StatefulWidget {
  const FastFormField({
    this.autofocus = false,
    @required this.builder,
    this.decoration,
    this.enabled = true,
    this.helper,
    @required this.id,
    this.initialValue,
    this.label,
    this.validator,
  });

  final bool autofocus;
  final FastFormFieldBuilder builder;
  final InputDecoration decoration;
  final bool enabled;
  final String helper;
  final String id;
  final T initialValue;
  final String label;
  final FormFieldValidator validator;

  T get value => initialValue;
}

class FastFormFieldState<T> extends State<FastFormField> {
  bool focused = false;
  bool touched = false;

  T value;
  FocusNode focusNode;

  bool get autovalidate => touched;

  FastFormStore get store => Provider.of<FastFormStore>(context, listen: false);

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(_onFocusChanged);
    value = store.getValue(widget.id) ?? widget.value;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }

  void reset() {
    this.focused = false;
    this.touched = false;
    this.value = widget.initialValue;
  }

  void markAsFocused([bool focused = true]) {
    if (this.focused != focused) {
      setState(() => this.focused = focused);
    }
  }

  void markAsTouched([bool touched = true]) {
    if (this.touched != touched) {
      setState(() => this.touched = touched);
    }
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus) {
      markAsFocused();
    } else {
      markAsFocused(false);
      if (!touched) markAsTouched();
    }
  }

  void onSaved(T value) {
    _store(value);
  }

  void onChanged(T value) {
    if (!this.touched) markAsTouched();
    _store(value);
  }

  void onTouched() {
    markAsTouched();
  }

  void _store(T value) {
    this.value = value;
    store.setValue(widget.id, value);
  }
}
