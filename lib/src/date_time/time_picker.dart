import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'time_picker_form_field.dart';

@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  FastTimePicker({
    bool autofocus = false,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    bool enabled = true,
    String helper,
    this.icon,
    @required String id,
    TimeOfDay initialValue,
    String label,
    this.textBuilder,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? fastTimePickerBuilder,
          enabled: enabled,
          helper: helper,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final Icon icon;
  final TimePickerTextBuilder textBuilder;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<TimeOfDay>();
}

final FastFormFieldBuilder fastTimePickerBuilder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastTimePicker;

  return TimePickerFormField(
    autovalidate: state.autovalidate,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    enabled: widget.enabled,
    icon: widget.icon,
    initialValue: widget.initialValue,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    textBuilder: widget.textBuilder,
    validator: widget.validator,
  );
};
