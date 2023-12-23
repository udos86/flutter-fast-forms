import 'package:flutter/material.dart';

import '../form.dart';

typedef FastRangeSliderLabelsBuilder = RangeLabels Function(
    FastRangeSliderState field);

typedef FastRangeSliderWidgetBuilder = FastWidgetBuilder<FastRangeSliderState>;

/// A [FastFormField] that contains a [RangeSlider].
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
    this.mouseCursor,
    this.onChangeEnd,
    this.onChangeStart,
    this.overlayColor,
    this.prefixBuilder,
    this.semanticFormatterCallback,
    this.showInputDecoration = true,
    this.suffixBuilder,
  }) : super(initialValue: initialValue ?? RangeValues(min, max));

  final Color? activeColor;
  final int? divisions;
  final Color? inactiveColor;
  final FastRangeSliderLabelsBuilder? labelsBuilder;
  final double max;
  final double min;
  final MaterialStateProperty<MouseCursor?>? mouseCursor;
  final void Function(RangeValues)? onChangeEnd;
  final void Function(RangeValues)? onChangeStart;
  final MaterialStateProperty<Color?>? overlayColor;
  final FastRangeSliderWidgetBuilder? prefixBuilder;
  final String Function(double)? semanticFormatterCallback;
  final bool showInputDecoration;
  final FastRangeSliderWidgetBuilder? suffixBuilder;

  @override
  FastRangeSliderState createState() => FastRangeSliderState();
}

/// State associated with a [FastRangeSlider] widget.
class FastRangeSliderState extends FastFormFieldState<RangeValues> {
  @override
  FastRangeSlider get widget => super.widget as FastRangeSlider;
}

/// A [FastRangeSliderLabelsBuilder] that is used as the default
/// [FastRangeSlider.labelsBuilder].
///
/// Returns [RangeLabels] by converting [RangeValues.start] and
/// [RangeValues.end] of the current [FastRangeSliderState.value] to a [String].
RangeLabels rangeSliderLabelsBuilder(FastRangeSliderState field) {
  final FastRangeSliderState(:value!) = field;
  return RangeLabels(
    value.start.toStringAsFixed(0),
    value.end.toStringAsFixed(0),
  );
}

/// A [FastRangeSliderPrefixBuilder] that is used as the default
/// [FastRangeSlider.prefixBuilder].
///
/// Returns a [SizedBox] that contains a centered [Text] widget that shows
/// [RangeValues.start] of the current [FastRangeSliderState.value] converted to
/// a [String].
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

/// A [FastRangeSliderSuffixBuilder] that is used as the default
/// [FastRangeSlider.suffixBuilder].
///
/// Returns a [SizedBox] that contains a centered [Text] widget that shows
/// [RangeValues.end] of the current [FastRangeSliderState.value] converted to
/// a [String].
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

/// A [FormFieldBuilder] that is used as the default [FastRangeSlider.builder].
///
/// Returns an [InputDecorator] that contains a [RangeSlider] on any
/// [TargetPlatform].
Widget rangeSliderBuilder(FormFieldState<RangeValues> field) {
  field as FastRangeSliderState;
  final FastRangeSliderState(:decoration, :didChange, :value!, :widget) = field;

  final prefix = widget.prefixBuilder?.call(field);
  final suffix = widget.suffixBuilder?.call(field);

  final rangeSlider = Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      if (prefix is Widget) prefix,
      Expanded(
        child: RangeSlider(
          activeColor: widget.activeColor,
          divisions: widget.divisions,
          inactiveColor: widget.inactiveColor,
          labels: widget.labelsBuilder?.call(field),
          max: widget.max,
          min: widget.min,
          mouseCursor: widget.mouseCursor,
          onChanged: widget.enabled ? didChange : null,
          onChangeEnd: widget.onChangeEnd,
          onChangeStart: widget.onChangeStart,
          overlayColor: widget.overlayColor,
          semanticFormatterCallback: widget.semanticFormatterCallback,
          values: value,
        ),
      ),
      if (suffix is Widget) suffix,
    ],
  );

  if (widget.showInputDecoration) {
    return InputDecorator(
      decoration: decoration,
      child: rangeSlider,
    );
  }

  return rangeSlider;
}
