import 'package:flutter/cupertino.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastSegmentedControl', (WidgetTester tester) async {
    final testValues = ['value1', 'value2', 'value3'];

    await tester.pumpWidget(buildMaterialTestApp(
      FastSegmentedControl<String>(
        name: 'segmented_control',
        children: {for (var item in testValues) item: Text(item)},
      ),
    ));

    final fastSegmentedControlFinder =
        find.byType(typeOf<FastSegmentedControl<String>>());
    final segmentedControlFinder =
        find.byType(typeOf<CupertinoSlidingSegmentedControl<String>>());
    final segmentedButtonFinder = find.descendant(
      of: segmentedControlFinder,
      matching: find.byType(Text),
    );

    expect(fastSegmentedControlFinder, findsOneWidget);
    expect(segmentedControlFinder, findsOneWidget);
    expect(segmentedButtonFinder, findsNWidgets(testValues.length));
  });

  testWidgets('updates FastSegmentedControl', (WidgetTester tester) async {
    final testValues = ['value1', 'value2', 'value3'];

    await tester.pumpWidget(buildMaterialTestApp(
      FastSegmentedControl(
        name: 'segmented_control',
        children: {for (var item in testValues) item: Text(item)},
      ),
    ));

    final state =
        tester.state(find.byType(typeOf<FastSegmentedControl<String>>()))
            as FastSegmentedControlState;

    expect(state.value, state.widget.initialValue);

    final segmentedButtonFinder = find.descendant(
      of: find.byType(typeOf<CupertinoSlidingSegmentedControl<String>>()),
      matching: find.byType(Text),
    );

    await tester.tap(segmentedButtonFinder.last);
    await tester.pumpAndSettle();

    expect(state.value, testValues.last);
  });
}
