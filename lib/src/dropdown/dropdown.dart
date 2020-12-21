import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';

import 'dropdown_form_field.dart';
/*
@immutable
class FastDropdown extends FastFormField<String> {
  FastDropdown({
    bool autofocus,
    AutovalidateMode autovalidateMode,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    this.dropdownColor,
    bool enabled,
    String helper,
    @required String id,
    String initialValue,
    this.items,
    this.itemsBuilder,
    String label,
    this.selectedItemBuilder,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus ?? false,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          builder: builder ?? fastDropdownBuilder,
          decoration: decoration,
          enabled: enabled ?? true,
          helper: helper,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final Color dropdownColor;
  final DropdownMenuItemsBuilder itemsBuilder;
  final DropdownButtonBuilder selectedItemBuilder;
  final List<dynamic> items;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<String>();
}

final FastFormFieldBuilder fastDropdownBuilder =
    (BuildContext context, FastFormFieldState state) {
  final theme = FastFormTheme.of(context);
  final widget = state.widget as FastDropdown;
  final decoration = widget.decoration ??
      theme?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return DropdownFormField(
    autofocus: widget.autofocus,
    autovalidateMode: widget.autovalidateMode,
    decoration: decoration,
    dropdownColor: widget.dropdownColor,
    enabled: widget.enabled,
    focusNode: state.focusNode,
    initialValue: widget.initialValue,
    items: widget.items,
    itemsBuilder: widget.itemsBuilder,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    selectedItemBuilder: widget.selectedItemBuilder,
    validator: widget.validator,
  );
};
*/
