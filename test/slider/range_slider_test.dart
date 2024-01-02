import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastRangeSlider', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastRangeSlider(
        name: 'range_slider',
        max: 10,
        min: 0,
        labelsBuilder: rangeSliderLabelsBuilder,
        prefixBuilder: rangeSliderPrefixBuilder,
        suffixBuilder: rangeSliderSuffixBuilder,
      ),
    ]));

    final fastRangeSliderFinder = findFastRangeSlider();

    expect(fastRangeSliderFinder, findsOneWidget);
    expect(findInputDecorator(), findsOneWidget);
    expect(findRangeSlider(), findsOneWidget);

    final widget = tester.widget<FastRangeSlider>(fastRangeSliderFinder);

    final prefixFinder =
        find.text(widget.initialValue!.start.toStringAsFixed(0));
    final suffixFinder = find.text(widget.initialValue!.end.toStringAsFixed(0));

    expect(prefixFinder, findsOneWidget);
    expect(suffixFinder, findsOneWidget);
  });

  testWidgets('renders FastRangeSlider without InputDecorator', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastRangeSlider(
        name: 'range_slider',
        showInputDecoration: false,
      ),
    ]));

    final fastRangeSliderFinder = findFastRangeSlider();

    expect(fastRangeSliderFinder, findsOneWidget);
    expect(findInputDecorator(), findsNothing);
    expect(findRangeSlider(), findsOneWidget);
  });

  testWidgets('updates FastRangeSlider', (tester) async {
    final spy = OnChangedSpy<RangeValues>();

    await tester.pumpWidget(buildMaterialTestApp([
      FastRangeSlider(
        name: 'range_slider',
        max: 10,
        min: 0,
        prefixBuilder: rangeSliderPrefixBuilder,
        suffixBuilder: rangeSliderSuffixBuilder,
        onChanged: spy.fn,
      ),
    ]));

    final state = tester.state<FastRangeSliderState>(findFastRangeSlider());
    const updatedValues = RangeValues(5, 7);

    state.didChange(updatedValues);
    await tester.pumpAndSettle();

    expect(spy.calledWith, updatedValues);
    expect(find.text(updatedValues.start.toStringAsFixed(0)), findsOneWidget);
    expect(find.text(updatedValues.end.toStringAsFixed(0)), findsOneWidget);
  });

  testWidgets('validates FastRangeSlider', (tester) async {
    const errorText = 'Range is too narrow';

    await tester.pumpWidget(buildMaterialTestApp([
      FastRangeSlider(
        name: 'range_slider',
        max: 10,
        min: 0,
        validator: (values) =>
            values!.end - values.start <= 1 ? errorText : null,
      ),
    ]));

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    final state = tester.state<FastRangeSliderState>(findFastRangeSlider());

    state.didChange(const RangeValues(8, 9));
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
