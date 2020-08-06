import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    bool autofocus = false,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    String helper,
    @required String id,
    String initialValue,
    String label,
    FormFieldValidator validator,
    @required this.options,
    this.orientation = RadioGroupOrientation.vertical,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? _builder,
          decoration: decoration,
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
  final style = FormStyle.of(context);
  final widget = state.widget as FastRadioGroup;

  return RadioGroupFormField(
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    options: widget.options,
    orientation: widget.orientation,
    validator: widget.validator,
    value: state.value,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
  );
};
