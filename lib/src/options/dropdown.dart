import 'package:flutter/material.dart';

import '../form_field.dart';

typedef DropdownMenuItemsBuilder<T> = List<DropdownMenuItem<T>> Function(
    List<T> items, FastDropdownState<T> state);

@immutable
class FastDropdown<T> extends FastFormField<T> {
  FastDropdown({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<T>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    T? initialValue,
    Key? key,
    String? label,
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
          builder: builder ?? (field) => dropdownBuilder<T>(field),
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final Color? dropdownColor;
  final FocusNode? focusNode;
  final Widget? hint;
  final List<T> items;
  final DropdownMenuItemsBuilder<T>? itemsBuilder;
  final DropdownButtonBuilder? selectedItemBuilder;

  @override
  FastDropdownState<T> createState() => FastDropdownState<T>();
}

class FastDropdownState<T> extends FastFormFieldState<T> {
  @override
  FastDropdown<T> get widget => super.widget as FastDropdown<T>;
}

List<DropdownMenuItem<T>> dropdownMenuItemsBuilder<T>(
    List<T> items, FastDropdownState<T> state) {
  return items.map((item) {
    return DropdownMenuItem<T>(
      value: item,
      child: Text(item.toString()),
    );
  }).toList();
}

DropdownButtonFormField<T> dropdownBuilder<T>(FormFieldState<T> field) {
  final state = field as FastDropdownState<T>;
  final widget = state.widget;

  void _onChanged(value) {
    if (value != field.value) field.didChange(value);
  }

  return DropdownButtonFormField<T>(
    autofocus: widget.autofocus,
    autovalidateMode: widget.autovalidateMode,
    decoration: state.decoration,
    dropdownColor: widget.dropdownColor,
    focusNode: widget.focusNode,
    hint: widget.hint,
    // Try to refactor when Tear-Offs arrive in Dart
    items: widget.itemsBuilder != null
        ? widget.itemsBuilder!(widget.items, state)
        : dropdownMenuItemsBuilder<T>(widget.items, state),
    onChanged: widget.enabled ? _onChanged : null,
    onSaved: widget.onSaved,
    selectedItemBuilder: widget.selectedItemBuilder,
    validator: widget.validator,
    value: state.value,
  );
}
