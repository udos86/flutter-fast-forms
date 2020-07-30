import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    Key key,
    bool value,
    String label,
    this.onChanged,
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    Widget hint,
  })  : assert(decoration != null),
        super(
            key: key,
            onSaved: onSaved,
            initialValue: value ?? false,
            validator: validator,
            builder: (field) {
              final InputDecoration effectiveDecoration =
                  decoration.applyDefaults(Theme.of(field.context).inputDecorationTheme);
              return InputDecorator(
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                ),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: field.value,
                      onChanged: field.didChange,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: field.value ? Colors.black : Colors.grey,
                      ),
                    )
                  ],
                ),
              );
            });

  final ValueChanged onChanged;

  @override
  FormFieldState<bool> createState() => _SwitchFormFieldState();
}

class _SwitchFormFieldState extends FormFieldState<bool> {
  @override
  CheckboxFormField get widget => super.widget;

  @override
  void didChange(bool value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }
}
