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
    String? label,
    required String name,
    ValueChanged<Map<String, bool>>? onChanged,
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
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final List<FastCustomOption> options;
  final Widget? title;

  @override
  FormFieldState<Map<String, bool>> createState() => FastCustomFieldState();
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

Widget _customFormFieldActiveBuilder(FastCustomFieldState state) {
  return Column(
    children: <Widget>[
      const Divider(
        height: 4.0,
        color: Colors.black,
      ),
      for (final option in state.widget.options)
        CheckboxListTile(
          title: Text(option.label),
          value: state.activeValue[option.name],
          onChanged: (bool? checked) {
            state.didChange({
              ...state.activeValue,
              option.name: checked ?? false,
            });
          },
        ),
    ],
  );
}

Widget _customFormFieldBuilder(FormFieldState<Map<String, bool>> field) {
  final state = field as FastCustomFieldState;
  final widget = state.widget;

  return InputDecorator(
    decoration: state.decoration.copyWith(errorText: state.errorText),
    child: Column(
      children: <Widget>[
        SwitchListTile(
          contentPadding: const EdgeInsets.all(0),
          title: widget.title,
          value: state.active,
          onChanged: (bool? active) {
            state.active = active ?? false;
            state.didChange(state.active ? state.activeValue : null);
          },
        ),
        if (state.active) _customFormFieldActiveBuilder(state),
      ],
    ),
  );
}
