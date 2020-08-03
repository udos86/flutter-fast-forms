import 'package:flutter/material.dart';

typedef FormFieldWidgetBuilder<T> = Widget Function(
    BuildContext context, FastFormFieldState state);

@immutable
abstract class FastFormField<T> extends StatefulWidget {
  const FastFormField({
    @required this.builder,
    this.decoration,
    this.helper,
    this.hint,
    @required this.id,
    this.initialValue,
    this.label,
    this.savedValue,
    this.validator,
  });

  final FormFieldWidgetBuilder builder;
  final InputDecoration decoration;
  final String helper;
  final String hint;
  final int id;
  final T initialValue;
  final String label;
  final T savedValue;
  final FormFieldValidator validator;

  T get value => savedValue ?? initialValue;
}

class FastFormFieldState<T> extends State<FastFormField> {
  T value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }

  bool get autovalidate => true;

  void reset() {
    this.value = widget.initialValue;
  }

  void save(T value) {
    this.value = value;
  }
}
