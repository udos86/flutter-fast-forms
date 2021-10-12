import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDateRangerPicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDateRangePicker(
        id: 'date_range_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    final fastDateRangePickerFinder = find.byType(FastDateRangePicker);
    final inkWellFinder = find.byType(InkWell);
    final iconButtonFinder = find.byType(IconButton);

    expect(fastDateRangePickerFinder, findsOneWidget);
    expect(inkWellFinder.first, findsOneWidget);
    expect(iconButtonFinder, findsOneWidget);

    await tester.tap(inkWellFinder.first);
    await tester.pumpAndSettle();
  });

  testWidgets('updates FastDateRangerPicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDateRangePicker(
        id: 'date_range_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    final state = tester.state(find.byType(FastDateRangePicker))
        as FastDateRangePickerState;

    expect(state.value, state.widget.initialValue);

    state.didChange(DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 1)),
    ));
    await tester.pumpAndSettle();

    final dateRangePickerText = dateRangPickerTextBuilder(state);
    final dateRangePickerTextFinder = find.text(dateRangePickerText.data!);

    expect(dateRangePickerTextFinder, findsOneWidget);
  });
}
