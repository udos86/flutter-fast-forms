import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_theme.dart';

import 'date_picker_form_field.dart';

@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    bool autofocus,
    AutovalidateMode autovalidateMode,
    FastFormFieldBuilder builder,
    this.cancelText,
    this.confirmText,
    InputDecoration decoration,
    bool enabled,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    @required this.firstDate,
    this.format,
    String helper,
    this.helpText,
    this.icon,
    @required String id,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    DateTime initialValue,
    String label,
    @required this.lastDate,
    this.textBuilder,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus ?? false,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          builder: builder ?? fastDatePickerBuilder,
          decoration: decoration,
          enabled: enabled ?? true,
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
  final Icon icon;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;
  final DatePickerTextBuilder textBuilder;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<DateTime>();
}

final FastFormFieldBuilder fastDatePickerBuilder = (context, state) {
  final theme = FastFormTheme.of(context);
  final widget = state.widget as FastDatePicker;
  final decoration = widget.decoration ??
      theme?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return DatePickerFormField(
    autovalidateMode: widget.autovalidateMode,
    cancelText: widget.cancelText,
    confirmText: widget.confirmText,
    decoration: decoration,
    enabled: widget.enabled,
    errorFormatText: widget.errorFormatText,
    errorInvalidText: widget.errorInvalidText,
    fieldHintText: widget.fieldHintText,
    fieldLabelText: widget.fieldLabelText,
    firstDate: widget.firstDate,
    format: widget.format,
    helpText: widget.helpText,
    icon: widget.icon,
    initialDatePickerMode: widget.initialDatePickerMode,
    initialEntryMode: widget.initialEntryMode,
    initialValue: widget.initialValue,
    lastDate: widget.lastDate,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    textBuilder: widget.textBuilder,
    validator: widget.validator,
  );
};
