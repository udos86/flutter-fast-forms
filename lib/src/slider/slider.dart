import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';

typedef SliderLabelBuilder = String Function(
    BuildContext context, FastSliderState state);

typedef SliderFixBuilder = Widget Function(
    BuildContext context, FastSliderState state);

class FastSlider extends FastFormField<double> {
  FastSlider({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<double> builder,
    InputDecoration decoration,
    bool enabled = true,
    int divisions,
    FocusNode focusNode,
    String helper,
    @required String id,
    double initialValue,
    Key key,
    String label,
    @required this.max,
    @required this.min,
    SliderLabelBuilder labelBuilder,
    SliderFixBuilder prefixBuilder,
    ValueChanged<double> onChanged,
    VoidCallback onReset,
    FormFieldSetter<double> onSaved,
    SliderFixBuilder suffixBuilder,
    FormFieldValidator<double> validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastSliderState;
                final theme = Theme.of(field.context);
                final formTheme = FastFormTheme.of(state.context);
                final _decoration = decoration ??
                    formTheme.getInputDecoration(state.context, state.widget) ??
                    const InputDecoration();
                final effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
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
          helper: helper,
          id: id,
          initialValue: initialValue ?? min,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final double max;
  final double min;

  @override
  FormFieldState<double> createState() => FastSliderState();
}

class FastSliderState extends FastFormFieldState<double> {
  @override
  FastSlider get widget => super.widget as FastSlider;
}

final SliderLabelBuilder sliderLabelBuilder =
    (BuildContext context, FastSliderState state) {
  return state.value.toStringAsFixed(0);
};

final SliderFixBuilder sliderSuffixBuilder =
    (BuildContext context, FastSliderState state) {
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
