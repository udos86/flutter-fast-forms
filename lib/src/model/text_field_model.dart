import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'form_field_model.dart';

@immutable
class TextFieldModel extends FormFieldModel<String> {
  TextFieldModel({
    builder,
    decoration,
    helper,
    hint,
    id,
    String initialValue,
    label,
    validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  }) : super(
          builder: builder ??
              (context, form, model) {
                return TextFormField(
                  decoration:
                      decoration ?? form.buildInputDecoration(context, model),
                  autovalidate: form.autovalidate(id),
                  keyboardType: keyboardType ?? TextInputType.text,
                  inputFormatters: [...inputFormatters],
                  validator: validator,
                  controller: form.getController(id, form.getFieldValue(id)),
                  focusNode: form.getFocusNode(id),
                );
              },
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;
}
