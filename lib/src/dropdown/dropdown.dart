import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

@immutable
class FastDropdown extends FastFormField<String> {
  FastDropdown({
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    String hint,
    @required int id,
    String initialValue,
    String label,
    FormFieldValidator validator,
    this.items,
  }) : super(
          builder: builder ?? _builder,
          decoration: decoration,
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final List<String> items;

  static List<DropdownMenuItem> buildDropdownMenuItems(List<String> items) {
    return items.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  @override
  State<StatefulWidget> createState() => FastFormFieldState<String>();
}

final FastFormFieldBuilder _builder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastDropdown;

  return DropdownButtonFormField(
    autovalidate: state.autovalidate,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    items: FastDropdown.buildDropdownMenuItems(widget.items),
    validator: widget.validator,
    value: state.value,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
  );
};