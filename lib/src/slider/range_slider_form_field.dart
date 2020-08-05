import 'package:flutter/material.dart';

typedef RangeLabelsBuilder = RangeLabels Function(
    BuildContext context, RangeValues values);

class RangeSliderFormField extends FormField<RangeValues> {
  RangeSliderFormField({
    InputDecoration decoration = const InputDecoration(),
    Key key,
    int divisions,
    Widget hint,
    String label,
    RangeLabelsBuilder labelsBuilder,
    @required double min,
    @required double max,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    RangeValues value,
    this.onChanged,
  })  : assert(decoration != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value ?? RangeValues(0.0, 10.0),
          validator: validator,
          builder: (field) {
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 32.0,
                    child: Center(
                      child: Text(
                        _valueToString(field.value.start),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: field.value,
                      min: min,
                      max: max,
                      divisions: divisions ?? (max - min).toInt(),
                      labels: labelsBuilder != null
                          ? labelsBuilder(field.context, field.value)
                          : RangeLabels(
                              _valueToString(field.value.start),
                              _valueToString(field.value.end),
                            ),
                      onChanged: field.didChange,
                    ),
                  ),
                  Container(
                    width: 32.0,
                    child: Center(
                      child: Text(
                        _valueToString(field.value.end),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

  final ValueChanged<RangeValues> onChanged;

  static String _valueToString(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  FormFieldState<RangeValues> createState() => _SliderFormFieldState();
}

class _SliderFormFieldState extends FormFieldState<RangeValues> {
  @override
  RangeSliderFormField get widget => super.widget;

  @override
  void didChange(RangeValues value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }
}
