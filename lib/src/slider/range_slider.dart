import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef RangeSliderLabelsBuilder = RangeLabels Function(
    FastRangeSliderState state);

typedef RangeSliderFixBuilder = Widget Function(FastRangeSliderState state);

@immutable
class FastRangeSlider extends FastFormField<RangeValues> {
  FastRangeSlider({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<RangeValues> builder,
    InputDecoration decoration,
    int divisions,
    bool enabled = true,
    String helper,
    @required String id,
    RangeValues initialValue,
    Key key,
    String label,
    RangeSliderLabelsBuilder labelsBuilder,
    @required double min,
    @required double max,
    RangeSliderFixBuilder prefixBuilder,
    RangeSliderFixBuilder suffixBuilder,
    ValueChanged<RangeValues> onChanged,
    VoidCallback onReset,
    FormFieldSetter<RangeValues> onSaved,
    FormFieldValidator<RangeValues> validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastRangeSliderState;
                final theme = Theme.of(state.context);
                final decorator =
                    FastFormScope.of(state.context).inputDecorator;
                final _decoration = decoration ??
                    decorator(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
                return InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: state.errorText,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (prefixBuilder != null) prefixBuilder(state),
                      Expanded(
                        child: RangeSlider(
                          divisions: divisions,
                          labels: labelsBuilder?.call(state),
                          min: min,
                          max: max,
                          values: state.value,
                          onChanged: enabled ? state.didChange : null,
                        ),
                      ),
                      if (suffixBuilder != null) suffixBuilder(state),
                    ],
                  ),
                );
              },
          decoration: decoration,
          enabled: enabled,
          helper: helper,
          key: key,
          id: id,
          initialValue: initialValue ?? RangeValues(min, max),
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  @override
  FastRangeSliderState createState() => FastRangeSliderState();
}

class FastRangeSliderState extends FastFormFieldState<RangeValues> {
  @override
  FastRangeSlider get widget => super.widget as FastRangeSlider;
}

final RangeSliderLabelsBuilder rangeSliderLabelsBuilder =
    (FastRangeSliderState state) {
  return RangeLabels(
    state.value.start.toStringAsFixed(0),
    state.value.end.toStringAsFixed(0),
  );
};

final RangeSliderFixBuilder rangeSliderPrefixBuilder =
    (FastRangeSliderState state) {
  return Container(
    width: 48.0,
    child: Center(
      child: Text(
        state.value.start.toStringAsFixed(0),
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ),
  );
};

final RangeSliderFixBuilder rangeSliderSuffixBuilder =
    (FastRangeSliderState state) {
  return Container(
    width: 48.0,
    child: Center(
      child: Text(
        state.value.end.toStringAsFixed(0),
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ),
  );
};
