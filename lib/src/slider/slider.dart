import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../form.dart';

typedef FastSliderLabelBuilder = String Function(FastSliderState field);

typedef FastSliderWidgetBuilder = FastWidgetBuilder<FastSliderState>;

/// A [FastFormField] that contains either a [Slider.adaptive] or a
/// [CupertinoSlider].
@immutable
class FastSlider extends FastFormField<double> {
  const FastSlider({
    @Deprecated('Use cupertinoErrorBuilder instead.')
    FastSliderWidgetBuilder? errorBuilder,
    @Deprecated('Use cupertinoHelperBuilder instead.')
    FastSliderWidgetBuilder? helperBuilder,
    FastSliderWidgetBuilder cupertinoErrorBuilder = sliderErrorBuilder,
    FastSliderWidgetBuilder cupertinoHelperBuilder = sliderHelperBuilder,
    double? initialValue,
    super.adaptive,
    super.autovalidateMode,
    super.builder = sliderBuilder,
    super.conditions,
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
    this.cupertinoPrefixBuilder = sliderPrefixBuilder,
    this.divisions,
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
  })  : cupertinoErrorBuilder = helperBuilder ?? cupertinoErrorBuilder,
        cupertinoHelperBuilder = helperBuilder ?? cupertinoHelperBuilder,
        super(initialValue: initialValue ?? min);

  final Color? activeColor;
  final SliderInteraction? allowedInteraction;
  final bool autofocus;
  final FastSliderWidgetBuilder cupertinoErrorBuilder;
  final FastSliderWidgetBuilder cupertinoHelperBuilder;
  final FastSliderWidgetBuilder cupertinoPrefixBuilder;
  final int? divisions;
  final Color? inactiveColor;
  final FastSliderLabelBuilder? labelBuilder;
  final double max;
  final double min;
  final MouseCursor? mouseCursor;
  final ValueChanged<double>? onChangeEnd;
  final ValueChanged<double>? onChangeStart;
  final MaterialStateProperty<Color?>? overlayColor;
  final FastSliderWidgetBuilder? prefixBuilder;
  final Color? secondaryActiveColor;
  final double? secondaryTrackValue;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final bool showInputDecoration;
  final FastSliderWidgetBuilder? suffixBuilder;
  final Color? thumbColor;

  @override
  FastSliderState createState() => FastSliderState();
}

/// State associated with a [FastSlider] widget.
class FastSliderState extends FastFormFieldState<double> {
  @override
  FastSlider get widget => super.widget as FastSlider;
}

/// A function that is the default [FastSlider.cupertinoErrorBuilder].
///
/// Uses [cupertinoErrorBuilder].
Widget? sliderErrorBuilder(FastSliderState field) {
  return cupertinoErrorBuilder(field);
}

/// A function that is the default [FastSlider.cupertinoHelperBuilder].
///
/// Uses [cupertinoHelperBuilder].
Widget? sliderHelperBuilder(FastSliderState field) {
  return cupertinoHelperBuilder(field);
}

/// A function that is the default [FastSlider.cupertinoPrefixBuilder].
///
/// Uses [cupertinoPrefixBuilder].
Widget? sliderPrefixBuilder(FastSliderState field) {
  return cupertinoPrefixBuilder(field);
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
  final FastSliderState(:decoration, :didChange, :enabled, :value!, :widget) =
      field;

  final prefix = widget.prefixBuilder?.call(field);
  final suffix = widget.suffixBuilder?.call(field);

  final slider = Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      if (prefix is Widget) prefix,
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
          onChanged: enabled ? didChange : null,
          onChangeStart: widget.onChangeStart,
          overlayColor: widget.overlayColor,
          secondaryActiveColor: widget.secondaryActiveColor,
          secondaryTrackValue: widget.secondaryTrackValue,
          semanticFormatterCallback: widget.semanticFormatterCallback,
          thumbColor: widget.thumbColor,
          value: value,
        ),
      ),
      if (suffix is Widget) suffix,
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
  final FastSliderState(:didChange, :enabled, :value!, :widget) = field;

  final prefix = widget.prefixBuilder?.call(field);
  final suffix = widget.suffixBuilder?.call(field);

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.cupertinoPrefixBuilder(field),
    helper: widget.cupertinoHelperBuilder(field),
    error: widget.cupertinoErrorBuilder(field),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (prefix is Widget) prefix,
        Expanded(
          child: CupertinoSlider(
            activeColor: widget.activeColor,
            divisions: widget.divisions,
            max: widget.max,
            min: widget.min,
            thumbColor: widget.thumbColor ?? CupertinoColors.white,
            onChanged: enabled ? didChange : null,
            onChangeEnd: widget.onChangeEnd,
            onChangeStart: widget.onChangeStart,
            value: value,
          ),
        ),
        if (suffix is Widget) suffix,
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
