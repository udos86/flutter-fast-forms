import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

@immutable
class RadioOption<T> {
  RadioOption({
    @required this.title,
    @required this.value,
  });

  final T value;
  final String title;
}

typedef RadioOptionsBuilder = Widget Function(
    List<RadioOption> options, FastRadioGroupState state);

enum RadioGroupOrientation { horizontal, vertical }

@immutable
class FastRadioGroup<T> extends FastFormField<T> {
  FastRadioGroup({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<T> builder,
    InputDecoration decoration,
    bool enabled = true,
    String helper,
    @required String id,
    T initialValue,
    Key key,
    String label,
    @required this.options,
    this.orientation = RadioGroupOrientation.vertical,
    ValueChanged<T> onChanged,
    VoidCallback onReset,
    this.optionsBuilder,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastRadioGroupState;
                final theme = Theme.of(state.context);
                final decorator =
                    FastFormScope.of(state.context).inputDecorator;
                final _decoration = decoration ??
                    decorator(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
                final _optionsBuilder = optionsBuilder ?? radioOptionsBuilder;
                return InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: state.errorText,
                  ),
                  child: _optionsBuilder(options, state),
                );
              },
          decoration: decoration,
          enabled: enabled,
          helper: helper,
          id: id,
          initialValue: initialValue ?? options.first.value,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final List<RadioOption<T>> options;
  final RadioOptionsBuilder optionsBuilder;
  final RadioGroupOrientation orientation;

  @override
  FastRadioGroupState<T> createState() => FastRadioGroupState<T>();
}

class FastRadioGroupState<T> extends FastFormFieldState<T> {
  @override
  FastRadioGroup<T> get widget => super.widget as FastRadioGroup<T>;
}

final RadioOptionsBuilder radioOptionsBuilder =
    (options, FastRadioGroupState state) {
  final vertical = state.widget.orientation == RadioGroupOrientation.vertical;
  final tiles = options.map((option) {
    final tile = RadioListTile(
      groupValue: state.value,
      onChanged: state.widget.enabled ? state.didChange : null,
      title: Text(option.title),
      value: option.value,
    );
    return vertical ? tile : Expanded(child: tile);
  }).toList();

  return vertical ? Column(children: tiles) : Row(children: tiles);
};
