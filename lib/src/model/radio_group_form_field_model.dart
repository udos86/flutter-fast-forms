import 'package:flutter/material.dart';

import '../widget/radio-group-form-field.dart';

import 'form_field_model.dart';

@immutable
class FormFieldOption<T> {
  FormFieldOption({
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
                  decoration: form.buildInputDecoration(context, model),
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

  final List<FormFieldOption<String>> options;
  final RadioGroupOrientation orientation;
}
