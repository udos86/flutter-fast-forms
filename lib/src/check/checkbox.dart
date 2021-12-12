import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastCheckboxTitleBuilder = Widget Function(FastCheckboxState state);

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

Text checkboxTitleBuilder(FastCheckboxState state) {
  return Text(
    state.widget.title,
    style: TextStyle(
      fontSize: 14.0,
      color: state.value! ? Colors.black : Colors.grey,
    ),
  );
}

InputDecorator checkboxBuilder(FormFieldState<bool> field) {
  final state = field as FastCheckboxState;
  final widget = state.widget;

  final titleBuilder = widget.titleBuilder ?? checkboxTitleBuilder;

  return InputDecorator(
    decoration: state.decoration.copyWith(errorText: state.errorText),
    child: CheckboxListTile(
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      onChanged: widget.enabled ? state.didChange : null,
      selected: state.value ?? false,
      title: titleBuilder(state),
      tristate: widget.tristate,
      value: state.value,
    ),
  );
}
