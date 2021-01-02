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
        lastDate: DateTime.now().add(Duration(days: 365)),
      ),
    ));

    final fastDatePickerFinder = find.byType(FastDatePicker);
    final inkWellFinder = find.byType(InkWell);
    final iconButtonFinder = find.byType(IconButton);

    expect(fastDatePickerFinder, findsOneWidget);
    expect(inkWellFinder.first, findsOneWidget);
    expect(iconButtonFinder, findsOneWidget);
  });

  testWidgets('shows CalendarDatePicker on IconButton tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDatePicker(
        id: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(Duration(days: 365)),
      ),
    ));

    await tester.tap(find.byType(IconButton));
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
        lastDate: DateTime.now().add(Duration(days: 365)),
      ),
    ));

    await tester.tap(find.byType(InkWell).first);
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
        lastDate: DateTime.now().add(Duration(days: 365)),
      ),
    ));

    final state =
        tester.state(find.byType(FastDatePicker)) as FastDatePickerState;

    expect(state.value, state.widget.initialValue);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    final datePickerText = datePickerTextBuilder(state);
    final datePickerTextFinder = find.text(datePickerText.data!);

    expect(datePickerTextFinder, findsOneWidget);
  });

  testWidgets('validates FastDatePicker', (WidgetTester tester) async {
    final invalidDate = DateTime(1974);
    final errorText = 'invalid date';

    await tester.pumpWidget(getFastTestWidget(
      FastDatePicker(
        id: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(Duration(days: 365)),
        validator: (value) =>
            value?.year == invalidDate.year ? errorText : null,
      ),
    ));

    final state =
        tester.state(find.byType(FastDatePicker)) as FastDatePickerState;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(invalidDate);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
