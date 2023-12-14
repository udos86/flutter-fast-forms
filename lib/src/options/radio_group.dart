import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form.dart';

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

enum FastRadioGroupOrientation { horizontal, vertical }

@immutable
class FastRadioGroup<T> extends FastFormField<T> {
  FastRadioGroup({
    FormFieldBuilder<T>? builder,
    T? initialValue,
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
    this.optionBuilder,
    this.optionsBuilder,
    this.overlayColor,
    this.selectedTileColor,
    this.shapeBorder,
    this.splashRadius,
    this.tileColor,
    this.toggleable = false,
  }) : super(
            builder: builder ?? radioGroupBuilder<T>,
            initialValue: initialValue ??
                options
                    .lastWhere(
                      (option) => option.selected,
                      orElse: () => options.first,
                    )
                    .value);

  final Color? activeColor;
  final ListTileControlAffinity controlAffinity;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? hoverColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final List<FastRadioOption<T>> options;
  final Widget Function(
      FastRadioOption<T> option, FastRadioGroupState<T> field)? optionBuilder;
  final Widget Function(
          List<FastRadioOption<T>> options, FastRadioGroupState<T> field)?
      optionsBuilder;
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

class FastRadioGroupState<T> extends FastFormFieldState<T> {
  @override
  FastRadioGroup<T> get widget => super.widget as FastRadioGroup<T>;
}

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

Widget radioOptionsBuilder<T>(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> field) {
  final FastRadioGroupState<T>(:widget) = field;
  final optionBuilder = widget.optionBuilder ?? radioOptionBuilder;
  final wrapper = widget.orientation == FastRadioGroupOrientation.vertical
      ? Column.new
      : Row.new;

  return wrapper(
    children: [for (final option in options) optionBuilder(option, field)],
  );
}

Widget radioGroupBuilder<T>(FormFieldState<T> field) {
  field as FastRadioGroupState<T>;
  final FastRadioGroupState<T>(:decoration, :widget) = field;
  final optionsBuilder = widget.optionsBuilder ?? radioOptionsBuilder;

  return InputDecorator(
    decoration: decoration,
    child: optionsBuilder(widget.options, field),
  );
}
