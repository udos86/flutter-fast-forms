import 'package:flutter/material.dart';

import '../form_builder.dart';
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
              (context, state, model) {
                return DateTimeFormField(
                  decoration: decoration ??
                      FormBuilder.buildInputDecoration(context, model),
                  firstDate: firstDate,
                  lastDate: lastDate,
                  value: state.value,
                  validator: validator,
                  onChanged: (value) => state.save(value),
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

  @override
  State<StatefulWidget> createState() => FormFieldModelState<DateTime>();
}
