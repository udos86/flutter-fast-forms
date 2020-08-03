import 'package:flutter/material.dart';

typedef FormFieldBuilder<T> = Widget Function(
    BuildContext context, FormFieldModelState state, FormFieldModel model);

@immutable
abstract class FormFieldModel<T> extends StatefulWidget {
  const FormFieldModel({
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

  final FormFieldBuilder builder;
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

class FormFieldModelState<T> extends State<FormFieldModel> {
  T value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this, widget);
  }

  bool get autovalidate => true;

  void reset() {
    this.value = widget.initialValue;
  }

  void save(T value) {
    this.value = value;
  }
}
