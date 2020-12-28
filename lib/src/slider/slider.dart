import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef SliderLabelBuilder = String Function(FastSliderState state);

typedef SliderFixBuilder = Widget Function(FastSliderState state);

@immutable
class FastSlider extends FastFormField<double> {
  FastSlider({
    bool adaptive = false,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<double> builder,
    InputDecoration decoration,
    bool enabled = true,
    this.divisions,
    FocusNode focusNode,
    String helper,
    @required String id,
    double initialValue,
    Key key,
    String label,
    @required this.max,
    @required this.min,
    this.labelBuilder,
    this.prefixBuilder,
    ValueChanged<double> onChanged,
    VoidCallback onReset,
    FormFieldSetter<double> onSaved,
    this.suffixBuilder,
    FormFieldValidator<double> validator,
  }) : super(
          adaptive: adaptive,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? sliderBuilder,
          decoration: decoration,
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

  final int divisions;
  final SliderLabelBuilder labelBuilder;
  final double max;
  final double min;
  final SliderFixBuilder prefixBuilder;
  final SliderFixBuilder suffixBuilder;

  @override
  FastSliderState createState() => FastSliderState();
}

class FastSliderState extends FastFormFieldState<double> {
  @override
  FastSlider get widget => super.widget as FastSlider;
}

final SliderLabelBuilder sliderLabelBuilder = (FastSliderState state) {
  return state.value.toStringAsFixed(0);
};

final SliderFixBuilder sliderSuffixBuilder = (FastSliderState state) {
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

final FormFieldBuilder<double> materialSliderBuilder =
    (FormFieldState<double> field) {
  final state = field as FastSliderState;
  final context = state.context;
  final widget = state.widget;
  final theme = Theme.of(context);
  final decorator = FastFormScope.of(context).inputDecorator;
  final _decoration = widget.decoration ??
      decorator(context, widget) ??
      const InputDecoration();
  final effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);

  return InputDecorator(
    decoration: effectiveDecoration.copyWith(
      errorText: state.errorText,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder(state),
        Expanded(
          child: Slider.adaptive(
            autofocus: widget.autofocus,
            divisions: widget.divisions,
            focusNode: state.focusNode,
            label: widget.labelBuilder?.call(state),
            max: widget.max,
            min: widget.min,
            value: state.value,
            onChanged: widget.enabled ? state.didChange : null,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder(state),
      ],
    ),
  );
};

final FormFieldBuilder<double> cupertinoSliderBuilder =
    (FormFieldState<double> field) {
  final state = field as FastSliderState;
  final widget = state.widget;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      if (widget.prefixBuilder != null) widget.prefixBuilder(state),
      Expanded(
        child: CupertinoSlider(
          divisions: widget.divisions,
          max: widget.max,
          min: widget.min,
          value: state.value,
          onChanged: widget.enabled ? state.didChange : null,
        ),
      ),
      if (widget.suffixBuilder != null) widget.suffixBuilder(state),
    ],
  );
};

final FormFieldBuilder<double> sliderBuilder = (FormFieldState<double> field) {
  final state = field as FastSliderState;
  if (state.widget.adaptive) {
    switch (Theme.of(state.context).platform) {
      case TargetPlatform.iOS:
        return cupertinoSliderBuilder(field);
      case TargetPlatform.android:
      default:
        return materialSliderBuilder(field);
    }
  }
  return materialSliderBuilder(field);
};
