import 'package:flutter/material.dart';

class TimePickerFormField extends FormField<TimeOfDay> {
  TimePickerFormField({
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    Key key,
    String label,
    this.onChanged,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    TimeOfDay value,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final state = field as TimePickerFormFieldState;
            final theme = Theme.of(state.context);
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(theme.inputDecorationTheme);
            final _showTimePicker = () {
              showTimePicker(
                context: state.context,
                initialTime: state.value ?? TimeOfDay.now(),
              ).then((value) {
                if (value != null) state.didChange(value);
              });
            };
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: state.errorText,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: state.controller,
                      readOnly: true,
                      textAlign: TextAlign.left,
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
          initialValue: value,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged<TimeOfDay> onChanged;

  @override
  FormFieldState<TimeOfDay> createState() => TimePickerFormFieldState();
}

class TimePickerFormFieldState extends FormFieldState<TimeOfDay> {
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
