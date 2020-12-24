import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';

typedef TimePickerTextBuilder = Text Function(
    BuildContext context, TimeOfDay value);

class FastTimePicker extends FastFormField<TimeOfDay> {
  FastTimePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<TimeOfDay> builder,
    InputDecoration decoration,
    bool enabled = true,
    String helper,
    Icon icon,
    @required String id,
    TimeOfDay initialValue,
    Key key,
    String label,
    ValueChanged<TimeOfDay> onChanged,
    VoidCallback onReset,
    FormFieldSetter<TimeOfDay> onSaved,
    TimePickerTextBuilder textBuilder,
    FormFieldValidator<TimeOfDay> validator,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastTimePickerState;
                final theme = Theme.of(state.context);
                final formTheme = FastFormTheme.of(state.context);
                final _decoration = decoration ??
                    formTheme.getInputDecoration(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
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
          helper: helper,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  @override
  FastTimePickerState createState() => FastTimePickerState();
}

class FastTimePickerState extends FastFormFieldState<TimeOfDay> {
  @override
  FastTimePicker get widget => super.widget as FastTimePicker;
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
