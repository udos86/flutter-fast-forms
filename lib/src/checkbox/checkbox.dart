import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'checkbox_form_field.dart';

@immutable
class FastCheckbox extends FastFormField<bool> {
  FastCheckbox({
    builder,
    decoration,
    helper,
    hint,
    id,
    bool initialValue,
    label,
    this.title,
    validator,
  }) : super(
          builder: builder ??
              (context, state) {
                final style = FormStyle.of(context);
                return CheckboxFormField(
                  decoration: decoration ??
                      style.createInputDecoration(context, state.widget),
                  title: title,
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

  final String title;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<bool>();
}
