import 'package:flutter/material.dart';

class SliderFormField extends FormField<double> {
  SliderFormField({
    Key key,
    double value,
    @required double min,
    @required double max,
    int divisions,
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
          initialValue: value ?? min,
          validator: validator,
          builder: (field) {
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Slider.adaptive(
                      value: field.value,
                      min: min,
                      max: max,
                      divisions: divisions ?? (max - min).toInt(),
                      label: label ?? "${_valueToString(field.value)}",
                      onChanged: field.didChange,
                    ),
                  ),
                  Container(
                    width: 32.0,
                    child: Text(
                      "${_valueToString(field.value)}",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

  final ValueChanged<double> onChanged;

  static String _valueToString(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  FormFieldState<double> createState() => _SliderFormFieldState();
}

class _SliderFormFieldState extends FormFieldState<double> {
  @override
  SliderFormField get widget => super.widget;

  @override
  void didChange(double value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }
}
