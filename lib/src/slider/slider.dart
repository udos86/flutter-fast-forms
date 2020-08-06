import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'slider_form_field.dart';

@immutable
class FastSlider extends FastFormField<double> {
  FastSlider({
    bool autofocus = false,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    @required String id,
    double initialValue,
    String label,
    FormFieldValidator<double> validator,
    this.divisions,
    this.labelBuilder,
    @required this.max,
    @required this.min,
    this.prefixBuilder,
    this.suffixBuilder,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? _builder,
          decoration: decoration,
          helper: helper,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final int divisions;
  final SliderLabelBuilder labelBuilder;
  final double max;
  final double min;
  final SliderFixBuilder prefixBuilder;
  final SliderFixBuilder suffixBuilder;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<double>();
}

final FastFormFieldBuilder _builder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastSlider;

  return SliderFormField(
    autofocus: widget.autofocus,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    divisions: widget.divisions,
    focusNode: state.focusNode,
    labelBuilder: widget.labelBuilder,
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
