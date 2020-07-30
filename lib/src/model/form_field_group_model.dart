import 'package:flutter/material.dart';

import 'form_field_model.dart';

@immutable
class FormFieldGroup {
  FormFieldGroup({
    @required this.fields,
    this.title,
  });

  final List<FormFieldModel> fields;
  final String title;
}
