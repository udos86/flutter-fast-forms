import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    Key key,
    String label,
    DateTime lastDate,
    this.onChanged,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    DateTime value,
  })  : assert(decoration != null),
        this.dateFormat = format ?? DateFormat.yMMMMEEEEd(),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final state = field as DatePickerFormFieldState;
            final theme = Theme.of(state.context);
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(theme.inputDecorationTheme);
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
                    child: TextFormField(
                      controller: state.controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      focusNode: state.focusNode,
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
          },
          initialValue: value,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final DateFormat dateFormat;
  final ValueChanged<DateTime> onChanged;

  @override
  FormFieldState<DateTime> createState() => DatePickerFormFieldState();
}

class DatePickerFormFieldState extends FormFieldState<DateTime> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = writeValue(value);
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
    controller.text = writeValue(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }

  String writeValue(DateTime value) {
    return value != null ? widget.dateFormat.format(value) : '';
  }
}
