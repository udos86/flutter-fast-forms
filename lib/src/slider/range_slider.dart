import 'package:flutter/material.dart';

import '../form.dart';

typedef FastRangeSliderLabelsBuilder = RangeLabels Function(
    FastRangeSliderState field);

typedef FastRangeSliderFixBuilder = Widget Function(FastRangeSliderState field);

@immutable
class FastRangeSlider extends FastFormField<RangeValues> {
  FastRangeSlider({
    RangeValues? initialValue,
    super.autovalidateMode,
    super.builder = rangeSliderBuilder,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.activeColor,
    this.divisions,
    this.inactiveColor,
    this.labelsBuilder,
    this.max = 1.0,
    this.min = 0.0,
    this.prefixBuilder,
    this.suffixBuilder,
  }) : super(initialValue: initialValue ?? RangeValues(min, max));

  final Color? activeColor;
  final int? divisions;
  final Color? inactiveColor;
  final FastRangeSliderLabelsBuilder? labelsBuilder;
  final double max;
  final double min;
  final FastRangeSliderFixBuilder? prefixBuilder;
  final FastRangeSliderFixBuilder? suffixBuilder;

  @override
  FastRangeSliderState createState() => FastRangeSliderState();
}

class FastRangeSliderState extends FastFormFieldState<RangeValues> {
  @override
  FastRangeSlider get widget => super.widget as FastRangeSlider;
}

RangeLabels rangeSliderLabelsBuilder(FastRangeSliderState field) {
  return RangeLabels(
    field.value!.start.toStringAsFixed(0),
    field.value!.end.toStringAsFixed(0),
  );
}

Widget rangeSliderPrefixBuilder(FastRangeSliderState field) {
  return SizedBox(
    width: 48.0,
    child: Center(
      child: Text(
        field.value!.start.toStringAsFixed(0),
        style: const TextStyle(fontSize: 16.0),
      ),
    ),
  );
}

Widget rangeSliderSuffixBuilder(FastRangeSliderState field) {
  return SizedBox(
    width: 48.0,
    child: Center(
      child: Text(
        field.value!.end.toStringAsFixed(0),
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
    ),
  );
}

Widget rangeSliderBuilder(FormFieldState<RangeValues> field) {
  final widget = (field as FastRangeSliderState).widget;

  return InputDecorator(
    decoration: field.decoration,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder!(field),
        Expanded(
          child: RangeSlider(
            activeColor: widget.activeColor,
            divisions: widget.divisions,
            inactiveColor: widget.inactiveColor,
            labels: widget.labelsBuilder?.call(field),
            max: widget.max,
            min: widget.min,
            onChanged: widget.enabled ? field.didChange : null,
            values: field.value!,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
      ],
    ),
  );
}
