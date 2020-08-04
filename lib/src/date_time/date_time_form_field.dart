import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    InputDecoration decoration = const InputDecoration(),
    DateTime firstDate,
    DateFormat format,
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
        this.dateFormat = format ?? DateFormat.yMMMd(),
        super(
            key: key,
            onSaved: onSaved,
            initialValue: value,
            validator: validator,
            builder: (_field) {
              final field = _field as _DateTimeFormFieldState;
              final InputDecoration effectiveDecoration = decoration
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              return InputDecorator(
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: field.controller,
                        decoration: InputDecoration(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        showDatePicker(
                          context: field.context,
                          initialDatePickerMode: initialDatePickerMode,
                          initialEntryMode: initialEntryMode,
                          initialDate: field.value ?? DateTime.now(),
                          firstDate: firstDate,
                          lastDate: lastDate,
                        ).then((value) => field.didChange(value));
                      },
                    ),
                  ],
                ),
              );
            });

  final DateFormat dateFormat;
  final ValueChanged<DateTime> onChanged;

  @override
  FormFieldState<DateTime> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = _formatValue(value);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  DateTimeFormField get widget => super.widget;

  @override
  void didChange(DateTime value) {
    super.didChange(value);
    controller.text = _formatValue(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }

  String _formatValue(DateTime value) {
    return value != null ? widget.dateFormat.format(value) : null;
  }
}
