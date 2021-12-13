import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form_field.dart';

@immutable
class FastRadioOption<T> {
  const FastRadioOption({required this.label, required this.value});

  final String label;
  final T value;
}

typedef FastRadioOptionBuilder<T> = Widget Function(
    FastRadioOption<T> option, FastRadioGroupState<T> state);

typedef FastRadioOptionsBuilder<T> = Widget Function(
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
    T? initialValue,
    Key? key,
    String? label,
    required String name,
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
          builder: builder ?? radioGroupBuilder<T>,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue ?? options.first.value,
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final List<FastRadioOption<T>> options;
  final FastRadioOptionBuilder<T>? optionBuilder;
  final FastRadioOptionsBuilder<T>? optionsBuilder;
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
    title: Text(option.label),
    value: option.value,
  );

  return vertical ? tile : Expanded(child: tile);
}

Flex radioOptionsBuilder<T>(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> state) {
  final optionBuilder = state.widget.optionBuilder ?? radioOptionBuilder;
  final wrapper = state.widget.orientation == FastRadioGroupOrientation.vertical
      ? Column.new
      : Row.new;

  return wrapper(
    children: [
      for (final option in options) optionBuilder(option, state),
    ],
  );
}

InputDecorator radioGroupBuilder<T>(FormFieldState<T> field) {
  final state = field as FastRadioGroupState<T>;
  final widget = state.widget;
  final optionsBuilder = widget.optionsBuilder ?? radioOptionsBuilder;

  return InputDecorator(
    decoration: state.decoration.copyWith(
      contentPadding: widget.contentPadding,
      errorText: state.errorText,
    ),
    child: optionsBuilder(widget.options, state),
  );
}
