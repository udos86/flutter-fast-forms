import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastRangeSliderLabelsBuilder = RangeLabels Function(
    FastRangeSliderState field);

typedef FastRangeSliderFixBuilder = Widget Function(FastRangeSliderState field);

@immutable
class FastRangeSlider extends FastFormField<RangeValues> {
  FastRangeSlider({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<RangeValues>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    RangeValues? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<RangeValues>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<RangeValues>? onSaved,
    FormFieldValidator<RangeValues>? validator,
    this.divisions,
    this.labelsBuilder,
    this.max = 1.0,
    this.min = 0.0,
    this.prefixBuilder,
    this.suffixBuilder,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? rangeSliderBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          key: key,
          initialValue: initialValue ?? RangeValues(min, max),
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final int? divisions;
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

SizedBox rangeSliderPrefixBuilder(FastRangeSliderState field) {
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

SizedBox rangeSliderSuffixBuilder(FastRangeSliderState field) {
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

InputDecorator rangeSliderBuilder(FormFieldState<RangeValues> field) {
  final widget = (field as FastRangeSliderState).widget;

  return InputDecorator(
    decoration: field.decoration.copyWith(
      contentPadding: widget.contentPadding,
      errorText: field.errorText,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder!(field),
        Expanded(
          child: RangeSlider(
            divisions: widget.divisions,
            labels: widget.labelsBuilder?.call(field),
            max: widget.max,
            min: widget.min,
            values: field.value!,
            onChanged: widget.enabled ? field.didChange : null,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
      ],
    ),
  );
}
