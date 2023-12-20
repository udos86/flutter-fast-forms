import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form.dart';

/// A [FastFormField] that contains a [CupertinoSlidingSegmentedControl].
@immutable
class FastSegmentedButton<T> extends FastFormField<Set<T>> {
  FastSegmentedButton({
    FormFieldBuilder? builder,
    Set<T>? initialValue,
    super.autovalidateMode,
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
    this.emptySelectionAllowed = false,
    this.multiSelectionEnabled = false,
    required this.segments,
    this.selectedIcon,
    this.showInputDecoration = true,
    this.showSelectedIcon = true,
    this.style,
  })  : assert(segments.isNotEmpty),
        super(
          builder: builder ?? segmentedButtonBuilder,
          initialValue:
              initialValue ?? _getInitialValue(segments, emptySelectionAllowed),
        );

  final bool emptySelectionAllowed;
  final bool multiSelectionEnabled;
  final List<ButtonSegment<T>> segments;
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

/// Fallback for setting the default [FastRadioGroup.initialValue].
///
/// Returns the last [FastRadioOption.value] in [FastRadioGroup.options] where
/// [FastRadioOption.selected] is `true`. Otherwise returns the
/// [FastRadioOption.value] of the first element of [FastRadioGroup.options].
Set<T> _getInitialValue<T>(
    List<ButtonSegment<T>> segments, bool emptySelectionAllowed) {
  return emptySelectionAllowed ? const {} : {segments.first.value};
}

/// A [FormFieldBuilder] that is the default [FastSegmentedButton.builder].
///
/// Returns a [SegmentedButton] that contains the [FastSegmentedButton.segments]
/// on any [TargetPlatform].
Widget segmentedButtonBuilder<T>(FormFieldState<Set<T>> field) {
  final FastSegmentedButtonState<T>(:didChange, :value!, :widget) =
      field as FastSegmentedButtonState<T>;

  final button = SegmentedButton<T>(
    emptySelectionAllowed: widget.emptySelectionAllowed,
    multiSelectionEnabled: widget.multiSelectionEnabled,
    selectedIcon: widget.selectedIcon,
    showSelectedIcon: widget.showSelectedIcon,
    style: widget.style,
    segments: widget.segments,
    selected: value,
    onSelectionChanged: (newSelection) => didChange(newSelection),
  );

  if (widget.showInputDecoration) {
    return InputDecorator(
      decoration: field.decoration,
      child: button,
    );
  }

  return button;
}
