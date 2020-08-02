import 'package:flutter/material.dart';

import 'form_field_model.dart';

enum FormFieldModelGroupOrientation {
  horizontal,
  vertical,
}

@immutable
class FormFieldModelGroup {
  FormFieldModelGroup({
    @required this.fields,
    this.orientation = FormFieldModelGroupOrientation.vertical,
    this.title,
  });

  final List<FormFieldModel> fields;
  final FormFieldModelGroupOrientation orientation;
  final String title;
}
