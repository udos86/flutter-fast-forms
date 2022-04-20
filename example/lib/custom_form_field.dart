import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

@immutable
class FastCustomOption {
  const FastCustomOption({required this.label, required this.name});

  final String label;
  final String name;
}

class FastCustomField extends FastFormField<Map<String, bool>> {
  const FastCustomField({
    InputDecoration? decoration,
    String? helperText,
    Map<String, bool>? initialValue,
    Key? key,
    String? labelText,
    required String name,
    ValueChanged<Map<String, bool>?>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<Map<String, bool>>? onSaved,
    FormFieldValidator<Map<String, bool>>? validator,
    required this.options,
    this.title,
  }) : super(
          builder: _customFormFieldBuilder,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          labelText: labelText,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final List<FastCustomOption> options;
  final Widget? title;

  @override
  FastCustomFieldState createState() => FastCustomFieldState();
}

class FastCustomFieldState extends FastFormFieldState<Map<String, bool>> {
  bool _active = false;
  late Map<String, bool> _activeValue;

  bool get active => _active;

  Map<String, bool> get activeValue => _activeValue;

  set active(bool value) {
    setState(() => _active = value);
  }

  Map<String, bool> get initialActiveValue {
    return widget.initialValue ??
        widget.options.fold({}, (value, option) {
          value[option.name] = false;
          return value;
        });
  }

  @override
  FastCustomField get widget => super.widget as FastCustomField;

  @override
  void initState() {
    super.initState();
    _activeValue = initialActiveValue;
  }

  @override
  void didChange(Map<String, bool>? value) {
    super.didChange(value);
    if (value != null) _activeValue = value;
  }

  @override
  void reset() {
    super.reset();
    active = false;
    _activeValue = initialActiveValue;
  }
}

Widget _customFormFieldActiveBuilder(FastCustomFieldState field) {
  return Column(
    children: <Widget>[
      const Divider(
        height: 4.0,
        color: Colors.black,
      ),
      for (final option in field.widget.options)
        CheckboxListTile(
          title: Text(option.label),
          value: field.activeValue[option.name],
          onChanged: (bool? checked) {
            field.didChange({
              ...field.activeValue,
              option.name: checked ?? false,
            });
          },
        ),
    ],
  );
}

Widget _customFormFieldBuilder(FormFieldState<Map<String, bool>> field) {
  final widget = (field as FastCustomFieldState).widget;

  return InputDecorator(
    decoration: field.decoration,
    child: Column(
      children: <Widget>[
        SwitchListTile(
          contentPadding: const EdgeInsets.all(0),
          title: widget.title,
          value: field.active,
          onChanged: (bool? active) {
            field.active = active ?? false;
            field.didChange(field.active ? field.activeValue : null);
          },
        ),
        if (field.active) _customFormFieldActiveBuilder(field),
      ],
    ),
  );
}
