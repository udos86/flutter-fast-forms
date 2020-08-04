import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'slider_form_field.dart';

@immutable
class FastSlider extends FastFormField<double> {
  FastSlider({
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    String hint,
    @required int id,
    double initialValue,
    String label,
    FormFieldValidator validator,
    this.divisions,
    @required this.max,
    @required this.min,
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

  final int divisions;
  final double max;
  final double min;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<double>();
}

final FastFormFieldBuilder _builder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastSlider;

  return SliderFormField(
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    divisions: widget.divisions,
    max: widget.max,
    min: widget.min,
    validator: widget.validator,
    value: state.value,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
  );
};
