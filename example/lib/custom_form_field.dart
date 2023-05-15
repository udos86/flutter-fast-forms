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
    super.builder = customFormFieldBuilder,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.validator,
    required this.options,
    this.title,
  });

  final List<FastCustomOption> options;
  final Widget? title;

  @override
  FastCustomFieldState createState() => FastCustomFieldState();
}

class FastCustomFieldState extends FastFormFieldState<Map<String, bool>> {
  bool _active = false;
  late Map<String, bool> _activeValue;

  bool get active => _active;

  set active(bool value) => setState(() => _active = value);

  Map<String, bool> get activeValue => _activeValue;

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
    children: [
      const Divider(
        height: 4.0,
        color: Colors.black,
      ),
      for (final option in field.widget.options)
        CheckboxListTile(
          title: Text(option.label),
          value: field.activeValue[option.name],
          onChanged: field.enabled
              ? (checked) {
                  field.didChange({
                    ...field.activeValue,
                    option.name: checked ?? false,
                  });
                }
              : null,
        ),
    ],
  );
}

Widget customFormFieldBuilder(FormFieldState<Map<String, bool>> field) {
  final widget = (field as FastCustomFieldState).widget;

  return InputDecorator(
    decoration: field.decoration,
    child: Column(
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.all(0),
          title: widget.title,
          value: field.active,
          onChanged: field.enabled
              ? (active) {
                  field.didChange(active ? field.activeValue : null);
                  field.active = active;
                }
              : null,
        ),
        if (field.active) _customFormFieldActiveBuilder(field),
      ],
    ),
  );
}
