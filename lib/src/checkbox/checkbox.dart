import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';

import 'checkbox_form_field.dart';

@immutable
class FastCheckbox extends FastFormField<bool> {
  FastCheckbox({
    bool autofocus,
    AutovalidateMode autovalidateMode,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    bool enabled,
    String helper,
    @required String id,
    bool initialValue,
    String label,
    this.title,
    this.tristate = false,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus ?? false,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          builder: builder ?? fastCheckboxBuilder,
          decoration: decoration,
          enabled: enabled ?? true,
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
  final theme = FastFormTheme.of(context);
  final widget = state.widget as FastCheckbox;
  final decoration = widget.decoration ??
      theme?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return CheckboxFormField(
    autovalidateMode: widget.autovalidateMode,
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
