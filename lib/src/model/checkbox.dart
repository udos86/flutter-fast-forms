import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/src/form_container.dart';
import 'package:provider/provider.dart';

import '../form_style.dart';
import '../widget/checkbox-form-field.dart';

import 'form_field.dart';

@immutable
class FastCheckbox extends FastFormField<bool> {
  FastCheckbox({
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
              (context, state) {
                final store =
                    Provider.of<FastFormStore>(context, listen: false);
                final style = FormStyle.of(context);
                return CheckboxFormField(
                  decoration: decoration ??
                      style.createInputDecoration(context, state.widget),
                  title: title,
                  value: state.value,
                  validator: validator,
                  onSaved: (value) => store.setValue(id, value),
                  onChanged: state.save,
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
  State<StatefulWidget> createState() => FastFormFieldState<bool>();
}
