import 'package:flutter/material.dart';

import '../widget/radio-group-form-field.dart';

import 'form_field_model.dart';

@immutable
class RadioOption<T> {
  RadioOption({
    @required this.title,
    @required this.value,
  });

  final T value;
  final String title;
}

@immutable
class RadioGroupModel extends FormFieldModel<String> {
  RadioGroupModel({
    builder,
    decoration,
    helper,
    hint,
    id,
    String initialValue,
    label,
    validator,
    this.options,
    this.orientation,
  }) : super(
          builder: builder ??
              (context, form, model) {
                return RadioGroupFormField(
                  decoration:
                      decoration ?? form.buildInputDecoration(context, model),
                  options: options,
                  orientation: orientation,
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

  final List<RadioOption<String>> options;
  final RadioGroupOrientation orientation;
}
