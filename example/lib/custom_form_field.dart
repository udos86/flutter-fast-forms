import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

@immutable
class FastCustomOption {
  const FastCustomOption({required this.id, required this.label});

  final String id;
  final String label;
}

class FastCustomField extends FastFormField<Map<String, bool>> {
  const FastCustomField({
    InputDecoration? decoration,
    String? helperText,
    required String id,
    Map<String, bool>? initialValue,
    Key? key,
    String? label,
    String? placeholder,
    ValueChanged<Map<String, bool>>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<Map<String, bool>>? onSaved,
    FormFieldValidator<Map<String, bool>>? validator,
    required this.options,
    this.title,
  }) : super(
          builder: _customFormFieldBuilder,
          helperText: helperText,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final List<FastCustomOption> options;
  final Widget? title;

  @override
  FormFieldState<Map<String, bool>> createState() => CustomFormFieldState();
}

class CustomFormFieldState extends FastFormFieldState<Map<String, bool>> {
  bool _active = false;
  late Map<String, bool> _activeValue;

  bool get active => _active;

  Map<String, bool>? get activeValue => _activeValue;

  set active(bool value) {
    setState(() {
      _active = value;
    });
  }

  Map<String, bool> get initialActiveValue {
    return widget.initialValue ??
        widget.options.fold({}, (value, option) {
          value[option.id] = false;
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

  Widget buildActive() {
    return Column(
      children: <Widget>[
        const Divider(
          height: 4.0,
          color: Colors.black,
        ),
        for (var option in widget.options)
          CheckboxListTile(
            title: Text(option.label),
            value: _activeValue[option.id],
            onChanged: (bool? checked) {
              didChange({..._activeValue, option.id: checked ?? false});
            },
          ),
      ],
    );
  }
}

Widget _customFormFieldBuilder(FormFieldState<Map<String, bool>> field) {
  final state = field as CustomFormFieldState;
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
        if (state.active) state.buildActive(),
      ],
    ),
  );
}
