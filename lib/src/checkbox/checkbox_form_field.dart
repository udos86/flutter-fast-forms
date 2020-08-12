import 'package:flutter/material.dart';

typedef CheckboxTitleBuilder = Widget Function(
    BuildContext context, CheckboxFormFieldState state);

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    bool autofocus,
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    bool initialValue,
    Key key,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    this.title,
    CheckboxTitleBuilder titleBuilder,
    bool tristate = false,
    FormFieldValidator validator,
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
          initialValue: initialValue ?? false,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final String title;
  final ValueChanged<bool> onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<bool> createState() => CheckboxFormFieldState();
}

class CheckboxFormFieldState extends FormFieldState<bool> {
  @override
  CheckboxFormField get widget => super.widget as CheckboxFormField;

  @override
  void didChange(bool value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
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
