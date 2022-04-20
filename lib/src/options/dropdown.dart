import 'package:flutter/material.dart';

import '../form.dart';

typedef FastDropdownMenuItemsBuilder<T> = List<DropdownMenuItem<T>> Function(
    List<T> items, FastDropdownState<T> field);

@immutable
class FastDropdown<T> extends FastFormField<T> {
  const FastDropdown({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<T>? builder,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0),
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    T? initialValue,
    Key? key,
    String? labelText,
    required String name,
    ValueChanged<T?>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    this.alignment = AlignmentDirectional.centerStart,
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
    this.selectedItemBuilder,
    this.style,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? dropdownBuilder<T>,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          labelText: labelText,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final AlignmentGeometry alignment;
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
  final DropdownButtonBuilder? selectedItemBuilder;
  final TextStyle? style;

  @override
  FastDropdownState<T> createState() => FastDropdownState<T>();
}

class FastDropdownState<T> extends FastFormFieldState<T> {
  @override
  FastDropdown<T> get widget => super.widget as FastDropdown<T>;
}

List<DropdownMenuItem<T>> dropdownMenuItemsBuilder<T>(
    List<T> items, FastDropdownState<T> field) {
  return items
      .map((item) =>
          DropdownMenuItem<T>(value: item, child: Text(item.toString())))
      .toList();
}

DropdownButtonFormField<T> dropdownBuilder<T>(FormFieldState<T> field) {
  final widget = (field as FastDropdownState<T>).widget;
  final itemsBuilder = widget.itemsBuilder ?? dropdownMenuItemsBuilder;

  void _onChanged(T? value) {
    if (value != field.value) field.didChange(value);
  }

  return DropdownButtonFormField<T>(
    alignment: widget.alignment,
    autofocus: widget.autofocus,
    autovalidateMode: widget.autovalidateMode,
    decoration: field.decoration,
    disabledHint: widget.disabledHint,
    dropdownColor: widget.dropdownColor,
    elevation: widget.elevation,
    enableFeedback: widget.enableFeedback,
    focusColor: widget.focusColor,
    focusNode: widget.focusNode,
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
    onChanged: widget.enabled ? _onChanged : null,
    onSaved: widget.onSaved,
    selectedItemBuilder: widget.selectedItemBuilder,
    style: widget.style,
    validator: widget.validator,
    value: field.value,
  );
}
