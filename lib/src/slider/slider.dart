import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../form.dart';

typedef FastSliderLabelBuilder = String Function(FastSliderState field);

typedef FastSliderPrefixBuilder = Widget Function(FastSliderState field);

typedef FastSliderSuffixBuilder = Widget Function(FastSliderState field);

/// A [FastFormField] that contains either a [Slider.adaptive] or a
/// [CupertinoSlider].
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
    super.restorationId,
    super.validator,
    this.activeColor,
    this.allowedInteraction,
    this.autofocus = false,
    this.divisions,
    this.errorBuilder,
    this.helperBuilder,
    this.inactiveColor,
    this.max = 1.0,
    this.min = 0.0,
    this.mouseCursor,
    this.labelBuilder,
    this.onChangeEnd,
    this.onChangeStart,
    this.overlayColor,
    this.prefixBuilder,
    this.semanticFormatterCallback,
    this.secondaryActiveColor,
    this.secondaryTrackValue,
    this.showInputDecoration = true,
    this.suffixBuilder,
    this.thumbColor,
  }) : super(initialValue: initialValue ?? min);

  final Color? activeColor;
  final SliderInteraction? allowedInteraction;
  final bool autofocus;
  final int? divisions;
  final FastErrorBuilder<double>? errorBuilder;
  final FastHelperBuilder<double>? helperBuilder;
  final Color? inactiveColor;
  final FastSliderLabelBuilder? labelBuilder;
  final double max;
  final double min;
  final MouseCursor? mouseCursor;
  final ValueChanged<double>? onChangeEnd;
  final ValueChanged<double>? onChangeStart;
  final MaterialStateProperty<Color?>? overlayColor;
  final FastSliderPrefixBuilder? prefixBuilder;
  final Color? secondaryActiveColor;
  final double? secondaryTrackValue;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final bool showInputDecoration;
  final FastSliderSuffixBuilder? suffixBuilder;
  final Color? thumbColor;

  @override
  FastSliderState createState() => FastSliderState();
}

/// State associated with a [FastSlider] widget.
class FastSliderState extends FastFormFieldState<double> {
  @override
  FastSlider get widget => super.widget as FastSlider;
}

/// A [FastSliderLabelBuilder] that is the default [FastSlider.labelBuilder].
///
/// Returns the current [FastSliderState.value] converted to a [String].
String sliderLabelBuilder(FastSliderState field) {
  return field.value!.toStringAsFixed(0);
}

/// A [FastSliderLabelBuilder].
///
/// Returns a [SizedBox] that contains a [Text] widget that shows
/// the current [FastSliderState.value] converted to a [String].
Widget sliderSuffixBuilder(FastSliderState field) {
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

/// The default [FastSlider] Material [FormFieldBuilder].
///
/// Returns an [InputDecorator] that contains an expanded [Slider.adaptive]
/// as the only child of a [Row].
Widget materialSliderBuilder(FormFieldState<double> field) {
  field as FastSliderState;
  final FastSliderState(:decoration, :didChange, :value!, :widget) = field;

  final slider = Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      if (widget.prefixBuilder != null) widget.prefixBuilder!(field),
      Expanded(
        child: Slider.adaptive(
          activeColor: widget.activeColor,
          allowedInteraction: widget.allowedInteraction,
          autofocus: widget.autofocus,
          divisions: widget.divisions,
          focusNode: field.focusNode,
          inactiveColor: widget.inactiveColor,
          label: widget.labelBuilder?.call(field),
          max: widget.max,
          min: widget.min,
          mouseCursor: widget.mouseCursor,
          onChangeEnd: widget.onChangeEnd,
          onChanged: widget.enabled ? didChange : null,
          onChangeStart: widget.onChangeStart,
          overlayColor: widget.overlayColor,
          secondaryActiveColor: widget.secondaryActiveColor,
          secondaryTrackValue: widget.secondaryTrackValue,
          semanticFormatterCallback: widget.semanticFormatterCallback,
          thumbColor: widget.thumbColor,
          value: value,
        ),
      ),
      if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
    ],
  );

  if (widget.showInputDecoration) {
    return InputDecorator(
      decoration: decoration,
      child: slider,
    );
  }

  return slider;
}

/// The default [FastSlider] Cupertino [FormFieldBuilder].
///
/// Returns a [CupertinoFormRow] that contains an expanded [CupertinoSlider]
/// as the only child of a [Row].
Widget cupertinoSliderBuilder(FormFieldState<double> field) {
  field as FastSliderState;
  final FastSliderState(:didChange, :value!, :widget) = field;

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
            onChanged: widget.enabled ? didChange : null,
            onChangeEnd: widget.onChangeEnd,
            onChangeStart: widget.onChangeStart,
            value: value,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
      ],
    ),
  );
}

/// A [FormFieldBuilder] that is the default [FastSlider.builder].
///
/// Uses [materialSliderBuilder] by default on any [TargetPlatform].
///
/// Uses [cupertinoSliderBuilder] on [TargetPlatform.iOS] when
/// [FastSliderState.adaptive] is true.
Widget sliderBuilder(FormFieldState<double> field) {
  field as FastSliderState;

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS when field.adaptive:
      return cupertinoSliderBuilder(field);
    default:
      return materialSliderBuilder(field);
  }
}
