import 'package:flutter/cupertino.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<String> values;
  late FastSegmentedControl widget;

  setUp(() {
    values = const ['value1', 'value2', 'value3'];
    widget = FastSegmentedControl<String>(
      name: 'segmented_control',
      children: {for (final item in values) item: Text(item)},
    );
  });

  testWidgets('renders FastSegmentedControl', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(widget));

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
    expect(segmentedButtonFinder, findsNWidgets(values.length));
  });

  testWidgets('updates FastSegmentedControl', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(widget));

    final state =
        tester.state(find.byType(typeOf<FastSegmentedControl<String>>()))
            as FastSegmentedControlState;

    expect(state.value, widget.initialValue);

    final segmentedButtonFinder = find.descendant(
      of: find.byType(typeOf<CupertinoSlidingSegmentedControl<String>>()),
      matching: find.byType(Text),
    );

    await tester.tap(segmentedButtonFinder.last);
    await tester.pumpAndSettle();

    expect(state.value, values.last);
  });
}
