import 'package:flutter/material.dart';

typedef RangeSliderLabelsBuilder = RangeLabels Function(
    BuildContext context, RangeSliderFormFieldState state);

typedef RangeSliderFixBuilder = Widget Function(
    BuildContext context, RangeSliderFormFieldState state);

class RangeSliderFormField extends FormField<RangeValues> {
  RangeSliderFormField({
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    int divisions,
    bool enabled = true,
    RangeValues initialValue,
    Key key,
    String label,
    RangeSliderLabelsBuilder labelsBuilder,
    @required double min,
    @required double max,
    RangeSliderFixBuilder prefixBuilder,
    RangeSliderFixBuilder suffixBuilder,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
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
                  if (prefixBuilder != null)
                    prefixBuilder(field.context, field),
                  Expanded(
                    child: RangeSlider(
                      divisions: divisions,
                      labels: labelsBuilder?.call(field.context, field),
                      min: min,
                      max: max,
                      values: field.value,
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
          key: key,
          initialValue: initialValue ?? RangeValues(min, max),
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged<RangeValues> onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<RangeValues> createState() => RangeSliderFormFieldState();
}

class RangeSliderFormFieldState extends FormFieldState<RangeValues> {
  @override
  RangeSliderFormField get widget => super.widget as RangeSliderFormField;

  @override
  void didChange(RangeValues value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
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
    (BuildContext context, FormFieldState<RangeValues> state) {
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
