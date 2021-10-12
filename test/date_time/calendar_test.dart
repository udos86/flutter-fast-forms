import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastCalendar', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastCalendar(
        id: 'calendar',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    final fastCalendarFinder = find.byType(FastCalendar);
    final calendarDatePickerFinder = find.byType(CalendarDatePicker);

    expect(fastCalendarFinder, findsOneWidget);
    expect(calendarDatePickerFinder, findsOneWidget);
  });

  testWidgets('updates FastCalendar', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastCalendar(
        id: 'calendar',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    final state = tester.state(find.byType(FastCalendar)) as FastCalendarState;

    expect(state.value, state.widget.initialValue);

    const testValue = 21;

    await tester.tap(find.text(testValue.toString()));
    await tester.pumpAndSettle();

    expect(state.value?.day, testValue);
  });

  testWidgets('validates FastCalendar', (WidgetTester tester) async {
    const invalidValue = 21;
    const errorText = 'Invalid day';

    await tester.pumpWidget(getFastTestWidget(
      FastCalendar(
        id: 'calendar',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        validator: (value) => value?.day == invalidValue ? errorText : null,
      ),
    ));

    final state = tester.state(find.byType(FastCalendar)) as FastCalendarState;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(DateTime(2020, 12, invalidValue));
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
