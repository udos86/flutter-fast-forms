import 'package:flutter/material.dart';

@immutable
class CustomFormFieldValue {
  CustomFormFieldValue({
    this.checkboxA = false,
    this.checkboxB = false,
  });

  final bool checkboxA;
  final bool checkboxB;
}

class CustomFormField extends FormField<CustomFormFieldValue> {
  CustomFormField({
    Key key,
    CustomFormFieldValue value,
    String label,
    String placeholder,
    this.onChanged,
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    Widget hint,
  })  : assert(decoration != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value ?? CustomFormFieldValue(),
          validator: validator,
          builder: (_field) {
            final field = _field as _CustomFormFieldState;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text('Test'),
                    value: field.active,
                    onChanged: (value) => field.active = value,
                  ),
                  if (field.active) field.buildActiveSegment(),
                ],
              ),
            );
          },
        );

  final ValueChanged onChanged;

  @override
  FormFieldState<CustomFormFieldValue> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends FormFieldState<CustomFormFieldValue>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;

  bool get active => _isActive;

  set active(bool value) {
    setState(() {
      _isActive = value;
    });
  }

  @override
  CustomFormField get widget => super.widget;

  @override
  void didChange(CustomFormFieldValue value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }

  Widget buildActiveSegment() {
    return Column(
      children: <Widget>[
        Divider(
          height: 4.0,
          color: Colors.black,
        ),
        CheckboxListTile(
          title: Text('Checkbox A'),
          value: value.checkboxA,
          onChanged: (bool checked) {
            didChange(CustomFormFieldValue(
              checkboxA: checked,
              checkboxB: value.checkboxB,
            ));
          },
        ),
        CheckboxListTile(
          title: Text('Checkbox B'),
          value: value.checkboxB,
          onChanged: (bool checked) {
            didChange(CustomFormFieldValue(
              checkboxA: value.checkboxA,
              checkboxB: checked,
            ));
          },
        ),
      ],
    );
  }
}
