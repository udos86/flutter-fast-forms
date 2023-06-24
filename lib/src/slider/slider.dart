import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

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
    super.restorationId,
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
    this.onChangeEnd,
    this.onChangeStart,
    this.overlayColor,
    this.prefixBuilder,
    this.semanticFormatterCallback,
    this.secondaryActiveColor,
    this.secondaryTrackValue,
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
  final ValueChanged<double>? onChangeEnd;
  final ValueChanged<double>? onChangeStart;
  final MaterialStateProperty<Color?>? overlayColor;
  final FastSliderFixBuilder? prefixBuilder;
  final Color? secondaryActiveColor;
  final double? secondaryTrackValue;
  final SemanticFormatterCallback? semanticFormatterCallback;
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

Widget materialSliderBuilder(FormFieldState<double> field) {
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
            onChangeEnd: widget.onChangeEnd,
            onChanged: widget.enabled ? field.didChange : null,
            onChangeStart: widget.onChangeStart,
            overlayColor: widget.overlayColor,
            secondaryActiveColor: widget.secondaryActiveColor,
            secondaryTrackValue: widget.secondaryTrackValue,
            semanticFormatterCallback: widget.semanticFormatterCallback,
            thumbColor: widget.thumbColor,
            value: field.value!,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
      ],
    ),
  );
}

Widget cupertinoSliderBuilder(FormFieldState<double> field) {
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
            onChanged: widget.enabled ? field.didChange : null,
            onChangeEnd: widget.onChangeEnd,
            onChangeStart: widget.onChangeStart,
            value: field.value!,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(field),
      ],
    ),
  );
}

Widget sliderBuilder(FormFieldState<double> field) {
  var builder = materialSliderBuilder;

  if ((field as FastSliderState).adaptive) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        builder = cupertinoSliderBuilder;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
        builder = materialSliderBuilder;
        break;
    }
  }

  return builder(field);
}
