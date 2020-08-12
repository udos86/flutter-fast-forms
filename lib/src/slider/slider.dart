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
    this.divisions,
    bool enabled = true,
    String helper,
    @required String id,
    double initialValue,
    String label,
    this.labelBuilder,
    @required this.max,
    @required this.min,
    this.prefixBuilder,
    this.suffixBuilder,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? _builder,
          decoration: decoration,
          enabled: enabled,
          helper: helper,
          id: id,
          initialValue: initialValue ?? min,
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
    autovalidate: state.autovalidate,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    divisions: widget.divisions,
    enabled: widget.enabled,
    focusNode: state.focusNode,
    initialValue: widget.initialValue,
    labelBuilder: widget.labelBuilder,
    max: widget.max,
    min: widget.min,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    prefixBuilder: widget.prefixBuilder,
    suffixBuilder: widget.suffixBuilder,
    validator: widget.validator,
  );
};
