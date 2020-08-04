import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'time_picker_form_field.dart';

@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  FastTimePicker({
    builder,
    decoration,
    helper,
    hint,
    id,
    TimeOfDay initialValue,
    label,
    validator,
  }) : super(
          builder: builder ??
              (context, state) {
                final style = FormStyle.of(context);
                return TimePickerFormField(
                  decoration: decoration ??
                      style.createInputDecoration(context, state.widget),
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

  @override
  State<StatefulWidget> createState() => FastFormFieldState<TimeOfDay>();
}
