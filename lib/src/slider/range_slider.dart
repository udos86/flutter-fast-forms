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
    FormFieldBuilder<RangeValues>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    this.divisions,
    bool enabled = true,
    String? helperText,
    required String id,
    RangeValues? initialValue,
    Key? key,
    String? label,
    this.labelsBuilder,
    required this.min,
    required this.max,
    this.prefixBuilder,
    this.suffixBuilder,
    ValueChanged<RangeValues>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<RangeValues>? onSaved,
    FormFieldValidator<RangeValues>? validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder = scope?.builders[FastRangeSlider] ??
                    adaptiveRangeSliderBuilder;
                return builder(field);
              },
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          key: key,
          id: id,
          initialValue: initialValue ?? RangeValues(min, max),
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final int? divisions;
  final RangeSliderLabelsBuilder? labelsBuilder;
  final double max;
  final double min;
  final RangeSliderFixBuilder? prefixBuilder;
  final RangeSliderFixBuilder? suffixBuilder;

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
    state.value!.start.toStringAsFixed(0),
    state.value!.end.toStringAsFixed(0),
  );
};

final RangeSliderFixBuilder rangeSliderPrefixBuilder =
    (FastRangeSliderState state) {
  return Container(
    width: 48.0,
    child: Center(
      child: Text(
        state.value!.start.toStringAsFixed(0),
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
        state.value!.end.toStringAsFixed(0),
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ),
  );
};

final FormFieldBuilder<RangeValues> rangeSliderBuilder =
    (FormFieldState<RangeValues> field) {
  final state = field as FastRangeSliderState;
  final widget = state.widget;
  final theme = Theme.of(state.context);
  final decorator = FastFormScope.of(state.context)?.inputDecorator;
  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);
  return InputDecorator(
    decoration: effectiveDecoration.copyWith(
      contentPadding: widget.contentPadding,
      errorText: state.errorText,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder!(state),
        Expanded(
          child: RangeSlider(
            divisions: widget.divisions,
            labels: widget.labelsBuilder?.call(state),
            max: widget.max,
            min: widget.min,
            values: state.value!,
            onChanged: widget.enabled ? state.didChange : null,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(state),
      ],
    ),
  );
};

final FormFieldBuilder<RangeValues> adaptiveRangeSliderBuilder =
    (FormFieldState<RangeValues> field) {
  final state = field as FastRangeSliderState;

  if (state.adaptive) {
    switch (Theme.of(state.context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      default:
        return rangeSliderBuilder(field);
    }
  }
  return rangeSliderBuilder(field);
};
