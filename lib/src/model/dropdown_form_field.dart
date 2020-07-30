import 'package:flutter/material.dart';

import 'form_field_model.dart';

import '../form_builder.dart';

@immutable
class DropdownFormFieldModel extends FormFieldModel<String> {
  DropdownFormFieldModel({
    builder,
    helper,
    hint,
    id,
    String initialValue,
    label,
    validator,
    this.items,
  }) : super(
          builder: builder ??
              (context, form, model) {
                return DropdownButtonFormField(
                  decoration: form.buildInputDecoration(context, model),
                  autovalidate: form.autovalidate(id),
                  items: FormBuilder.buildDropdownMenuItems(items),
                  value: form.getFieldValue(id),
                  validator: validator,
                  onChanged: (value) => form.save(id, value),
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
}
