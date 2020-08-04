import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'date_picker_form_field.dart';

@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    String hint,
    @required int id,
    DateTime initialValue,
    String label,
    FormFieldValidator validator,
    @required this.firstDate,
    this.format,
    this.initialDatePickerMode,
    this.initialEntryMode,
    @required this.lastDate,
  }) : super(
          builder: builder ?? _builder,
          decoration: decoration,
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

final FastFormFieldBuilder _builder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastDatePicker;

  return DatePickerFormField(
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    firstDate: widget.firstDate,
    lastDate: widget.lastDate,
    format: widget.format,
    value: state.value,
    validator: widget.validator,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
  );
};
