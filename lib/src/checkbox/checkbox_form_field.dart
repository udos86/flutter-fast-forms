import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    bool autofocus,
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    Key key,
    this.onChanged,
    FormFieldSetter onSaved,
    dynamic title,
    FormFieldValidator validator,
    bool value,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
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
          },
          initialValue: value ?? false,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

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
