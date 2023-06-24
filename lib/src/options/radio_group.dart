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
    @Deprecated('Use title instead') this.text,
    this.title,
    required this.value,
    this.visualDensity,
  }) : assert(!(text == null && title == null),
            'Either text or title must be set');

  final bool isThreeLine;
  final Widget? secondary;
  final bool selected;
  final Widget? subtitle;
  @Deprecated('Use title instead')
  final String? text;
  final Widget? title;
  final T value;
  final VisualDensity? visualDensity;
}

typedef FastRadioOptionBuilder<T> = Widget Function(
    FastRadioOption<T> option, FastRadioGroupState<T> field);

typedef FastRadioOptionsBuilder<T> = Widget Function(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> field);

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
  final FastRadioOptionBuilder<T>? optionBuilder;
  final FastRadioOptionsBuilder<T>? optionsBuilder;
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
  final widget = field.widget;
  final vertical = widget.orientation == FastRadioGroupOrientation.vertical;
  final tile = RadioListTile<T>(
    activeColor: widget.activeColor,
    controlAffinity: widget.controlAffinity,
    fillColor: widget.fillColor,
    hoverColor: widget.hoverColor,
    groupValue: field.value,
    isThreeLine: option.isThreeLine,
    materialTapTargetSize: widget.materialTapTargetSize,
    mouseCursor: widget.mouseCursor,
    onChanged: field.widget.enabled ? field.didChange : null,
    overlayColor: widget.overlayColor,
    secondary: option.secondary,
    selected: option.selected,
    selectedTileColor: widget.selectedTileColor,
    shape: widget.shapeBorder,
    splashRadius: widget.splashRadius,
    subtitle: option.subtitle,
    tileColor: widget.tileColor,
    // ignore: deprecated_member_use_from_same_package
    title: option.title ?? Text(option.text!),
    toggleable: widget.toggleable,
    value: option.value,
    visualDensity: option.visualDensity,
  );

  return vertical ? tile : Expanded(child: tile);
}

Widget radioOptionsBuilder<T>(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> field) {
  final optionBuilder = field.widget.optionBuilder ?? radioOptionBuilder;
  final wrapper = field.widget.orientation == FastRadioGroupOrientation.vertical
      ? Column.new
      : Row.new;

  return wrapper(
    children: [for (final option in options) optionBuilder(option, field)],
  );
}

Widget radioGroupBuilder<T>(FormFieldState<T> field) {
  final widget = (field as FastRadioGroupState<T>).widget;
  final optionsBuilder = widget.optionsBuilder ?? radioOptionsBuilder;

  return InputDecorator(
    decoration: field.decoration,
    child: optionsBuilder(widget.options, field),
  );
}
