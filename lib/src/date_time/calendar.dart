import 'package:flutter/material.dart';

import '../form.dart';

/// A [FastFormField] that contains a [CalendarDatePicker].
@immutable
class FastCalendar extends FastFormField<DateTime> {
  const FastCalendar({
    super.autovalidateMode,
    super.builder = calendarBuilder,
    super.contentPadding,
    super.decoration,
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
  }) : super(enabled: true);

  final DateTime? currentDate;
  final DateTime firstDate;
  final DatePickerMode initialCalendarMode;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  FastCalendarState createState() => FastCalendarState();
}

/// State associated with a [FastCalendar] widget.
class FastCalendarState extends FastFormFieldState<DateTime> {
  @override
  FastCalendar get widget => super.widget as FastCalendar;
}

/// A [FormFieldBuilder] that is the default [FastCalendar.builder].
///
/// Returns an [InputDecorator] that contains a [CalendarDatePicker] on any
/// [TargetPlatform].
Widget calendarBuilder(FormFieldState<DateTime> field) {
  final FastCalendarState(:decoration, :didChange, :value, :widget) =
      field as FastCalendarState;

  return InputDecorator(
    decoration: decoration,
    child: CalendarDatePicker(
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      initialCalendarMode: widget.initialCalendarMode,
      initialDate: value ?? DateTime.now(),
      lastDate: widget.lastDate,
      onDateChanged: didChange,
      onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
      selectableDayPredicate: widget.selectableDayPredicate,
    ),
  );
}
