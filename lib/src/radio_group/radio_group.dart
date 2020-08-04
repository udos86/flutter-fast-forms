import 'package:flutter/cupertino.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'radio_group_form_field.dart';

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
                final style = FormStyle.of(context);
                return RadioGroupFormField(
                  decoration: decoration ??
                      style.createInputDecoration(context, state.widget),
                  options: options,
                  orientation: orientation,
                  value: state.value,
                  validator: validator,
                  onChanged: state.onChanged,
                  onSaved: state.onSaved,
                );
              },
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue ?? options.first.value,
          label: label,
          validator: validator,
        );

  final List<RadioOption<String>> options;
  final RadioGroupOrientation orientation;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<String>();
}
