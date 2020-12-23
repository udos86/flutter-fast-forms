import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastSlider widget', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastSlider(
        id: 'slider',
        min: 0,
        max: 10,
        labelBuilder: sliderLabelBuilder,
        prefixBuilder: (context, state) => Icon(Icons.volume_up),
        suffixBuilder: sliderSuffixBuilder,
      ),
    ));

    final fastSliderFinder = find.byType(FastSlider);
    final sliderFinder = find.byType(Slider);

    expect(fastSliderFinder, findsOneWidget);
    expect(sliderFinder, findsOneWidget);

    final widget = tester.widget(fastSliderFinder) as FastSlider;

    final prefixFinder = find.byIcon(Icons.volume_up);
    final suffixFinder = find.text(widget.initialValue.toStringAsFixed(0));

    expect(prefixFinder, findsOneWidget);
    expect(suffixFinder, findsOneWidget);
  });
}
