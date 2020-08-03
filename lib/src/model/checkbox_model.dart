import 'package:flutter/material.dart';

import '../widget/checkbox-form-field.dart';

import 'form_field_model.dart';

@immutable
class CheckboxModel extends FormFieldModel<bool> {
  CheckboxModel({
    builder,
    decoration,
    helper,
    hint,
    id,
    bool initialValue,
    label,
    this.title,
    validator,
  }) : super(
          builder: builder ??
              (context, form, model) {
                return CheckboxFormField(
                  decoration:
                      decoration ?? form.buildInputDecoration(context, model),
                  title: title,
                  value: form.getFieldValue(id),
                  validator: validator,
                  onChanged: (value) => form.save(id, value),
                );
              },
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final String title;
}
