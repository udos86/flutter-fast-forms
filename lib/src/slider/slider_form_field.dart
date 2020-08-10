import 'package:flutter/material.dart';

typedef SliderLabelBuilder = String Function(
    BuildContext context, SliderFormFieldState state);

typedef SliderFixBuilder = Widget Function(
    BuildContext context, SliderFormFieldState state);

class SliderFormField extends FormField<double> {
  SliderFormField({
    bool autofocus,
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    int divisions,
    FocusNode focusNode,
    Key key,
    @required this.max,
    @required this.min,
    SliderLabelBuilder labelBuilder,
    SliderFixBuilder prefixBuilder,
    this.onChanged,
    FormFieldSetter onSaved,
    SliderFixBuilder suffixBuilder,
    FormFieldValidator validator,
    double value,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
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
                      autofocus: autofocus,
                      divisions: divisions,
                      focusNode: focusNode,
                      label: labelBuilder?.call(field.context, field),
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
          initialValue: value ?? min,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final double max;
  final double min;
  final ValueChanged<double> onChanged;

  @override
  FormFieldState<double> createState() => SliderFormFieldState();
}

class SliderFormFieldState extends FormFieldState<double> {
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
