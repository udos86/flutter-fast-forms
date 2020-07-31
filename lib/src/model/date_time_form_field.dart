import 'package:flutter/material.dart';

import '../widget/datetime-form-field.dart';

import 'form_field_model.dart';

@immutable
class DateTimeFormFieldModel extends FormFieldModel<DateTime> {
  DateTimeFormFieldModel({
    builder,
    decoration,
    helper,
    hint,
    id,
    DateTime initialValue,
    label,
    validator,
    @required this.firstDate,
    @required this.lastDate,
  }) : super(
          builder: builder ??
              (context, form, model) {
                return DateTimeFormField(
                  decoration:
                      decoration ?? form.buildInputDecoration(context, model),
                  firstDate: firstDate,
                  lastDate: lastDate,
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

  final DateTime firstDate;
  final DateTime lastDate;
}
