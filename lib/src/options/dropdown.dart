import 'package:flutter/material.dart';

import '../form.dart';

typedef FastDropdownMenuItemsBuilder<T> = List<DropdownMenuItem<T>> Function(
    List<T> items, FastDropdownState<T> field);

/// A [FastFormField] that contains a [DropdownButtonFormField].
@immutable
class FastDropdown<T> extends FastFormField<T> {
  const FastDropdown({
    FormFieldBuilder<T>? builder,
    super.autovalidateMode,
    super.conditions,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.onTouched,
    super.restorationId,
    super.validator,
    this.alignment = AlignmentDirectional.centerStart,
    this.autofocus = false,
    this.borderRadius,
    this.disabledHint,
    this.dropdownColor,
    this.elevation = 8,
    this.enableFeedback,
    this.focusColor,
    this.focusNode,
    this.hint,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = true,
    this.isExpanded = false,
    this.itemHeight,
    this.items = const [],
    this.itemsBuilder,
    this.menuMaxHeight,
    this.onTap,
    this.selectedItemBuilder,
    this.style,
  }) : super(builder: builder ?? dropdownBuilder);

  final AlignmentGeometry alignment;
  final bool autofocus;
  final BorderRadius? borderRadius;
  final Widget? disabledHint;
  final Color? dropdownColor;
  final int elevation;
  final bool? enableFeedback;
  final Color? focusColor;
  final FocusNode? focusNode;
  final Widget? hint;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final List<T> items;
  final FastDropdownMenuItemsBuilder<T>? itemsBuilder;
  final double? menuMaxHeight;
  final VoidCallback? onTap;
  final DropdownButtonBuilder? selectedItemBuilder;
  final TextStyle? style;

  @override
  FastDropdownState<T> createState() => FastDropdownState<T>();
}

/// State associated with a [FastDropdown] widget.
class FastDropdownState<T> extends FastFormFieldState<T> {
  @override
  FastDropdown<T> get widget => super.widget as FastDropdown<T>;
}

/// A [FastDropdownMenuItemsBuilder] that is the default
/// [FastDropdown.itemsBuilder].
List<DropdownMenuItem<T>> dropdownMenuItemsBuilder<T>(
    List<T> items, FastDropdownState<T> field) {
  return items
      .map((item) =>
          DropdownMenuItem<T>(value: item, child: Text(item.toString())))
      .toList();
}

/// A [FormFieldBuilder] that is the default [FastDropdown.builder].
///
/// Returns a [DropdownButtonFormField] on any [TargetPlatform].
Widget dropdownBuilder<T>(FormFieldState<T> field) {
  final FastDropdownState<T>(
    :decoration,
    :didChange,
    :enabled,
    :focusNode,
    :value,
    :widget
  ) = field as FastDropdownState<T>;
  final itemsBuilder = widget.itemsBuilder ?? dropdownMenuItemsBuilder;

  void onChanged(T? value) {
    if (value != field.value) didChange(value);
  }

  return DropdownButtonFormField(
    alignment: widget.alignment,
    autofocus: widget.autofocus,
    autovalidateMode: widget.autovalidateMode,
    borderRadius: widget.borderRadius,
    decoration: decoration,
    disabledHint: widget.disabledHint,
    dropdownColor: widget.dropdownColor,
    elevation: widget.elevation,
    enableFeedback: widget.enableFeedback,
    focusColor: widget.focusColor,
    focusNode: widget.focusNode ?? focusNode,
    hint: widget.hint,
    icon: widget.icon,
    iconDisabledColor: widget.iconDisabledColor,
    iconEnabledColor: widget.iconEnabledColor,
    iconSize: widget.iconSize,
    isDense: widget.isDense,
    isExpanded: widget.isExpanded,
    itemHeight: widget.itemHeight,
    items: itemsBuilder(widget.items, field),
    menuMaxHeight: widget.menuMaxHeight,
    onChanged: enabled ? onChanged : null,
    onSaved: widget.onSaved,
    onTap: widget.onTap,
    selectedItemBuilder: widget.selectedItemBuilder,
    style: widget.style,
    validator: widget.validator,
    value: value,
  );
}
