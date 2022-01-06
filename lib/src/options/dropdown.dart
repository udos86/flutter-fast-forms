import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastDropdownMenuItemsBuilder<T> = List<DropdownMenuItem<T>> Function(
    List<T> items, FastDropdownState<T> field);

@immutable
class FastDropdown<T> extends FastFormField<T> {
  const FastDropdown({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<T>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    T? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<T>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    this.dropdownColor,
    this.focusNode,
    this.hint,
    this.items = const [],
    this.itemsBuilder,
    this.selectedItemBuilder,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? dropdownBuilder<T>,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final Color? dropdownColor;
  final FocusNode? focusNode;
  final Widget? hint;
  final List<T> items;
  final FastDropdownMenuItemsBuilder<T>? itemsBuilder;
  final DropdownButtonBuilder? selectedItemBuilder;

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
    autofocus: widget.autofocus,
    autovalidateMode: widget.autovalidateMode,
    decoration: field.decoration,
    dropdownColor: widget.dropdownColor,
    focusNode: widget.focusNode,
    hint: widget.hint,
    items: itemsBuilder(widget.items, field),
    onChanged: widget.enabled ? _onChanged : null,
    onSaved: widget.onSaved,
    selectedItemBuilder: widget.selectedItemBuilder,
    validator: widget.validator,
    value: field.value,
  );
}
