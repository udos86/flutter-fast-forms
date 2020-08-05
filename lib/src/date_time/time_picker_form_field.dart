import 'package:flutter/material.dart';

class TimePickerFormField extends FormField<TimeOfDay> {
  TimePickerFormField({
    InputDecoration decoration = const InputDecoration(),
    Widget hint,
    Key key,
    String label,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    TimeOfDay value,
    this.onChanged,
  })  : assert(decoration != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value,
          validator: validator,
          builder: (_field) {
            final field = _field as _TimePickerFormFieldState;
            final theme = Theme.of(field.context);
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(theme.inputDecorationTheme);
            final _showTimePicker = () {
              showTimePicker(
                context: field.context,
                initialTime: field.value ?? TimeOfDay.now(),
              ).then((value) => field.didChange(value));
            };
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: field.controller,
                      readOnly: true,
                      textAlign: TextAlign.right,
                      onTap: _showTimePicker,
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: Icon(Icons.schedule),
                    onPressed: _showTimePicker,
                  ),
                ],
              ),
            );
          },
        );

  final ValueChanged<TimeOfDay> onChanged;

  @override
  FormFieldState<TimeOfDay> createState() => _TimePickerFormFieldState();
}

class _TimePickerFormFieldState extends FormFieldState<TimeOfDay> {
  final controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.text = value?.format(context) ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  TimePickerFormField get widget => super.widget;

  @override
  void didChange(TimeOfDay value) {
    super.didChange(value);
    controller.text = value?.format(context) ?? '';
    if (widget.onChanged != null) widget.onChanged(value);
  }
}
