import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastRangeSlider', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastRangeSlider(
        id: 'range_slider',
        max: 10,
        min: 0,
        labelsBuilder: rangeSliderLabelsBuilder,
        prefixBuilder: rangeSliderPrefixBuilder,
        suffixBuilder: rangeSliderSuffixBuilder,
      ),
    ));

    final fastRangeSliderFinder = find.byType(FastRangeSlider);
    final rangeSliderFinder = find.byType(RangeSlider);

    expect(fastRangeSliderFinder, findsOneWidget);
    expect(rangeSliderFinder, findsOneWidget);

    final widget = tester.widget(fastRangeSliderFinder) as FastRangeSlider;

    final prefixFinder =
        find.text(widget.initialValue!.start.toStringAsFixed(0));
    final suffixFinder = find.text(widget.initialValue!.end.toStringAsFixed(0));

    expect(prefixFinder, findsOneWidget);
    expect(suffixFinder, findsOneWidget);
  });

  testWidgets('updates FastRangeSlider', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastRangeSlider(
        id: 'range_slider',
        max: 10,
        min: 0,
        prefixBuilder: rangeSliderPrefixBuilder,
        suffixBuilder: rangeSliderSuffixBuilder,
      ),
    ));

    final state =
        tester.state(find.byType(FastRangeSlider)) as FastRangeSliderState;

    const testValues = RangeValues(5, 7);
    state.didChange(testValues);
    await tester.pumpAndSettle();

    final prefixFinder = find.text(testValues.start.toStringAsFixed(0));
    final suffixFinder = find.text(testValues.end.toStringAsFixed(0));

    expect(prefixFinder, findsOneWidget);
    expect(suffixFinder, findsOneWidget);
  });

  testWidgets('validates FastRangeSlider', (WidgetTester tester) async {
    const errorText = 'Range is too narrow';

    await tester.pumpWidget(getFastTestWidget(
      FastRangeSlider(
        id: 'range_slider',
        max: 10,
        min: 0,
        validator: (values) =>
            values!.end - values.start <= 1 ? errorText : null,
      ),
    ));

    final state =
        tester.state(find.byType(FastRangeSlider)) as FastRangeSliderState;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(const RangeValues(8, 9));
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
