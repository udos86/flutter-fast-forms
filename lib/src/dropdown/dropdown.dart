import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

@immutable
class FastDropdown extends FastFormField<String> {
  FastDropdown({
    builder,
    decoration,
    helper,
    hint,
    id,
    String initialValue,
    label,
    validator,
    this.items,
  }) : super(
          builder: builder ??
              (context, state) {
                final style = FormStyle.of(context);
                return DropdownButtonFormField(
                  decoration: decoration ??
                      style.createInputDecoration(context, state.widget),
                  autovalidate: state.autovalidate,
                  items: buildDropdownMenuItems(items),
                  value: state.value,
                  validator: validator,
                  onChanged: state.onChanged,
                  onSaved: state.onSaved,
                );
              },
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
