import 'package:flutter/material.dart';

import '../form_container.dart';

typedef FormFieldModelBuilder<T> = Widget Function(
    BuildContext context, FormContainerState state, FormFieldModel model);

@immutable
class FormFieldModel<T> {
  const FormFieldModel({
    @required this.builder,
    this.helper,
    this.hint,
    @required this.id,
    this.initialValue,
    this.label,
    this.validator,
    this.value,
  });

  final FormFieldModelBuilder builder;
  final String helper;
  final String hint;
  final int id;
  final T initialValue;
  final String label;
  final FormFieldValidator validator;
  final T value;
}
