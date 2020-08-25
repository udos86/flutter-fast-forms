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
    bool enabled = true,
    String helper,
    @required String id,
    bool initialValue,
    String label,
    this.title,
    this.tristate = false,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? fastCheckboxBuilder,
          decoration: decoration,
          enabled: enabled,
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

final FastFormFieldBuilder fastCheckboxBuilder = (context, state) {
  final style = FormStyle.of(context);
  final widget = state.widget as FastCheckbox;
  final decoration = widget.decoration ??
      style?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return CheckboxFormField(
    autovalidate: state.autovalidate,
    autofocus: widget.autofocus,
    decoration: decoration,
    enabled: widget.enabled,
    initialValue: widget.initialValue,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    title: widget.title,
    validator: widget.validator,
  );
};
