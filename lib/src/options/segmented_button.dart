import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form.dart';

/// A non-widget configuration class for a [ButtonSegment].
///
/// This wrapper is needed primarily to be able to set [ButtonSegment.enabled]
/// according to [FastFormFieldState.enabled].
@immutable
class FastButtonSegment<T> implements ButtonSegment<T> {
  const FastButtonSegment({
    required this.value,
    this.icon,
    this.label,
    this.tooltip,
    this.enabled = true,
  }) : assert(icon != null || label != null);

  @override
  final T value;
  @override
  final Widget? icon;
  @override
  final Widget? label;
  @override
  final String? tooltip;
  @override
  final bool enabled;
}

typedef FastSegmentedButtonSegmentsBuilder<T> = List<ButtonSegment<T>> Function(
    List<FastButtonSegment<T>> options, FastSegmentedButtonState<T> field);

/// A [FastFormField] that contains a [CupertinoSlidingSegmentedControl].
@immutable
class FastSegmentedButton<T> extends FastFormField<Set<T>> {
  FastSegmentedButton({
    FormFieldBuilder<Set<T>>? builder,
    Set<T>? initialValue,
    FastSegmentedButtonSegmentsBuilder<T>? segmentsBuilder,
    super.autovalidateMode,
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
    super.onTouched,
    super.restorationId,
    super.validator,
    this.direction = Axis.horizontal,
    this.emptySelectionAllowed = false,
    this.expandedInsets,
    this.multiSelectionEnabled = false,
    required this.segments,
    this.selectedIcon,
    this.showInputDecoration = true,
    this.showSelectedIcon = true,
    this.style,
  })  : assert(segments.isNotEmpty),
        segmentsBuilder = segmentsBuilder ?? buttonSegmentBuilder,
        super(
          builder: builder ?? segmentedButtonBuilder,
          initialValue:
              initialValue ?? _getInitialValue(segments, emptySelectionAllowed),
        );

  final Axis direction;
  final bool emptySelectionAllowed;
  final EdgeInsets? expandedInsets;
  final bool multiSelectionEnabled;
  final FastSegmentedButtonSegmentsBuilder<T> segmentsBuilder;
  final List<FastButtonSegment<T>> segments;
  final Icon? selectedIcon;
  final bool showInputDecoration;
  final bool showSelectedIcon;
  final ButtonStyle? style;

  @override
  FastSegmentedButtonState<T> createState() => FastSegmentedButtonState<T>();
}

/// State associated with a [FastSegmentedButton] widget.
class FastSegmentedButtonState<T> extends FastFormFieldState<Set<T>> {
  @override
  FastSegmentedButton<T> get widget => super.widget as FastSegmentedButton<T>;
}

/// Fallback for setting the default [FastSegmentedButton.initialValue].
///
/// Returns an empty [Set] when [FastSegmentedButton.emptySelectionAllowed].
/// Otherwise returns the [ButtonSegment.value] of the first element of
/// [FastSegmentedButton.segments].
Set<T> _getInitialValue<T>(
    List<ButtonSegment<T>> segments, bool emptySelectionAllowed) {
  return emptySelectionAllowed ? <T>{} : {segments.first.value};
}

List<ButtonSegment<T>> buttonSegmentBuilder<T>(
    List<FastButtonSegment<T>> segments, FastSegmentedButtonState<T> field) {
  return segments.fold(<ButtonSegment<T>>[], (list, segment) {
    final FastButtonSegment<T>(:enabled, :icon, :label, :tooltip, :value) =
        segment;
    final FastSegmentedButtonState<T>(enabled: fieldEnabled) = field;
    return list
      ..add(ButtonSegment(
        enabled: fieldEnabled && enabled,
        label: label,
        icon: icon,
        tooltip: tooltip,
        value: value,
      ));
  });
}

/// A [FormFieldBuilder] that is the default [FastSegmentedButton.builder].
///
/// Returns a [SegmentedButton] that contains the [FastSegmentedButton.segments]
/// on any [TargetPlatform].
Widget segmentedButtonBuilder<T>(FormFieldState<Set<T>> field) {
  field as FastSegmentedButtonState<T>;
  final FastSegmentedButtonState<T>(:didChange, :value!, :widget) = field;

  final segmentedButton = SegmentedButton<T>(
    direction: widget.direction,
    emptySelectionAllowed: widget.emptySelectionAllowed,
    expandedInsets: widget.expandedInsets,
    multiSelectionEnabled: widget.multiSelectionEnabled,
    segments: widget.segmentsBuilder(widget.segments, field),
    selectedIcon: widget.selectedIcon,
    selected: value,
    showSelectedIcon: widget.showSelectedIcon,
    style: widget.style,
    onSelectionChanged: (newSelection) => didChange(newSelection),
  );

  if (widget.showInputDecoration) {
    return InputDecorator(
      decoration: field.decoration,
      child: segmentedButton,
    );
  }

  return segmentedButton;
}
