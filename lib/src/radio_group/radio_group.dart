import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';

import 'radio_group_form_field.dart';
/*
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
    bool autofocus,
    AutovalidateMode autovalidateMode,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    bool enabled,
    String helper,
    @required String id,
    String initialValue,
    String label,
    @required this.options,
    this.orientation = RadioGroupOrientation.vertical,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus ?? false,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          builder: builder ?? _builder,
          decoration: decoration,
          enabled: enabled ?? true,
          helper: helper,
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

final FastFormFieldBuilder _builder = (context, state) {
  final theme = FastFormTheme.of(context);
  final widget = state.widget as FastRadioGroup;
  final decoration = widget.decoration ??
      theme?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return RadioGroupFormField(
    autovalidateMode: widget.autovalidateMode,
    decoration: decoration,
    enabled: widget.enabled,
    initialValue: widget.initialValue,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    options: widget.options,
    orientation: widget.orientation,
    validator: widget.validator,
  );
};
*/
