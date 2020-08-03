import 'package:flutter/material.dart';

import '../form_container.dart';

typedef FormFieldBuilder<T> = Widget Function(
    BuildContext context, FormContainerState state, FormFieldModel model);

@immutable
class FormFieldModel<T> {
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
