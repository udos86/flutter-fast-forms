import 'package:flutter/material.dart';

typedef TimePickerTextBuilder = Text Function(
    BuildContext context, TimeOfDay value);

class TimePickerFormField extends FormField<TimeOfDay> {
  TimePickerFormField({
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    bool enabled = true,
    Icon icon,
    TimeOfDay initialValue,
    Key key,
    String label,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    TimePickerTextBuilder textBuilder,
    FormFieldValidator validator,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final state = field as TimePickerFormFieldState;
            final theme = Theme.of(state.context);
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(theme.inputDecorationTheme);
            final _textBuilder = textBuilder ?? timePickerTextBuilder;
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
                    child: GestureDetector(
                      onTap: enabled ? () => _showTimePicker() : null,
                      child: _textBuilder(state.context, state.value),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: icon ?? Icon(Icons.schedule),
                    onPressed: enabled ? _showTimePicker : null,
                  ),
                ],
              ),
            );
          },
          enabled: enabled,
          initialValue: initialValue,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged<TimeOfDay> onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<TimeOfDay> createState() => TimePickerFormFieldState();
}

class TimePickerFormFieldState extends FormFieldState<TimeOfDay> {
  @override
  TimePickerFormField get widget => super.widget as TimePickerFormField;

  @override
  void didChange(TimeOfDay value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
  }
}

final TimePickerTextBuilder timePickerTextBuilder =
    (BuildContext context, TimeOfDay value) {
  final theme = Theme.of(context);
  return Text(
    value?.format(context) ?? '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
};
