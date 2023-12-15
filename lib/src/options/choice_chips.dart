import 'package:flutter/material.dart';

import '../form.dart';

@immutable
class FastChoiceChip
    implements
        ChipAttributes,
        SelectableChipAttributes,
        DisabledChipAttributes {
  FastChoiceChip({
    Widget? label,
    this.autofocus = false,
    this.avatar,
    this.avatarBorder = const CircleBorder(),
    this.backgroundColor,
    this.checkmarkColor,
    this.clipBehavior = Clip.none,
    this.color,
    this.disabledColor,
    this.elevation,
    this.enabled = true,
    this.focusNode,
    this.iconTheme,
    this.labelStyle,
    this.labelPadding,
    this.materialTapTargetSize,
    this.onSelected,
    this.padding,
    this.pressElevation,
    this.selected = false,
    this.selectedColor,
    this.selectedShadowColor,
    this.shadowColor,
    this.shape,
    this.showCheckmark,
    this.side,
    this.surfaceTintColor,
    this.tooltip,
    required this.value,
    this.visualDensity,
  }) : label = label is Widget ? label : Text(value);

  @override
  final bool autofocus;
  @override
  final Widget? avatar;
  @override
  final ShapeBorder avatarBorder;
  @override
  final Color? backgroundColor;
  @override
  final Clip clipBehavior;
  @override
  final MaterialStateProperty<Color?>? color;
  @override
  final Color? disabledColor;
  @override
  final double? elevation;
  @override
  final FocusNode? focusNode;
  @override
  final IconThemeData? iconTheme;
  @override
  final Widget label;
  @override
  final EdgeInsetsGeometry? labelPadding;
  @override
  final TextStyle? labelStyle;
  @override
  final MaterialTapTargetSize? materialTapTargetSize;
  @override
  final EdgeInsetsGeometry? padding;
  @override
  final double? pressElevation;
  @override
  final ValueChanged<bool>? onSelected;
  @override
  final bool selected;
  @override
  final Color? selectedColor;
  @override
  final Color? selectedShadowColor;
  @override
  final Color? shadowColor;
  @override
  final OutlinedBorder? shape;
  @override
  final BorderSide? side;
  @override
  final Color? surfaceTintColor;
  @override
  final String? tooltip;
  @override
  final VisualDensity? visualDensity;

  final bool enabled;
  final Color? checkmarkColor;
  final bool? showCheckmark;
  final String value;

  @override
  bool get isEnabled => enabled;
}

@immutable
class FastChoiceChips extends FastFormField<List<String>> {
  FastChoiceChips({
    List<String>? initialValue,
    super.autovalidateMode,
    super.builder = choiceChipsBuilder,
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
    this.alignment = WrapAlignment.start,
    this.chipBuilder = choiceChipBuilder,
    this.chipPadding,
    required this.chips,
    this.clipBehavior = Clip.none,
    this.crossAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
    this.spacing = 12.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.showCheckmark,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  }) : super(
          initialValue: initialValue ??
              chips
                  .where((chip) => chip.selected)
                  .map((chip) => chip.value)
                  .toList(),
        );

  final WrapAlignment alignment;
  final Widget Function(FastChoiceChip chip, FastChoiceChipsState field)
      chipBuilder;
  final EdgeInsetsGeometry? chipPadding;
  final List<FastChoiceChip> chips;
  final Clip clipBehavior;
  final WrapCrossAlignment crossAlignment;
  final Axis direction;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final bool? showCheckmark;
  final double spacing;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;

  @override
  FastChoiceChipsState createState() => FastChoiceChipsState();
}

class FastChoiceChipsState extends FastFormFieldState<List<String>> {
  @override
  FastChoiceChips get widget => super.widget as FastChoiceChips;
}

ChoiceChip choiceChipBuilder(FastChoiceChip chip, FastChoiceChipsState field) {
  final FastChoiceChipsState(:didChange, :enabled, :value!, :widget) = field;

  void onSelected(selected) {
    if (chip.onSelected != null) {
      chip.onSelected!(selected);
    }

    final newValue =
        selected ? ([...value, chip.value]) : ([...value]..remove(chip.value));
    didChange(newValue);
  }

  return ChoiceChip(
    autofocus: chip.autofocus,
    avatar: chip.avatar,
    avatarBorder: chip.avatarBorder,
    backgroundColor: chip.backgroundColor,
    checkmarkColor: chip.checkmarkColor,
    clipBehavior: chip.clipBehavior,
    color: chip.color,
    disabledColor: chip.disabledColor,
    elevation: chip.elevation,
    focusNode: chip.focusNode,
    iconTheme: chip.iconTheme,
    label: chip.label,
    labelPadding: chip.labelPadding,
    labelStyle: chip.labelStyle,
    materialTapTargetSize: chip.materialTapTargetSize,
    onSelected: enabled && chip.isEnabled ? onSelected : null,
    padding: chip.padding ?? widget.chipPadding,
    pressElevation: chip.pressElevation,
    selected: value.contains(chip.value),
    selectedColor: chip.selectedColor,
    selectedShadowColor: chip.selectedShadowColor,
    shadowColor: chip.shadowColor,
    shape: chip.shape,
    showCheckmark: chip.showCheckmark ?? widget.showCheckmark,
    side: chip.side,
    surfaceTintColor: chip.surfaceTintColor,
    tooltip: chip.tooltip,
    visualDensity: chip.visualDensity,
  );
}

Widget choiceChipsBuilder(FormFieldState field) {
  final FastChoiceChipsState(:decoration, :widget) =
      field as FastChoiceChipsState;

  return InputDecorator(
    decoration: decoration,
    child: Wrap(
      alignment: widget.alignment,
      crossAxisAlignment: widget.crossAlignment,
      clipBehavior: widget.clipBehavior,
      direction: widget.direction,
      runAlignment: widget.runAlignment,
      runSpacing: widget.runSpacing,
      spacing: widget.spacing,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      children: [
        for (final chip in widget.chips) widget.chipBuilder(chip, field),
      ],
    ),
  );
}
