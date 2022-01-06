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
    FastRadioOption<T> option, FastRadioGroupState<T> field);

typedef FastRadioOptionsBuilder<T> = Widget Function(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> field);

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
    FastRadioOption<T> option, FastRadioGroupState<T> field) {
  final vertical =
      field.widget.orientation == FastRadioGroupOrientation.vertical;
  final tile = RadioListTile<T>(
    groupValue: field.value,
    onChanged: field.widget.enabled ? field.didChange : null,
    title: Text(option.label),
    value: option.value,
  );

  return vertical ? tile : Expanded(child: tile);
}

Flex radioOptionsBuilder<T>(
    List<FastRadioOption<T>> options, FastRadioGroupState<T> field) {
  final optionBuilder = field.widget.optionBuilder ?? radioOptionBuilder;
  final wrapper = field.widget.orientation == FastRadioGroupOrientation.vertical
      ? Column.new
      : Row.new;

  return wrapper(
    children: [for (final option in options) optionBuilder(option, field)],
  );
}

InputDecorator radioGroupBuilder<T>(FormFieldState<T> field) {
  final widget = (field as FastRadioGroupState<T>).widget;
  final optionsBuilder = widget.optionsBuilder ?? radioOptionsBuilder;

  return InputDecorator(
    decoration: field.decoration.copyWith(
      contentPadding: widget.contentPadding,
      errorText: field.errorText,
    ),
    child: optionsBuilder(widget.options, field),
  );
}
