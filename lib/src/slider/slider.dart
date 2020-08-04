import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'slider_form_field.dart';

@immutable
class FastSlider extends FastFormField<double> {
  FastSlider({
    builder,
    decoration,
    this.divisions,
    helper,
    hint,
    id,
    double initialValue,
    label,
    @required this.max,
    @required this.min,
    validator,
  }) : super(
          builder: builder ??
              (context, state) {
                final style = FormStyle.of(context);
                return SliderFormField(
                  decoration: decoration ??
                      style.createInputDecoration(context, state.widget),
                  divisions: divisions,
                  max: max,
                  min: min,
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

  final int divisions;
  final double max;
  final double min;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<double>();
}
