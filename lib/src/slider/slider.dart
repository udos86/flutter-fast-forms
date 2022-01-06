import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastSliderFixBuilder = Widget Function(FastSliderState field);

typedef FastSliderLabelBuilder = String Function(FastSliderState field);

@immutable
class FastSlider extends FastFormField<double> {
  const FastSlider({
    bool adaptive = true,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<double>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    FocusNode? focusNode,
    String? helperText,
    double? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<double>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<double>? onSaved,
    FormFieldValidator<double>? validator,
    this.divisions,
    this.errorBuilder,
    this.helperBuilder,
    this.max = 1.0,
    this.min = 0.0,
    this.labelBuilder,
    this.prefixBuilder,
    this.suffixBuilder,
  }) : super(
          adaptive: adaptive,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? adaptiveSliderBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue ?? min,
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final int? divisions;
  final FastErrorBuilder<double>? errorBuilder;
  final FastHelperBuilder<double>? helperBuilder;
  final FastSliderLabelBuilder? labelBuilder;
  final double max;
  final double min;
  final FastSliderFixBuilder? prefixBuilder;
  final FastSliderFixBuilder? suffixBuilder;

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

InputDecorator sliderBuilder(FormFieldState<double> field) {
  final widget = (field as FastSliderState).widget;

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
          child: Slider.adaptive(
            autofocus: widget.autofocus,
            divisions: widget.divisions,
            focusNode: field.focusNode,
            label: widget.labelBuilder?.call(field),
            max: widget.max,
            min: widget.min,
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
    prefix: widget.label is String ? Text(widget.label!) : null,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder!(field),
        Expanded(
          child: CupertinoSlider(
            divisions: widget.divisions,
            max: widget.max,
            min: widget.min,
            value: field.value!,
            onChanged: widget.enabled ? field.didChange : null,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
      ],
    ),
  );
}

Widget adaptiveSliderBuilder(FormFieldState<double> field) {
  field as FastSliderState;
  FormFieldBuilder<double> builder = sliderBuilder;

  if (field.adaptive) {
    final platform = Theme.of(field.context).platform;
    if (platform == TargetPlatform.iOS) builder = cupertinoSliderBuilder;
  }

  return builder(field);
}
