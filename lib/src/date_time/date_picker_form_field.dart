import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DatePickerTextBuilder = Text Function(
    BuildContext context, DateTime value, DateFormat format);

class DatePickerFormField extends FormField<DateTime> {
  DatePickerFormField({
    bool autovalidate,
    String cancelText,
    String confirmText,
    InputDecoration decoration = const InputDecoration(),
    String errorFormatText,
    String errorInvalidText,
    String fieldHintText,
    String fieldLabelText,
    DateTime firstDate,
    DateFormat format,
    String helpText,
    Icon icon,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DateTime initialValue,
    Key key,
    String label,
    DateTime lastDate,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    DatePickerTextBuilder textBuilder,
    FormFieldValidator validator,
  })  : assert(decoration != null),
        this.dateFormat = format ?? DateFormat.yMMMMEEEEd(),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final state = field as DatePickerFormFieldState;
            final theme = Theme.of(state.context);
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(theme.inputDecorationTheme);
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
                      onTap: () => _showDatePicker(DatePickerEntryMode.input),
                      child: _textBuilder(
                          state.context, state.value, state.widget.dateFormat),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: icon ?? Icon(Icons.today),
                    onPressed: () => _showDatePicker(initialEntryMode),
                  ),
                ],
              ),
            );
          },
          initialValue: initialValue,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final DateFormat dateFormat;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<DateTime> createState() => DatePickerFormFieldState();
}

class DatePickerFormFieldState extends FormFieldState<DateTime> {
  @override
  DatePickerFormField get widget => super.widget as DatePickerFormField;

  @override
  void didChange(DateTime value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
  }
}

final DatePickerTextBuilder datePickerTextBuilder =
    (BuildContext context, DateTime value, DateFormat dateFormat) {
  final theme = Theme.of(context);
  return Text(
    value != null ? dateFormat.format(value) : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
};
