import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';

import 'time_picker_form_field.dart';
/*
@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  FastTimePicker({
    bool autofocus,
    AutovalidateMode autovalidateMode,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    bool enabled,
    String helper,
    this.icon,
    @required String id,
    TimeOfDay initialValue,
    String label,
    this.textBuilder,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus ?? false,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          builder: builder ?? fastTimePickerBuilder,
          enabled: enabled ?? true,
          helper: helper,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final Icon icon;
  final TimePickerTextBuilder textBuilder;

  @override
  State<StatefulWidget> createState() => FastFormFieldState<TimeOfDay>();
}

final FastFormFieldBuilder fastTimePickerBuilder = (context, state) {
  final theme = FastFormTheme.of(context);
  final widget = state.widget as FastTimePicker;
  final decoration = widget.decoration ??
      theme?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return TimePickerFormField(
    autovalidateMode: widget.autovalidateMode,
    decoration: decoration,
    enabled: widget.enabled,
    icon: widget.icon,
    initialValue: widget.initialValue,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    textBuilder: widget.textBuilder,
    validator: widget.validator,
  );
};
 */
