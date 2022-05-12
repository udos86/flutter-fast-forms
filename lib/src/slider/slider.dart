import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form.dart';

typedef FastSliderFixBuilder = Widget Function(FastSliderState field);

typedef FastSliderLabelBuilder = String Function(FastSliderState field);

@immutable
class FastSlider extends FastFormField<double> {
  const FastSlider({
    double? initialValue,
    super.adaptive,
    super.autovalidateMode,
    super.builder = sliderBuilder,
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
    super.validator,
    this.activeColor,
    this.autofocus = false,
    this.divisions,
    this.errorBuilder,
    this.helperBuilder,
    this.inactiveColor,
    this.max = 1.0,
    this.min = 0.0,
    this.mouseCursor,
    this.labelBuilder,
    this.prefixBuilder,
    this.suffixBuilder,
    this.thumbColor,
  }) : super(initialValue: initialValue ?? min);

  final Color? activeColor;
  final bool autofocus;
  final int? divisions;
  final FastErrorBuilder<double>? errorBuilder;
  final FastHelperBuilder<double>? helperBuilder;
  final Color? inactiveColor;
  final FastSliderLabelBuilder? labelBuilder;
  final double max;
  final double min;
  final MouseCursor? mouseCursor;
  final FastSliderFixBuilder? prefixBuilder;
  final FastSliderFixBuilder? suffixBuilder;
  final Color? thumbColor;

  @override
  FastSliderState createState() => FastSliderState();
}

class FastSliderState extends FastFormFieldState<double> {
  @override
  FastSlider get widget => super.widget as FastSlider;
}

String sliderLabelBuilder(FastSliderState field) {
  return field.value!.toStringAsFixed(0);
}

SizedBox sliderSuffixBuilder(FastSliderState field) {
  return SizedBox(
    width: 32.0,
    child: Text(
      field.value!.toStringAsFixed(0),
      style: const TextStyle(
        fontSize: 16.0,
      ),
    ),
  );
}

InputDecorator materialSliderBuilder(FormFieldState<double> field) {
  final widget = (field as FastSliderState).widget;

  return InputDecorator(
    decoration: field.decoration,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder!(field),
        Expanded(
          child: Slider.adaptive(
            activeColor: widget.activeColor,
            autofocus: widget.autofocus,
            divisions: widget.divisions,
            focusNode: field.focusNode,
            inactiveColor: widget.inactiveColor,
            label: widget.labelBuilder?.call(field),
            max: widget.max,
            min: widget.min,
            mouseCursor: widget.mouseCursor,
            thumbColor: widget.thumbColor,
            value: field.value!,
            onChanged: widget.enabled ? field.didChange : null,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
      ],
    ),
  );
}

CupertinoFormRow cupertinoSliderBuilder(FormFieldState<double> field) {
  final widget = (field as FastSliderState).widget;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.labelText is String ? Text(widget.labelText!) : null,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder!(field),
        Expanded(
          child: CupertinoSlider(
            activeColor: widget.activeColor,
            divisions: widget.divisions,
            max: widget.max,
            min: widget.min,
            thumbColor: widget.thumbColor ?? CupertinoColors.white,
            value: field.value!,
            onChanged: widget.enabled ? field.didChange : null,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
      ],
    ),
  );
}

Widget sliderBuilder(FormFieldState<double> field) {
  field as FastSliderState;
  FormFieldBuilder<double> builder = materialSliderBuilder;

  if (field.adaptive) {
    final platform = Theme.of(field.context).platform;
    if (platform == TargetPlatform.iOS) builder = cupertinoSliderBuilder;
  }

  return builder(field);
}
