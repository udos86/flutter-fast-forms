import 'package:flutter/material.dart';

typedef RangeSliderLabelsBuilder = RangeLabels Function(
    BuildContext context, FormFieldState<RangeValues> state);

typedef RangeSliderFixBuilder = Widget Function(
    BuildContext context, FormFieldState<RangeValues> state);

class RangeSliderFormField extends FormField<RangeValues> {
  RangeSliderFormField({
    InputDecoration decoration = const InputDecoration(),
    Key key,
    int divisions,
    Widget hint,
    String label,
    RangeSliderLabelsBuilder labelsBuilder,
    @required double min,
    @required double max,
    RangeSliderFixBuilder prefixBuilder,
    RangeSliderFixBuilder suffixBuilder,
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
            final labels = labelsBuilder != null
                ? labelsBuilder(field.context, field)
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
                    child: RangeSlider(
                      divisions: divisions,
                      labels: labels,
                      min: min,
                      max: max,
                      values: field.value,
                      onChanged: field.didChange,
                    ),
                  ),
                  if (suffixBuilder != null)
                    suffixBuilder(field.context, field),
                ],
              ),
            );
          },
        );

  final ValueChanged<RangeValues> onChanged;

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

final RangeSliderLabelsBuilder rangeSliderLabelsBuilder =
    (BuildContext context, FormFieldState<RangeValues> state) {
  return RangeLabels(
    state.value.start.toStringAsFixed(0),
    state.value.end.toStringAsFixed(0),
  );
};

final RangeSliderFixBuilder rangeSliderPrefixBuilder =
    (BuildContext context, FormFieldState<RangeValues> state) {
  return Container(
    width: 32.0,
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
    (BuildContext context, FormFieldState<RangeValues> state) {
  return Container(
    width: 32.0,
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
