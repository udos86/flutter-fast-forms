import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'date_picker_form_field.dart';

@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    builder,
    decoration,
    this.format,
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
              (context, state) {
                final style = FormStyle.of(context);
                return DatePickerFormField(
                  decoration: decoration ??
                      style.createInputDecoration(context, state.widget),
                  firstDate: firstDate,
                  lastDate: lastDate,
                  format: format,
                  value: state.value,
                  validator: validator,
                  onChanged: state.onChanged,
                  onSaved: state.onSaved,
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
  final DateFormat format;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<DateTime>();
}
