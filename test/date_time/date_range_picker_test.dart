import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDateRangerPicker', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastDateRangePicker(
        id: 'date_range_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    expect(find.byType(FastDateRangePicker), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);

    final inkWellFinder = find.byType(InkWell);
    expect(inkWellFinder.first, findsOneWidget);

    await tester.tap(inkWellFinder.first);
    await tester.pumpAndSettle();
  });

  testWidgets('updates FastDateRangerPicker', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
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
    expect(find.text(dateRangePickerText.data!), findsOneWidget);
  });
}
