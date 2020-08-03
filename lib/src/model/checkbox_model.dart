import 'package:flutter/material.dart';

import '../form_builder.dart';
import '../widget/checkbox-form-field.dart';

import 'form_field_model.dart';

@immutable
class CheckboxModel extends FormFieldModel<bool> {
  CheckboxModel({
    builder,
    decoration,
    helper,
    hint,
    id,
    bool initialValue,
    label,
    this.title,
    validator,
  }) : super(
          builder: builder ??
              (context, state, model) {
                return CheckboxFormField(
                  decoration: decoration ??
                      FormBuilder.buildInputDecoration(context, model),
                  title: title,
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

  final String title;

  @override
  State<StatefulWidget> createState() => FormFieldModelState<bool>();
}
