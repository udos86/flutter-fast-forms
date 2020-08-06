import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    Key key,
    bool autofocus,
    bool value,
    this.onChanged,
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter onSaved,
    dynamic title,
    FormFieldValidator validator,
    Widget hint,
  })  : assert(decoration != null),
        super(
            key: key,
            onSaved: onSaved,
            initialValue: value ?? false,
            validator: validator,
            builder: (field) {
              final InputDecoration effectiveDecoration = decoration
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              return InputDecorator(
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                ),
                child: CheckboxListTile(
                  autofocus: autofocus,
                  selected: field.value,
                  value: field.value,
                  onChanged: field.didChange,
                  title: title is Widget
                      ? title
                      : Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: field.value ? Colors.black : Colors.grey,
                          ),
                        ),
                ),
              );
            });

  final ValueChanged<bool> onChanged;

  @override
  FormFieldState<bool> createState() => _CheckboxFormFieldState();
}

class _CheckboxFormFieldState extends FormFieldState<bool> {
  @override
  CheckboxFormField get widget => super.widget;

  @override
  void didChange(bool value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }
}
