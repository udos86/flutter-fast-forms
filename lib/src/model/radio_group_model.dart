import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../form_style.dart';
import '../form_container.dart';
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
              (context, state) {
                final store =
                    Provider.of<FastFormStore>(context, listen: false);
                final styler = FormStyle.of(context);
                return RadioGroupFormField(
                    decoration: decoration ??
                        styler.createInputDecoration(context, state.widget),
                    options: options,
                    orientation: orientation,
                    value: state.value,
                    validator: validator,
                    onSaved: (value) => store.setValue(id, value),
                    onChanged: state.save);
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
