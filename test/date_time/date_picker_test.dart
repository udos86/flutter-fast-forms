import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDatePicker widget', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDatePicker(
        id: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now()..add(Duration(days: 365)),
      ),
    ));

    final fastDatePickerFinder = find.byType(FastDatePicker);
    final gestureDetectorFinder = find.byType(GestureDetector);
    final iconButtonFinder = find.byType(IconButton);

    expect(fastDatePickerFinder, findsOneWidget);
    expect(gestureDetectorFinder.first, findsOneWidget);
    expect(iconButtonFinder, findsOneWidget);
  });

  testWidgets('shows CalendarDatePicker on IconButton tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDatePicker(
        id: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now()..add(Duration(days: 365)),
      ),
    ));

    final iconButtonFinder = find.byType(IconButton);

    await tester.tap(iconButtonFinder);
    await tester.pumpAndSettle();

    final calendarDatePickerFinder = find.byType(CalendarDatePicker);
    expect(calendarDatePickerFinder, findsOneWidget);
  });

  testWidgets('shows CalendarDatePicker on GestureDetector tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDatePicker(
        id: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now()..add(Duration(days: 365)),
      ),
    ));

    final gestureDetectorFinder = find.byType(GestureDetector);

    await tester.tap(gestureDetectorFinder.first);
    await tester.pumpAndSettle();

    final inputDatePickerFormFieldFinder =
        find.byType(InputDatePickerFormField);
    expect(inputDatePickerFormFieldFinder, findsOneWidget);
  });
}
