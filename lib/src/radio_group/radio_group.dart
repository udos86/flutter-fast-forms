import 'package:flutter/material.dart';

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

typedef RadioOptionsBuilder = Widget Function(
    List<RadioOption> options, FastRadioGroupState state);

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
    required this.options,
    this.orientation = RadioGroupOrientation.vertical,
    ValueChanged<T>? onChanged,
    VoidCallback? onReset,
    this.optionsBuilder,
    FormFieldSetter? onSaved,
    FormFieldValidator? validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder =
                    scope?.builders[FastRadioGroup] ?? radioGroupBuilder;
                return builder(field);
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
  final RadioOptionsBuilder? optionsBuilder;
  final RadioGroupOrientation orientation;

  @override
  FastRadioGroupState<T> createState() => FastRadioGroupState<T>();
}

class FastRadioGroupState<T> extends FastFormFieldState<T> {
  @override
  FastRadioGroup<T> get widget => super.widget as FastRadioGroup<T>;
}

Flex radioOptionsBuilder(options, FastRadioGroupState state) {
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
}

InputDecorator radioGroupBuilder(FormFieldState field) {
  final state = field as FastRadioGroupState;
  final widget = state.widget;

  final theme = Theme.of(state.context);
  final decorator = FastFormScope.of(state.context)?.inputDecorator;
  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);
  final _optionsBuilder = widget.optionsBuilder ?? radioOptionsBuilder;

  return InputDecorator(
    decoration: effectiveDecoration.copyWith(
      contentPadding: widget.contentPadding,
      errorText: state.errorText,
    ),
    child: _optionsBuilder(widget.options, state),
  );
}
