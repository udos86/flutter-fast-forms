import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'range_slider_form_field.dart';

@immutable
class FastRangeSlider extends FastFormField<RangeValues> {
  FastRangeSlider({
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    String hint,
    @required int id,
    RangeValues initialValue,
    String label,
    FormFieldValidator validator,
    this.divisions,
    this.labelsBuilder,
    @required this.max,
    @required this.min,
    this.prefixBuilder,
    this.suffixBuilder,
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
  final RangeSliderLabelsBuilder labelsBuilder;
  final double max;
  final double min;
  final RangeSliderFixBuilder prefixBuilder;
  final RangeSliderFixBuilder suffixBuilder;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<RangeValues>();
}

final FastFormFieldBuilder _builder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastRangeSlider;

  return RangeSliderFormField(
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    divisions: widget.divisions,
    labelsBuilder: widget.labelsBuilder,
    max: widget.max,
    min: widget.min,
    prefixBuilder: widget.prefixBuilder,
    suffixBuilder: widget.suffixBuilder,
    validator: widget.validator,
    value: state.value,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
  );
};
