import 'package:flutter/material.dart';

typedef SliderLabelBuilder = String Function(
    BuildContext context, FormFieldState<double> state);

typedef SliderFixBuilder = Widget Function(
    BuildContext context, FormFieldState<double> state);

class SliderFormField extends FormField<double> {
  SliderFormField({
    Key key,
    InputDecoration decoration = const InputDecoration(),
    int divisions,
    @required double min,
    @required double max,
    SliderLabelBuilder labelBuilder,
    SliderFixBuilder prefixBuilder,
    FormFieldSetter onSaved,
    SliderFixBuilder suffixBuilder,
    FormFieldValidator validator,
    double value,
    this.onChanged,
  })  : assert(decoration != null),
        super(
          builder: (field) {
            final effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            final label = labelBuilder != null
                ? labelBuilder(field.context, field)
                : null;
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (prefixBuilder != null)
                    prefixBuilder(field.context, field),
                  Expanded(
                    child: Slider.adaptive(
                      divisions: divisions,
                      label: label,
                      max: max,
                      min: min,
                      value: field.value,
                      onChanged: field.didChange,
                    ),
                  ),
                  if (suffixBuilder != null)
                    suffixBuilder(field.context, field),
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

final SliderLabelBuilder sliderLabelBuilder =
    (BuildContext context, FormFieldState<double> state) {
  return state.value.toStringAsFixed(0);
};

final SliderFixBuilder sliderPrefixBuilder =
    (BuildContext context, FormFieldState<double> state) {
  return null;
};

final SliderFixBuilder sliderSuffixBuilder =
    (BuildContext context, FormFieldState<double> state) {
  return Container(
    width: 32.0,
    child: Text(
      state.value.toStringAsFixed(0),
      style: TextStyle(
        fontSize: 16.0,
      ),
    ),
  );
};
