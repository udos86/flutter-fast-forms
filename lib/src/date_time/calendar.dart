import 'package:flutter/material.dart';

import '../form.dart';

@immutable
class FastCalendar extends FastFormField<DateTime> {
  const FastCalendar({
    super.autovalidateMode,
    super.builder = calendarBuilder,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.currentDate,
    required this.firstDate,
    this.initialCalendarMode = DatePickerMode.day,
    required this.lastDate,
    this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
  });

  final DateTime? currentDate;
  final DateTime firstDate;
  final DatePickerMode initialCalendarMode;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  FastCalendarState createState() => FastCalendarState();
}

class FastCalendarState extends FastFormFieldState<DateTime> {
  @override
  FastCalendar get widget => super.widget as FastCalendar;
}

Widget calendarBuilder(FormFieldState<DateTime> field) {
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
      onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
      selectableDayPredicate: widget.selectableDayPredicate,
    ),
  );
}
