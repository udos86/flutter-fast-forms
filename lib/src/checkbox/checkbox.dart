import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_style.dart';

import 'checkbox_form_field.dart';

@immutable
class FastCheckbox extends FastFormField<bool> {
  FastCheckbox({
    bool autofocus = false,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    @required String id,
    bool initialValue,
    String label,
    this.title,
    this.tristate = false,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? _builder,
          decoration: decoration,
          helper: helper,
          id: id,
          initialValue:
              initialValue == null && !tristate ? false : initialValue,
          label: label,
          validator: validator,
        );

  final String title;
  final bool tristate;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<bool>();
}

final FastFormFieldBuilder _builder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastCheckbox;

  return CheckboxFormField(
    autovalidate: state.autovalidate,
    autofocus: widget.autofocus,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    title: widget.title,
    value: state.value,
    validator: widget.validator,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
  );
};
