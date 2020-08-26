import 'package:flutter/material.dart';

@immutable
class CustomValue {
  CustomValue({
    this.checkboxA = false,
    this.checkboxB = false,
  });

  final bool checkboxA;
  final bool checkboxB;
}

class CustomFormField extends FormField<CustomValue> {
  CustomFormField({
    InputDecoration decoration = const InputDecoration(),
    Key key,
    String label,
    String placeholder,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    CustomValue initialValue,
  })  : assert(decoration != null),
        super(
          builder: (_field) {
            final field = _field as CustomFormFieldState;
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
          initialValue: initialValue ?? CustomValue(),
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<CustomValue> createState() => CustomFormFieldState();
}

class CustomFormFieldState extends FormFieldState<CustomValue> {
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
  void didChange(CustomValue value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }

  @override
  void reset() {
    super.reset();
    active = false;
    widget.onReset?.call();
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
            didChange(CustomValue(
              checkboxA: checked,
              checkboxB: value.checkboxB,
            ));
          },
        ),
        CheckboxListTile(
          title: Text('Checkbox B'),
          value: value.checkboxB,
          onChanged: (bool checked) {
            didChange(CustomValue(
              checkboxA: value.checkboxA,
              checkboxB: checked,
            ));
          },
        ),
      ],
    );
  }
}
