import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'slider_form_field.dart';

@immutable
class FastSlider extends FastFormField<double> {
  FastSlider({
    bool autofocus,
    AutovalidateMode autovalidateMode,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    this.divisions,
    bool enabled,
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
          autofocus: autofocus ?? false,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          builder: builder ?? _builder,
          decoration: decoration,
          enabled: enabled ?? true,
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
  final decoration = widget.decoration ??
      style?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return SliderFormField(
    autofocus: widget.autofocus,
    autovalidateMode: widget.autovalidateMode,
    decoration: decoration,
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
