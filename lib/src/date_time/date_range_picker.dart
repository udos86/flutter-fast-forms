import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'date_range_picker_form_field.dart';

@immutable
class FastDateRangePicker extends FastFormField<DateTimeRange> {
  FastDateRangePicker({
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    @required String id,
    DateTimeRange initialValue,
    String label,
    FormFieldValidator validator,
    this.cancelText,
    this.confirmText,
    this.currentDate,
    this.errorFormatText,
    this.errorInvalidRangeText,
    this.errorInvalidText,
    this.fieldEndHintText,
    this.fieldEndLabelText,
    this.fieldStartHintText,
    this.fieldStartLabelText,
    @required this.firstDate,
    this.format,
    this.helpText,
    this.initialEntryMode,
    @required this.lastDate,
  }) : super(
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
  final DateTime currentDate;
  final String errorFormatText;
  final String errorInvalidRangeText;
  final String errorInvalidText;
  final String fieldEndHintText;
  final String fieldEndLabelText;
  final String fieldStartHintText;
  final String fieldStartLabelText;
  final DateTime firstDate;
  final DateFormat format;
  final String helpText;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<DateTime>();
}

final FastFormFieldBuilder _builder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastDateRangePicker;

  return DateRangePickerFormField(
    cancelText: widget.cancelText,
    confirmText: widget.confirmText,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    errorFormatText: widget.errorFormatText,
    errorInvalidRangeText: widget.errorInvalidRangeText,
    errorInvalidText: widget.errorInvalidText,
    fieldEndHintText: widget.fieldEndHintText,
    fieldEndLabelText: widget.fieldEndLabelText,
    fieldStartHintText: widget.fieldStartHintText,
    fieldStartLabelText: widget.fieldStartLabelText,
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
