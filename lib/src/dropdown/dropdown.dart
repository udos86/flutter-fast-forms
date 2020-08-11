import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';
import 'dropdown_field.dart';

@immutable
class FastDropdown extends FastFormField<String> {
  FastDropdown({
    bool autofocus = false,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    this.dropdownColor,
    String helper,
    @required String id,
    String initialValue,
    this.items,
    this.itemsBuilder,
    String label,
    this.selectedItemBuilder,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? fastDropdownBuilder,
          decoration: decoration,
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
  final style = FormStyle.of(context);
  final widget = state.widget as FastDropdown;

  return DropdownFormField(
    autofocus: widget.autofocus,
    autovalidate: state.autovalidate,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    dropdownColor: widget.dropdownColor,
    focusNode: state.focusNode,
    items: widget.items,
    itemsBuilder: widget.itemsBuilder,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    selectedItemBuilder: widget.selectedItemBuilder,
    validator: widget.validator,
    value: state.value,
  );
};
