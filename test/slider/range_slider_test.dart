import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('FastRangeSlider', (WidgetTester tester) async {
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
        find.text(widget.initialValue.start.toStringAsFixed(0));
    final suffixFinder = find.text(widget.initialValue.end.toStringAsFixed(0));

    expect(prefixFinder, findsOneWidget);
    expect(suffixFinder, findsOneWidget);
  });
}
