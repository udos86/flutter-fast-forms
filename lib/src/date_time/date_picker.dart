import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'date_picker_form_field.dart';

@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    bool autofocus = false,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    @required String id,
    DateTime initialValue,
    String label,
    FormFieldValidator validator,
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    @required this.firstDate,
    this.format,
    this.helpText,
    this.initialDatePickerMode,
    this.initialEntryMode,
    @required this.lastDate,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? _builder,
          decoration: decoration,
          helper: helper,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final String cancelText;
  final String confirmText;
  final String errorFormatText;
  final String errorInvalidText;
  final String fieldHintText;
  final String fieldLabelText;
  final DateTime firstDate;
  final DateFormat format;
  final String helpText;
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
    cancelText: widget.cancelText,
    confirmText: widget.confirmText,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    errorFormatText: widget.errorFormatText,
    errorInvalidText: widget.errorInvalidText,
    fieldHintText: widget.fieldHintText,
    fieldLabelText: widget.fieldLabelText,
    firstDate: widget.firstDate,
    helpText: widget.helpText,
    lastDate: widget.lastDate,
    format: widget.format,
    value: state.value,
    validator: widget.validator,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
  );
};
