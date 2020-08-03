import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../form_style.dart';
import '../form_container.dart';
import '../widget/radio-group-form-field.dart';

import 'form_field.dart';

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
class FastRadioGroup extends FastFormField<String> {
  FastRadioGroup({
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
                final style = FormStyle.of(context);
                return RadioGroupFormField(
                    decoration: decoration ??
                        style.createInputDecoration(context, state.widget),
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
  State<StatefulWidget> createState() => FastFormFieldState<String>();
}
