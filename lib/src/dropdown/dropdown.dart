import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

typedef FastDropdownMenuItemsBuilder = List<DropdownMenuItem> Function(
    BuildContext context, List<dynamic> items);

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
  final FastDropdownMenuItemsBuilder itemsBuilder;
  final DropdownButtonBuilder selectedItemBuilder;
  final List<dynamic> items;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<String>();
}

final FastDropdownMenuItemsBuilder fastDropdownMenuItemsBuilder =
    (BuildContext context, List<dynamic> items) {
  return items.map((item) {
    return DropdownMenuItem(
      value: item.toString(),
      child: Text(item.toString()),
    );
  }).toList();
};

final FastFormFieldBuilder fastDropdownBuilder =
    (BuildContext context, FastFormFieldState state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastDropdown;
  final _itemsBuilder = widget.itemsBuilder ?? fastDropdownMenuItemsBuilder;

  return DropdownButtonFormField(
    autofocus: widget.autofocus,
    autovalidate: state.autovalidate,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    dropdownColor: widget.dropdownColor,
    focusNode: state.focusNode,
    items: _itemsBuilder(context, widget.items),
    onChanged: state.onChanged,
    onSaved: state.onSaved,
    selectedItemBuilder: widget.selectedItemBuilder,
    validator: widget.validator,
    value: state.value,
  );
};
