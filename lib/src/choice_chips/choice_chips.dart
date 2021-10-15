import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

@immutable
class FastChoiceChip
    implements
        ChipAttributes,
        SelectableChipAttributes,
        DisabledChipAttributes {
  const FastChoiceChip({
    this.autofocus = false,
    this.avatar,
    this.avatarBorder = const CircleBorder(),
    this.backgroundColor,
    this.clipBehavior = Clip.none,
    this.disabledColor,
    this.elevation,
    this.focusNode,
    required this.label,
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
    this.side,
    this.tooltip,
    this.visualDensity,
  });

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
  final Color? disabledColor;
  @override
  final double? elevation;
  @override
  final FocusNode? focusNode;
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
  final String? tooltip;
  @override
  final VisualDensity? visualDensity;

  @override
  bool get isEnabled => onSelected != null;
}

typedef ChoiceChipBuilder = Widget Function(
    FastChoiceChip chip, FastChoiceChipsState state);

@immutable
class FastChoiceChips extends FastFormField<Set<int>> {
  FastChoiceChips({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<Set<int>>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    Set<int>? initialValue,
    Key? key,
    String? label,
    ValueChanged<Set<int>>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter? onSaved,
    FormFieldValidator<Set<int>>? validator,
    this.alignment = WrapAlignment.start,
    this.chipBuilder,
    this.chipPadding,
    required this.chips,
    this.clipBehavior = Clip.none,
    this.crossAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
    this.spacing = 12.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder =
                    scope?.builders[FastChoiceChips] ?? choiceChipsBuilder;
                return builder(field);
              },
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue ??
              chips
                  .where((chip) => chip.selected)
                  .map((chip) => chips.indexOf(chip))
                  .toSet(),
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final WrapAlignment alignment;
  final ChoiceChipBuilder? chipBuilder;
  final EdgeInsetsGeometry? chipPadding;
  final List<FastChoiceChip> chips;
  final Clip clipBehavior;
  final WrapCrossAlignment crossAlignment;
  final Axis direction;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final double spacing;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;

  @override
  FastChoiceChipsState createState() => FastChoiceChipsState();
}

class FastChoiceChipsState extends FastFormFieldState<Set<int>> {
  @override
  FastChoiceChips get widget => super.widget as FastChoiceChips;
}

Set<int>? newFieldValue(bool selected, int index, FastChoiceChipsState state) {
  final currentValue = state.value!;

  return selected
      ? {...currentValue, index}
      : ({...currentValue}..remove(index));
}

ChoiceChip choiceChipBuilder(FastChoiceChip chip, FastChoiceChipsState state) {
  final index = state.widget.chips.indexOf(chip);

  return ChoiceChip(
    autofocus: chip.autofocus,
    avatar: chip.avatar,
    avatarBorder: chip.avatarBorder,
    backgroundColor: chip.backgroundColor,
    clipBehavior: chip.clipBehavior,
    disabledColor: chip.disabledColor,
    elevation: chip.elevation,
    focusNode: chip.focusNode,
    label: chip.label,
    labelPadding: chip.labelPadding,
    labelStyle: chip.labelStyle,
    materialTapTargetSize: chip.materialTapTargetSize,
    padding: chip.padding ?? state.widget.chipPadding,
    pressElevation: chip.pressElevation,
    selected: state.value!.contains(index),
    selectedColor: chip.selectedColor,
    selectedShadowColor: chip.selectedShadowColor,
    shadowColor: chip.shadowColor,
    shape: chip.shape,
    side: chip.side,
    tooltip: chip.tooltip,
    visualDensity: chip.visualDensity,
    onSelected: (selected) {
      if (chip.onSelected != null) {
        chip.onSelected!(selected);
      }
      state.didChange(newFieldValue(selected, index, state));
    },
  );
}

InputDecorator choiceChipsBuilder(FormFieldState field) {
  final state = field as FastChoiceChipsState;
  final widget = state.widget;

  final theme = Theme.of(state.context);
  final decorator = FastFormScope.of(state.context)?.inputDecorator;
  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);
  final _choiceChipBuilder = widget.chipBuilder ?? choiceChipBuilder;

  return InputDecorator(
    decoration: effectiveDecoration.copyWith(
      contentPadding: widget.contentPadding,
      errorText: state.errorText,
    ),
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
        for (var chip in widget.chips) _choiceChipBuilder(chip, state),
      ],
    ),
  );
}
