import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form_field.dart';

@immutable
class FastRadioOption<T> {
  const FastRadioOption({required this.title, required this.value});

  final T value;
  final String title;
}

typedef RadioOptionBuilder<T> = Widget Function(
    FastRadioOption<T> option, FastRadioGroupState<T> state);

typedef RadioOptionsBuilder<T> = Widget Function(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> state);

enum FastRadioGroupOrientation { horizontal, vertical }

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
    this.orientation = FastRadioGroupOrientation.vertical,
    required this.options,
    this.optionBuilder,
    this.optionsBuilder,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? (field) => radioGroupBuilder<T>(field),
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

  final List<FastRadioOption<T>> options;
  final RadioOptionBuilder<T>? optionBuilder;
  final RadioOptionsBuilder<T>? optionsBuilder;
  final FastRadioGroupOrientation orientation;

  @override
  FastRadioGroupState<T> createState() => FastRadioGroupState<T>();
}

class FastRadioGroupState<T> extends FastFormFieldState<T> {
  @override
  FastRadioGroup<T> get widget => super.widget as FastRadioGroup<T>;
}

Widget radioOptionBuilder<T>(
    FastRadioOption<T> option, FastRadioGroupState<T> state) {
  final vertical =
      state.widget.orientation == FastRadioGroupOrientation.vertical;
  final tile = RadioListTile<T>(
    groupValue: state.value,
    onChanged: state.widget.enabled ? state.didChange : null,
    title: Text(option.title),
    value: option.value,
  );

  return vertical ? tile : Expanded(child: tile);
}

Flex radioOptionsBuilder<T>(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> state) {
  final optionBuilder = state.widget.optionBuilder ?? radioOptionBuilder;
  final vertical =
      state.widget.orientation == FastRadioGroupOrientation.vertical;
  final tiles = options.map((option) => optionBuilder(option, state)).toList();

  return vertical ? Column(children: tiles) : Row(children: tiles);
}

InputDecorator radioGroupBuilder<T>(FormFieldState<T> field) {
  final state = field as FastRadioGroupState<T>;
  final widget = state.widget;

  return InputDecorator(
    decoration: state.decoration.copyWith(
      contentPadding: widget.contentPadding,
      errorText: state.errorText,
    ),
    // Try to refactor when Tear-Offs arrive in Dart
    child: widget.optionsBuilder != null
        ? widget.optionsBuilder!(widget.options, state)
        : radioOptionsBuilder<T>(widget.options, state),
  );
}
