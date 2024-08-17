import 'package:flutter/material.dart';

import '../form.dart';

/// A single [FastChoiceChips] chip.
@immutable
class FastChoiceChip<T>
    implements
        ChipAttributes,
        CheckmarkableChipAttributes,
        SelectableChipAttributes,
        DisabledChipAttributes {
  FastChoiceChip({
    Widget? label,
    this.autofocus = false,
    this.avatar,
    this.avatarBorder = const CircleBorder(),
    this.avatarBoxConstraints,
    this.backgroundColor,
    this.checkmarkColor,
    this.chipAnimationStyle,
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
  }) : label = label is Widget ? label : Text(value.toString());

  @override
  final bool autofocus;
  @override
  final Widget? avatar;
  @override
  final BoxConstraints? avatarBoxConstraints;
  @override
  final ShapeBorder avatarBorder;
  @override
  final Color? backgroundColor;
  @override
  final Color? checkmarkColor;
  @override
  final ChipAnimationStyle? chipAnimationStyle;
  @override
  final Clip clipBehavior;
  @override
  final WidgetStateProperty<Color?>? color;
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
  final bool? showCheckmark;
  @override
  final BorderSide? side;
  @override
  final Color? surfaceTintColor;
  @override
  final String? tooltip;
  @override
  final VisualDensity? visualDensity;

  final bool enabled;
  final T value;

  @override
  bool get isEnabled => enabled;
}

typedef FastChoiceChipBuilder<T> = Widget Function(
    FastChoiceChip<T> chip, FastChoiceChipsState<T> field);

/// A [FastFormField] that contains a list of [ChoiceChip].
@immutable
class FastChoiceChips<T> extends FastFormField<Set<T>> {
  FastChoiceChips({
    FormFieldBuilder<Set<T>>? builder,
    FastChoiceChipBuilder<T>? chipBuilder,
    Set<T>? initialValue,
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
    this.alignment = WrapAlignment.start,
    this.chipPadding,
    required this.chips,
    this.clipBehavior = Clip.none,
    this.crossAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
    this.spacing = 12.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.showCheckmark,
    this.showInputDecoration = true,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  })  : chipBuilder = chipBuilder ?? choiceChipBuilder,
        super(
          builder: builder ?? choiceChipsBuilder,
          initialValue: initialValue ?? _getInitialValue(chips),
        );

  final WrapAlignment alignment;
  final FastChoiceChipBuilder<T> chipBuilder;
  final EdgeInsetsGeometry? chipPadding;
  final List<FastChoiceChip<T>> chips;
  final Clip clipBehavior;
  final WrapCrossAlignment crossAlignment;
  final Axis direction;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final bool? showCheckmark;
  final bool showInputDecoration;
  final double spacing;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;

  @override
  FastChoiceChipsState<T> createState() => FastChoiceChipsState<T>();
}

/// State associated with a [FastChoiceChips] widget.
class FastChoiceChipsState<T> extends FastFormFieldState<Set<T>> {
  @override
  FastChoiceChips<T> get widget => super.widget as FastChoiceChips<T>;
}

/// Fallback for setting the default [FastChoiceChips.initialValue].
///
/// Returns a [List] that contains every [FastChoiceChip.value] in
/// [FastChoiceChips.chips] where [FastChoiceChip.selected] is `true`.
Set<T> _getInitialValue<T>(List<FastChoiceChip<T>> chips) {
  return chips.where((chip) => chip.selected).map((chip) => chip.value).toSet();
}

/// A [FastChoiceChipBuilder] that is the default [FastChoiceChips.chipBuilder].
///
/// Returns a [ChoiceChip] that updates the [FastChoiceChipsState.value] in
/// [ChoiceChip.onSelected].
ChoiceChip choiceChipBuilder<T>(
    FastChoiceChip<T> chip, FastChoiceChipsState<T> field) {
  final FastChoiceChipsState<T>(:didChange, :enabled, :value!, :widget) = field;

  void onSelected(selected) {
    chip.onSelected?.call(selected);

    Set<T> updatedValue;
    if (selected) {
      updatedValue = {...value, chip.value};
    } else {
      updatedValue = {
        ...[...value]..remove(chip.value)
      };
    }

    didChange(updatedValue);
  }

  return ChoiceChip(
    autofocus: chip.autofocus,
    avatar: chip.avatar,
    avatarBorder: chip.avatarBorder,
    avatarBoxConstraints: chip.avatarBoxConstraints,
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

/// A [FormFieldBuilder] that is the default [FastChoiceChips.builder].
///
/// Uses [FastChoiceChips.chipBuilder] to build a [ChoiceChip] for every
/// [FastChoiceChip] in [FastChoiceChips.chips].
///
/// Returns an [InputDecorator] that wraps a [List] of [ChoiceChip] on any
/// [TargetPlatform].
Widget choiceChipsBuilder<T>(FormFieldState<Set<T>> field) {
  field as FastChoiceChipsState<T>;
  final FastChoiceChipsState<T>(:widget) = field;

  final wrap = Wrap(
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
  );

  if (widget.showInputDecoration) {
    return InputDecorator(
      decoration: field.decoration,
      child: wrap,
    );
  }

  return wrap;
}
