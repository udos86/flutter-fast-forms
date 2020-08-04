import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'time_picker_form_field.dart';

@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  FastTimePicker({
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    String hint,
    @required int id,
    TimeOfDay initialValue,
    String label,
    FormFieldValidator validator,
  }) : super(
          builder: builder ?? _builder,
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  @override
  State<StatefulWidget> createState() => FastFormFieldState<TimeOfDay>();
}

final FastFormFieldBuilder _builder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastTimePicker;

  return TimePickerFormField(
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    validator: widget.validator,
    value: state.value,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
  );
};
