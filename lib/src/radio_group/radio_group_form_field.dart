import 'package:flutter/material.dart';

import '../radio_group/radio_group_model.dart';

enum RadioGroupOrientation {
  horizontal,
  vertical,
}

class RadioGroupFormField<T> extends FormField<T> {
  RadioGroupFormField({
    Key key,
    T value,
    @required List<RadioOption<T>> options,
    RadioGroupOrientation orientation = RadioGroupOrientation.vertical,
    this.onChanged,
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
  })  : assert(decoration != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value ?? options[0].value,
          validator: validator,
          builder: (field) {
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              child: orientation == RadioGroupOrientation.horizontal
                  ? Row(
                      children: _buildOptions<T>(
                          options, field, RadioGroupOrientation.horizontal),
                    )
                  : Column(
                      children: _buildOptions<T>(options, field),
                    ),
            );
          },
        );

  final ValueChanged<T> onChanged;

  @override
  FormFieldState<T> createState() => _RadioGroupFormFieldState<T>();

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
          : Expanded(
              child: tile,
            );
    }).toList();
  }
}

class _RadioGroupFormFieldState<T> extends FormFieldState<T> {
  @override
  RadioGroupFormField<T> get widget => super.widget;

  @override
  void didChange(T value) {
    super.didChange(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }
}
