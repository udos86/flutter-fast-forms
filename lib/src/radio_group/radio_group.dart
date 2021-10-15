import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form_field.dart';
import '../form_scope.dart';

@immutable
class RadioOption<T> {
  const RadioOption({
    required this.title,
    required this.value,
  });

  final T value;
  final String title;
}

typedef RadioOptionBuilder<T> = Widget Function(
    RadioOption<T> option, FastRadioGroupState<T> state);

typedef RadioOptionsBuilder<T> = Widget Function(
    List<RadioOption<T>> options, FastRadioGroupState<T> state);

enum RadioGroupOrientation { horizontal, vertical }

@immutable
class FastRadioGroup<T> extends FastFormField<T> {
  FastRadioGroup({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<T>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    T? initialValue,
    Key? key,
    String? label,
    ValueChanged<T>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    this.orientation = RadioGroupOrientation.vertical,
    required this.options,
    this.optionBuilder,
    this.optionsBuilder,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder =
                    scope?.builders[FastRadioGroup] ?? radioGroupBuilder;
                return builder<T>(field);
              },
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
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
  final RadioOptionBuilder<T>? optionBuilder;
  final RadioOptionsBuilder<T>? optionsBuilder;
  final RadioGroupOrientation orientation;

  @override
  FastRadioGroupState<T> createState() => FastRadioGroupState<T>();
}

class FastRadioGroupState<T> extends FastFormFieldState<T> {
  @override
  FastRadioGroup<T> get widget => super.widget as FastRadioGroup<T>;
}

Widget radioOptionBuilder<T>(
    RadioOption<T> option, FastRadioGroupState<T> state) {
  final vertical = state.widget.orientation == RadioGroupOrientation.vertical;
  final tile = RadioListTile<T>(
    groupValue: state.value,
    onChanged: state.widget.enabled ? state.didChange : null,
    title: Text(option.title),
    value: option.value,
  );
  return vertical ? tile : Expanded(child: tile);
}

Flex radioOptionsBuilder<T>(
    List<RadioOption<T>> options, FastRadioGroupState<T> state) {
  final optionBuilder = state.widget.optionBuilder ?? radioOptionBuilder;
  final vertical = state.widget.orientation == RadioGroupOrientation.vertical;
  final tiles = options.map((option) => optionBuilder(option, state)).toList();

  return vertical ? Column(children: tiles) : Row(children: tiles);
}

InputDecorator radioGroupBuilder<T>(FormFieldState field) {
  final state = field as FastRadioGroupState<T>;
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
    // Try to refactor when constructor tear-offs arrive -> https://github.com/dart-lang/language/blob/master/accepted/future-releases/constructor-tearoffs/feature-specification.md
    child: widget.optionsBuilder != null
        ? widget.optionsBuilder!(widget.options, state)
        : radioOptionsBuilder<T>(widget.options, state),
  );
}
