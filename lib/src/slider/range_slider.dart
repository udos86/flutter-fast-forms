import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'range_slider_form_field.dart';

@immutable
class FastRangeSlider extends FastFormField<RangeValues> {
  FastRangeSlider({
    bool autofocus,
    AutovalidateMode autovalidateMode,
    this.divisions,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    bool enabled,
    String helper,
    @required String id,
    RangeValues initialValue,
    String label,
    this.labelsBuilder,
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
          initialValue: initialValue ?? RangeValues(min, max),
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
  final decoration = widget.decoration ??
      style?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return RangeSliderFormField(
    autovalidateMode: widget.autovalidateMode,
    decoration: decoration,
    divisions: widget.divisions,
    enabled: widget.enabled,
    initialValue: widget.initialValue,
    labelsBuilder: widget.labelsBuilder,
    max: widget.max,
    min: widget.min,
    prefixBuilder: widget.prefixBuilder,
    suffixBuilder: widget.suffixBuilder,
    validator: widget.validator,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
  );
};
