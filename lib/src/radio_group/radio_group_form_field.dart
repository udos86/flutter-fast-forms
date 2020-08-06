import 'package:flutter/material.dart';

import '../radio_group/radio_group.dart';

enum RadioGroupOrientation {
  horizontal,
  vertical,
}

class RadioGroupFormField<T> extends FormField<T> {
  RadioGroupFormField({
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    Key key,
    @required List<RadioOption<T>> options,
    RadioGroupOrientation orientation = RadioGroupOrientation.vertical,
    this.onChanged,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    T value,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            final _options = _buildOptions<T>(options, field, orientation);
            return InputDecorator(
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                ),
                child: orientation == RadioGroupOrientation.horizontal
                    ? Row(children: _options)
                    : Column(children: _options));
          },
          initialValue: value ?? options.first.value,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged onChanged;

  @override
  FormFieldState<T> createState() => RadioGroupFormFieldState<T>();

  static List<Widget> _buildOptions<T>(
      List<RadioOption<T>> options, FormFieldState<T> field,
      [RadioGroupOrientation orientation = RadioGroupOrientation.vertical]) {
    return options.map((option) {
      final tile = RadioListTile<T>(
        title: Text(option.title),
        value: option.value,
        groupValue: field.value,
        onChanged: field.didChange,
      );

      return orientation == RadioGroupOrientation.vertical
          ? tile
          : Expanded(child: tile);
    }).toList();
  }
}

class RadioGroupFormFieldState<T> extends FormFieldState<T> {
  @override
  RadioGroupFormField<T> get widget => super.widget;

  @override
  void didChange(T value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }
}
