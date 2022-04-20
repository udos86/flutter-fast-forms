import 'package:flutter/material.dart';

import '../form.dart';

@immutable
class FastCalendar extends FastFormField<DateTime> {
  const FastCalendar({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTime>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    DateTime? initialValue,
    Key? key,
    String? labelText,
    required String name,
    ValueChanged<DateTime?>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    this.currentDate,
    required this.firstDate,
    this.initialCalendarMode = DatePickerMode.day,
    required this.lastDate,
    this.selectableDayPredicate,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? calendarBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          labelText: labelText,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final DateTime? currentDate;
  final DateTime firstDate;
  final DatePickerMode initialCalendarMode;
  final DateTime lastDate;
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  FastCalendarState createState() => FastCalendarState();
}

class FastCalendarState extends FastFormFieldState<DateTime> {
  @override
  FastCalendar get widget => super.widget as FastCalendar;
}

InputDecorator calendarBuilder(FormFieldState<DateTime> field) {
  final widget = (field as FastCalendarState).widget;

  return InputDecorator(
    decoration: field.decoration,
    child: CalendarDatePicker(
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      initialCalendarMode: widget.initialCalendarMode,
      initialDate: field.value ?? DateTime.now(),
      lastDate: widget.lastDate,
      onDateChanged: field.didChange,
      selectableDayPredicate: widget.selectableDayPredicate,
    ),
  );
}
