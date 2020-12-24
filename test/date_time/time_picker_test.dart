import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastTimePicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTimePicker(
        id: 'time_picker',
      ),
    ));

    final fastTimePickerFinder = find.byType(FastTimePicker);
    final gestureDetectorFinder = find.byType(GestureDetector);
    final iconButtonFinder = find.byType(IconButton);

    expect(fastTimePickerFinder, findsOneWidget);
    expect(gestureDetectorFinder.first, findsOneWidget);
    expect(iconButtonFinder, findsOneWidget);
  });

  testWidgets('updates FastTimePicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTimePicker(
        id: 'time_picker',
      ),
    ));

    final state =
        tester.state(find.byType(FastTimePicker)) as FastTimePickerState;

    expect(state.value, state.widget.initialValue);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    final timePickerText = timePickerTextBuilder(state.context, state.value);
    final timePickerTextFinder = find.text(timePickerText.data);

    expect(timePickerTextFinder, findsOneWidget);
  });
}
