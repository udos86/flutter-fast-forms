import 'package:flutter/material.dart';

import '../form_field.dart';

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
    String? label,
    required String name,
    ValueChanged<DateTime>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
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
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

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
  final state = field as FastCalendarState;
  final widget = state.widget;

  return InputDecorator(
    decoration: state.decoration.copyWith(errorText: state.errorText),
    child: CalendarDatePicker(
      firstDate: widget.firstDate,
      initialCalendarMode: widget.initialCalendarMode,
      initialDate: state.value ?? DateTime.now(),
      lastDate: widget.lastDate,
      onDateChanged: state.didChange,
      selectableDayPredicate: widget.selectableDayPredicate,
    ),
  );
}
