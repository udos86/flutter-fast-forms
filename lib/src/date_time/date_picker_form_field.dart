import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends FormField<DateTime> {
  DatePickerFormField({
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
    Widget hint,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    Key key,
    String label,
    DateTime lastDate,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    DateTime value,
    this.onChanged,
  })  : assert(decoration != null),
        this.dateFormat = format ?? DateFormat.yMMMMEEEEd(),
        super(
            key: key,
            onSaved: onSaved,
            initialValue: value,
            validator: validator,
            builder: (_field) {
              final field = _field as _DatePickerFormFieldState;
              final theme = Theme.of(field.context);
              final InputDecoration effectiveDecoration =
                  decoration.applyDefaults(theme.inputDecorationTheme);
              final _showDatePicker = (DatePickerEntryMode entryMode) {
                showDatePicker(
                  cancelText: cancelText,
                  confirmText: confirmText,
                  context: field.context,
                  errorFormatText: errorFormatText,
                  errorInvalidText: errorInvalidText,
                  fieldHintText: fieldHintText,
                  fieldLabelText: fieldLabelText,
                  helpText: helpText,
                  initialDatePickerMode: initialDatePickerMode,
                  initialEntryMode: entryMode,
                  initialDate: field.value ?? DateTime.now(),
                  firstDate: firstDate,
                  lastDate: lastDate,
                ).then(field.didChange);
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
                        controller: field.controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        focusNode: field.focusNode,
                        readOnly: true,
                        textAlign: TextAlign.left,
                        onTap: () => _showDatePicker(DatePickerEntryMode.input),
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(Icons.today),
                      onPressed: () => _showDatePicker(initialEntryMode),
                    ),
                  ],
                ),
              );
            });

  final DateFormat dateFormat;
  final ValueChanged<DateTime> onChanged;

  @override
  FormFieldState<DateTime> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends FormFieldState<DateTime> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = formatValue(value);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    focusNode.dispose();
  }

  @override
  DatePickerFormField get widget => super.widget;

  @override
  void didChange(DateTime value) {
    super.didChange(value);
    controller.text = formatValue(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }

  String formatValue(DateTime value) {
    return value != null ? widget.dateFormat.format(value) : null;
  }
}
