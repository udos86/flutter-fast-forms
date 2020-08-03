import 'package:flutter/material.dart';

import '../form_builder.dart';
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
              (context, state, model) {
                return RadioGroupFormField(
                  decoration: decoration ??
                      FormBuilder.buildInputDecoration(context, model),
                  options: options,
                  orientation: orientation,
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

  final List<RadioOption<String>> options;
  final RadioGroupOrientation orientation;

  @override
  State<StatefulWidget> createState() => FormFieldModelState<String>();
}
