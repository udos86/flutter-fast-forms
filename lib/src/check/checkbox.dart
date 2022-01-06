import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastCheckboxTitleBuilder = Widget Function(FastCheckboxState field);

@immutable
class FastCheckbox extends FastFormField<bool> {
  const FastCheckbox({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<bool>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    bool initialValue = false,
    Key? key,
    String? label,
    required String name,
    ValueChanged<bool>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    required this.title,
    this.titleBuilder,
    this.tristate = false,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? checkboxBuilder,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String title;
  final FastCheckboxTitleBuilder? titleBuilder;
  final bool tristate;

  @override
  FastCheckboxState createState() => FastCheckboxState();
}

class FastCheckboxState extends FastFormFieldState<bool> {
  @override
  FastCheckbox get widget => super.widget as FastCheckbox;
}

Text checkboxTitleBuilder(FastCheckboxState field) {
  return Text(
    field.widget.title,
    style: TextStyle(
      fontSize: 14.0,
      color: field.value! ? Colors.black : Colors.grey,
    ),
  );
}

InputDecorator checkboxBuilder(FormFieldState<bool> field) {
  final widget = (field as FastCheckboxState).widget;
  final titleBuilder = widget.titleBuilder ?? checkboxTitleBuilder;

  return InputDecorator(
    decoration: field.decoration.copyWith(errorText: field.errorText),
    child: CheckboxListTile(
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      onChanged: widget.enabled ? field.didChange : null,
      selected: field.value ?? false,
      title: titleBuilder(field),
      tristate: widget.tristate,
      value: field.value,
    ),
  );
}
