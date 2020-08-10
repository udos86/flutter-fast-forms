import 'package:flutter/material.dart';

typedef CheckboxTitleBuilder = Widget Function(
    BuildContext context, CheckboxFormFieldState state);

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    bool autofocus,
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    Key key,
    this.onChanged,
    FormFieldSetter onSaved,
    this.title,
    CheckboxTitleBuilder titleBuilder,
    bool tristate = false,
    FormFieldValidator validator,
    bool value,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            final _titleBuilder = titleBuilder ?? checkboxTitleBuilder;
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
              ),
              child: CheckboxListTile(
                autofocus: autofocus,
                onChanged: field.didChange,
                selected: field.value,
                tristate: tristate,
                title: _titleBuilder(field.context, field),
                value: field.value,
              ),
            );
          },
          initialValue: value ?? false,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final String title;
  final ValueChanged<bool> onChanged;

  @override
  FormFieldState<bool> createState() => CheckboxFormFieldState();
}

class CheckboxFormFieldState extends FormFieldState<bool> {
  @override
  CheckboxFormField get widget => super.widget;

  @override
  void didChange(bool value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }
}

final CheckboxTitleBuilder checkboxTitleBuilder =
    (BuildContext context, CheckboxFormFieldState state) {
  return Text(
    state.widget.title,
    style: TextStyle(
      fontSize: 14.0,
      color: state.value ? Colors.black : Colors.grey,
    ),
  );
};
