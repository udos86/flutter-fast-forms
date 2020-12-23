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

    await tester.tap(iconButtonFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('updates FastTimePicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTimePicker(
        id: 'time_picker',
      ),
    ));

    final fastTimePickerFinder = find.byType(FastTimePicker);
    final widget = tester.widget(fastTimePickerFinder) as FastTimePicker;
    final state = tester.state(fastTimePickerFinder) as FastTimePickerState;

    expect(state.value, widget.initialValue);

    final testValue = TimeOfDay.now();

    state.didChange(testValue);
    await tester.pumpAndSettle();

    final timePickerText = timePickerTextBuilder(state.context, testValue);
    final timePickerTextFinder = find.text(timePickerText.data);

    expect(timePickerTextFinder, findsOneWidget);
  });
}
