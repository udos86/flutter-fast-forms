import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDatePicker', (WidgetTester tester) async {
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

  testWidgets('updates FastDatePicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDatePicker(
        id: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now()..add(Duration(days: 365)),
      ),
    ));

    final fastDatePickerFinder = find.byType(FastDatePicker);
    final widget = tester.widget(fastDatePickerFinder) as FastDatePicker;
    final state = tester.state(fastDatePickerFinder) as FastDatePickerState;

    expect(state.value, widget.initialValue);

    final testValue = DateTime.now();

    state.didChange(testValue);
    await tester.pumpAndSettle();

    final datePickerText =
        datePickerTextBuilder(state.context, testValue, widget.dateFormat);
    final datePickerTextFinder = find.text(datePickerText.data);

    expect(datePickerTextFinder, findsOneWidget);
  });
}
