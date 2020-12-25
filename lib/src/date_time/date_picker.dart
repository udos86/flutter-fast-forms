import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_theme.dart';

typedef DatePickerTextBuilder = Text Function(FastDatePickerState state);

class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTime> builder,
    String cancelText,
    String confirmText,
    InputDecoration decoration,
    bool enabled = true,
    String errorFormatText,
    String errorInvalidText,
    String fieldHintText,
    String fieldLabelText,
    @required DateTime firstDate,
    DateFormat format,
    String helper,
    String helpText,
    Icon icon,
    @required String id,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DateTime initialValue,
    Key key,
    String label,
    @required DateTime lastDate,
    ValueChanged<DateTime> onChanged,
    VoidCallback onReset,
    FormFieldSetter<DateTime> onSaved,
    DatePickerTextBuilder textBuilder,
    FormFieldValidator<DateTime> validator,
  })  : this.dateFormat = format ?? DateFormat.yMMMMEEEEd(),
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastDatePickerState;
                final theme = Theme.of(state.context);
                final formTheme = FastFormTheme.of(state.context);
                final _decoration = decoration ??
                    formTheme.getInputDecoration(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
                final _textBuilder = textBuilder ?? datePickerTextBuilder;
                final _showDatePicker = (DatePickerEntryMode entryMode) {
                  showDatePicker(
                    cancelText: cancelText,
                    confirmText: confirmText,
                    context: state.context,
                    errorFormatText: errorFormatText,
                    errorInvalidText: errorInvalidText,
                    fieldHintText: fieldHintText,
                    fieldLabelText: fieldLabelText,
                    helpText: helpText,
                    initialDatePickerMode: initialDatePickerMode,
                    initialEntryMode: entryMode,
                    initialDate: state.value ?? DateTime.now(),
                    firstDate: firstDate,
                    lastDate: lastDate,
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
                          onTap: enabled
                              ? () => _showDatePicker(DatePickerEntryMode.input)
                              : null,
                          child: _textBuilder(state),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.centerRight,
                        icon: icon ?? Icon(Icons.today),
                        onPressed: enabled
                            ? () => _showDatePicker(initialEntryMode)
                            : null,
                      ),
                    ],
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

  final DateFormat dateFormat;

  @override
  FastDatePickerState createState() => FastDatePickerState();
}

class FastDatePickerState extends FastFormFieldState<DateTime> {
  @override
  FastDatePicker get widget => super.widget as FastDatePicker;
}

final DatePickerTextBuilder datePickerTextBuilder =
    (FastDatePickerState state) {
  final theme = Theme.of(state.context);
  final format = state.widget.dateFormat.format;
  final value = state.value;

  return Text(
    value != null ? format(state.value) : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
};
