import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form_field.dart';
import '../form_theme.dart';

typedef TimePickerTextBuilder = Text Function(FastTimePickerState state);

typedef ShowTimePicker = void Function();

typedef TimePickerIconButtonBuilder = IconButton Function(
    FastTimePickerState state, ShowTimePicker show);

@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  FastTimePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<TimeOfDay> builder,
    InputDecoration decoration,
    bool enabled = true,
    String helper,
    this.icon,
    TimePickerIconButtonBuilder iconButtonBuilder,
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
                final _iconButtonBuilder =
                    iconButtonBuilder ?? timePickerIconButtonBuilder;
                final _showTimePicker = () {
                  showTimePicker(
                    context: state.context,
                    initialTime: state.value ?? TimeOfDay.now(),
                  ).then((value) {
                    if (value != null) state.didChange(value);
                  });
                };
                return InkWell(
                  onTap: enabled ? () => _showTimePicker() : null,
                  child: InputDecorator(
                    decoration: effectiveDecoration.copyWith(
                      errorText: state.errorText,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: _textBuilder(state),
                        ),
                        _iconButtonBuilder(state, _showTimePicker),
                      ],
                    ),
                  ),
                );
              },
          decoration: decoration,
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

  final Icon icon;

  @override
  FastTimePickerState createState() => FastTimePickerState();
}

class FastTimePickerState extends FastFormFieldState<TimeOfDay> {
  @override
  FastTimePicker get widget => super.widget as FastTimePicker;
}

final TimePickerTextBuilder timePickerTextBuilder =
    (FastTimePickerState state) {
  final theme = Theme.of(state.context);

  return Text(
    state.value?.format(state.context) ?? '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
};

final TimePickerIconButtonBuilder timePickerIconButtonBuilder =
    (FastTimePickerState state, ShowTimePicker show) {
  final widget = state.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? Icon(Icons.schedule),
    onPressed: widget.enabled ? show : null,
  );
};
