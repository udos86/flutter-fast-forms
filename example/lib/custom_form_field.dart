import 'package:flutter/material.dart';

@immutable
class CustomOption {
  CustomOption({
    @required this.label,
    @required this.id,
  });

  final String label;
  final String id;
}

class CustomFormField extends FormField<Map<String, bool>> {
  CustomFormField({
    InputDecoration decoration = const InputDecoration(),
    Key key,
    String label,
    String placeholder,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    this.options = const [],
    Widget title,
    FormFieldValidator validator,
    Map<String, bool> initialValue,
  })  : assert(decoration != null),
        super(
          builder: (_field) {
            final field = _field as CustomFormFieldState;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
              ),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: title,
                    value: field.active,
                    onChanged: (active) {
                      field.active = active;
                      field.didChange(active ? field.activeValue : null);
                    },
                  ),
                  if (field.active) field.buildActiveSegment(),
                ],
              ),
            );
          },
          initialValue: initialValue,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged onChanged;
  final VoidCallback onReset;
  final List<CustomOption> options;

  @override
  FormFieldState<Map<String, bool>> createState() => CustomFormFieldState();
}

class CustomFormFieldState extends FormFieldState<Map<String, bool>> {
  bool _active = false;
  Map<String, bool> _activeValue;

  bool get active => _active;
  Map<String, bool> get activeValue => _activeValue;

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
  CustomFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    _activeValue = initialActiveValue;
  }

  @override
  void didChange(Map<String, bool> value) {
    super.didChange(value);
    if (value != null) _activeValue = value;
    if (widget.onChanged != null) widget.onChanged(value);
  }

  @override
  void reset() {
    super.reset();
    active = false;
    _activeValue = initialActiveValue;
    widget.onReset?.call();
  }

  Widget buildActiveSegment() {
    return Column(
      children: <Widget>[
        Divider(
          height: 4.0,
          color: Colors.black,
        ),
        for (var option in widget.options)
          CheckboxListTile(
            title: Text(option.label),
            value: _activeValue[option.id],
            onChanged: (bool checked) {
              didChange({..._activeValue, option.id: checked});
            },
          ),
      ],
    );
  }
}
