import 'package:flutter/material.dart';

import '../form_field.dart';

@immutable
class FastCustomFormField<T> extends FastFormField<T> {
  FastCustomFormField({
    bool autofocus,
    AutovalidateMode autovalidateMode,
    @required FastFormFieldBuilder builder,
    InputDecoration decoration = const InputDecoration(),
    bool enabled,
    String helper,
    @required String id,
    T initialValue,
    String label,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus ?? false,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          builder: builder,
          decoration: decoration,
          enabled: enabled ?? true,
          helper: helper,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  @override
  State<StatefulWidget> createState() => FastFormFieldState<T>();
}
