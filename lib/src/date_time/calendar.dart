import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

@immutable
class FastCalendar extends FastFormField<DateTime> {
  FastCalendar({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTime>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    DateTime? initialValue,
    Key? key,
    String? label,
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
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder =
                    scope?.builders[FastCalendar] ?? calendarBuilder;
                return builder(field);
              },
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
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
  final theme = Theme.of(state.context);
  final decorator = FastFormScope.of(state.context)?.inputDecorator;
  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);

  return InputDecorator(
    decoration: effectiveDecoration.copyWith(
      errorText: state.errorText,
    ),
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
