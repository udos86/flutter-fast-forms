import 'package:flutter/material.dart';

import 'form_field_model.dart';

import '../form_builder.dart';

@immutable
class DropdownModel extends FormFieldModel<String> {
  DropdownModel({
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
              (context, state, model) {
                return DropdownButtonFormField(
                  decoration: decoration ??
                      FormBuilder.buildInputDecoration(context, model),
                  autovalidate: state.autovalidate,
                  items: FormBuilder.buildDropdownMenuItems(items),
                  value: state.value,
                  validator: validator,
                  onChanged: (value) => state.save(value),
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

  @override
  State<StatefulWidget> createState() => FormFieldModelState<String>();
}
