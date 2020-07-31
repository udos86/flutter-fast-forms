import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    InputDecoration decoration = const InputDecoration(),
    DateTime firstDate,
    DateFormat format,
    Widget hint,
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
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: field.controller,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {
                              showDatePicker(
                                context: field.context,
                                initialDate: field.value ?? DateTime.now(),
                                firstDate: firstDate,
                                lastDate: lastDate,
                              ).then((value) => field.didChange(value));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });

  final DateFormat dateFormat;
  final ValueChanged onChanged;

  @override
  FormFieldState<DateTime> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = value != null ? widget.dateFormat.format(value) : null;
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
    controller.text = widget.dateFormat.format(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }
}
