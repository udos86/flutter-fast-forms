import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  Widget getTestWidget() {
    return Utils.wrapMaterial(
      FastDatePicker(
        id: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime(2999),
      ),
    );
  }

  testWidgets('finds a CalendarDatePicker on Icon Button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(getTestWidget());

    final iconButtonFinder = find.byType(IconButton);

    expect(iconButtonFinder, findsOneWidget);

    await tester.tap(iconButtonFinder);
    await tester.pumpAndSettle();

    final calendarDatePickerFinder = find.byType(CalendarDatePicker);
    expect(calendarDatePickerFinder, findsOneWidget);
  });

  testWidgets('finds a CalendarDatePicker on GestureDetector tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(getTestWidget());

    final gestureDetectorFinder = find.byType(GestureDetector);

    expect(gestureDetectorFinder.first, findsOneWidget);

    await tester.tap(gestureDetectorFinder.first);
    await tester.pumpAndSettle();

    final inputDatePickerFormFieldFinder =
        find.byType(InputDatePickerFormField);
    expect(inputDatePickerFormFieldFinder, findsOneWidget);
  });
}
