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
    this.cancelText,
    this.confirmText,
    InputDecoration decoration,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    @required this.firstDate,
    this.format,
    String helper,
    this.helpText,
    @required String id,
    this.initialDatePickerMode,
    this.initialEntryMode,
    DateTime initialValue,
    String label,
    @required this.lastDate,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? fastDatePickerBuilder,
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

final FastFormFieldBuilder fastDatePickerBuilder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastDatePicker;

  return DatePickerFormField(
    autovalidate: state.autovalidate,
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
