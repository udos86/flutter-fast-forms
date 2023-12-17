import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form.dart';

/// A single [FastRadioGroup] option.
@immutable
class FastRadioOption<T> {
  const FastRadioOption({
    this.isThreeLine = false,
    this.secondary,
    this.selected = false,
    this.subtitle,
    this.title,
    required this.value,
    this.visualDensity,
  });

  final bool isThreeLine;
  final Widget? secondary;
  final bool selected;
  final Widget? subtitle;
  final Widget? title;
  final T value;
  final VisualDensity? visualDensity;
}

typedef FastRadioOptionBuilder<T> = Widget Function(
    FastRadioOption<T> option, FastRadioGroupState<T> field);

typedef FastRadioOptionsBuilder<T> = Widget Function(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> field);

enum FastRadioGroupOrientation { horizontal, vertical }

/// A [FastFormField] that contains a list of [RadioListTile].
@immutable
class FastRadioGroup<T> extends FastFormField<T> {
  FastRadioGroup({
    FormFieldBuilder<T>? builder,
    T? initialValue,
    FastRadioOptionBuilder<T>? optionBuilder,
    FastRadioOptionsBuilder<T>? optionsBuilder,
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
    this.activeColor,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.fillColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.orientation = FastRadioGroupOrientation.vertical,
    required this.options,
    this.overlayColor,
    this.selectedTileColor,
    this.shapeBorder,
    this.splashRadius,
    this.tileColor,
    this.toggleable = false,
  })  : optionBuilder = optionBuilder ?? radioOptionBuilder,
        optionsBuilder = optionsBuilder ?? radioOptionsBuilder,
        super(
          builder: builder ?? radioGroupBuilder,
          initialValue: initialValue ?? _getInitialValue(options),
        );
  final Color? activeColor;
  final ListTileControlAffinity controlAffinity;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? hoverColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final List<FastRadioOption<T>> options;
  final FastRadioOptionBuilder<T> optionBuilder;
  final FastRadioOptionsBuilder<T> optionsBuilder;
  final FastRadioGroupOrientation orientation;
  final MaterialStateProperty<Color?>? overlayColor;
  final Color? selectedTileColor;
  final ShapeBorder? shapeBorder;
  final double? splashRadius;
  final Color? tileColor;
  final bool toggleable;

  @override
  FastRadioGroupState<T> createState() => FastRadioGroupState<T>();
}

/// State associated with a [FastRadioGroup] widget.
class FastRadioGroupState<T> extends FastFormFieldState<T> {
  @override
  FastRadioGroup<T> get widget => super.widget as FastRadioGroup<T>;
}

/// Returns the initially selected [FastRadioOption.value] when no
/// [FastRadioGroup.initialValue] is set.
///
/// When no [FastRadioOption.selected] is `true`, returns the value of the first
/// element of [FastRadioGroup.options].
T? _getInitialValue<T>(List<FastRadioOption<T>> options) {
  return options
      .lastWhere((option) => option.selected, orElse: () => options.first)
      .value;
}

/// A [FastRadioOptionBuilder] that is the default
/// [FastRadioGroup.optionBuilder].
///
/// Returns a [RadioListTile] when [FastRadioGroup.orientation] is
/// [FastRadioGroupOrientation.vertical].
///
/// Returns an [Expanded] widget that contains a [RadioListTile] when
/// [FastRadioGroup.orientation] is [FastRadioGroupOrientation.horizontal].
Widget radioOptionBuilder<T>(
    FastRadioOption<T> option, FastRadioGroupState<T> field) {
  final FastRadioGroupState<T>(:didChange, :value, :widget) = field;
  final vertical = widget.orientation == FastRadioGroupOrientation.vertical;
  final tile = RadioListTile<T>(
    activeColor: widget.activeColor,
    controlAffinity: widget.controlAffinity,
    fillColor: widget.fillColor,
    hoverColor: widget.hoverColor,
    groupValue: value,
    isThreeLine: option.isThreeLine,
    materialTapTargetSize: widget.materialTapTargetSize,
    mouseCursor: widget.mouseCursor,
    onChanged: widget.enabled ? didChange : null,
    overlayColor: widget.overlayColor,
    secondary: option.secondary,
    selected: option.selected,
    selectedTileColor: widget.selectedTileColor,
    shape: widget.shapeBorder,
    splashRadius: widget.splashRadius,
    subtitle: option.subtitle,
    tileColor: widget.tileColor,
    title: option.title,
    toggleable: widget.toggleable,
    value: option.value,
    visualDensity: option.visualDensity,
  );

  return vertical ? tile : Expanded(child: tile);
}

/// A [FastRadioOptionsBuilder] that is the default
/// [FastRadioGroup.optionsBuilder];
///
/// Returns a [Column] that contains all [FastRadioGroup.options] when
/// [FastRadioGroup.orientation] is [FastRadioGroupOrientation.vertical].
///
/// Returns a [Row] that contains all [FastRadioGroup.options] when
/// [FastRadioGroup.orientation] is [FastRadioGroupOrientation.horizontal].
///
/// Uses [FastRadioGroup.optionBuilder] to build a widget for every
/// [FastRadioOption] in [FastRadioGroup.options].
Widget radioOptionsBuilder<T>(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> field) {
  final FastRadioGroupState<T>(:widget) = field;
  final wrapper = widget.orientation == FastRadioGroupOrientation.vertical
      ? Column.new
      : Row.new;

  return wrapper(
    children: [
      for (final option in options) widget.optionBuilder(option, field)
    ],
  );
}

/// A [FormFieldBuilder] that is the default [FastRadioGroup.builder].
///
/// Returns an [InputDecorator] that contains the widget returned by
/// [FastRadioGroup.optionsBuilder] on any [TargetPlatform].
Widget radioGroupBuilder<T>(FormFieldState<T> field) {
  final FastRadioGroupState<T>(:decoration, :widget) =
      field as FastRadioGroupState<T>;

  return InputDecorator(
    decoration: decoration,
    child: widget.optionsBuilder(widget.options, field),
  );
}
