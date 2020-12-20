import 'package:flutter/material.dart';

typedef SliderLabelBuilder = String Function(
    BuildContext context, SliderFormFieldState state);

typedef SliderFixBuilder = Widget Function(
    BuildContext context, SliderFormFieldState state);

class SliderFormField extends FormField<double> {
  SliderFormField({
    bool autofocus,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    InputDecoration decoration = const InputDecoration(),
    bool enabled = true,
    int divisions,
    FocusNode focusNode,
    double initialValue,
    Key key,
    @required this.max,
    @required this.min,
    SliderLabelBuilder labelBuilder,
    SliderFixBuilder prefixBuilder,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    SliderFixBuilder suffixBuilder,
    FormFieldValidator validator,
  })  : assert(decoration != null),
        super(
          autovalidateMode: autovalidateMode,
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
                      onChanged: enabled ? field.didChange : null,
                    ),
                  ),
                  if (suffixBuilder != null)
                    suffixBuilder(field.context, field),
                ],
              ),
            );
          },
          enabled: enabled,
          initialValue: initialValue ?? min,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final double max;
  final double min;
  final ValueChanged<double> onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<double> createState() => SliderFormFieldState();
}

class SliderFormFieldState extends FormFieldState<double> {
  @override
  SliderFormField get widget => super.widget as SliderFormField;

  @override
  void didChange(double value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
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
