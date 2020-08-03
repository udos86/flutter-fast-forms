import 'package:flutter/material.dart';

import '../widget/date-time-form-field.dart';

import 'form_field_model.dart';

@immutable
class DateTimeModel extends FormFieldModel<DateTime> {
  DateTimeModel({
    builder,
    decoration,
    helper,
    hint,
    id,
    DateTime initialValue,
    label,
    validator,
    @required this.firstDate,
    this.initialDatePickerMode,
    this.initialEntryMode,
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
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;
}
