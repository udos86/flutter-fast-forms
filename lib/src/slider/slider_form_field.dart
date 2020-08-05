import 'package:flutter/material.dart';

typedef SliderLabelBuilder = String Function(
    BuildContext context, double value);

class SliderFormField extends FormField<double> {
  SliderFormField({
    Key key,
    InputDecoration decoration = const InputDecoration(),
    int divisions,
    @required double min,
    @required double max,
    SliderLabelBuilder labelBuilder,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    double value,
    this.onChanged,
  })  : assert(decoration != null),
        super(
          builder: (field) {
            final effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            final label = labelBuilder != null
                ? labelBuilder(field.context, field.value)
                : _labelBuilder(field.context, field.value);
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Slider.adaptive(
                      divisions: divisions ?? (max - min).toInt(),
                      label: label,
                      max: max,
                      min: min,
                      value: field.value,
                      onChanged: field.didChange,
                    ),
                  ),
                  Container(
                    width: 32.0,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          key: key,
          initialValue: value ?? min,
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged<double> onChanged;

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

final SliderLabelBuilder _labelBuilder = (BuildContext context, double value) {
  return value.toStringAsFixed(0);
};
