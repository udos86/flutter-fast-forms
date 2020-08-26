import 'package:flutter/material.dart';

import '../form_field.dart';

@immutable
class FastCustomFormField<T> extends FastFormField<T> {
  FastCustomFormField({
    bool autofocus = false,
    @required FastFormFieldBuilder builder,
    InputDecoration decoration = const InputDecoration(),
    bool enabled = true,
    String helper,
    @required String id,
    T initialValue,
    String label,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          builder: builder,
          decoration: decoration,
          enabled: enabled,
          helper: helper,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  @override
  State<StatefulWidget> createState() => FastFormFieldState<T>();
}
