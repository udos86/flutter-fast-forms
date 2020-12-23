import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastSlider', (WidgetTester tester) async {
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

  testWidgets('updates FastSlider', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastSlider(
        id: 'slider',
        min: 0,
        max: 10,
        suffixBuilder: sliderSuffixBuilder,
      ),
    ));

    final fastSliderFinder = find.byType(FastSlider);
    final widget = tester.widget(fastSliderFinder) as FastSlider;
    final state = tester.state(fastSliderFinder) as FastSliderState;

    state.didChange(widget.max);
    await tester.pumpAndSettle();

    final suffixFinder = find.text(widget.max.toStringAsFixed(0));

    expect(suffixFinder, findsOneWidget);
  });

  testWidgets('validates FastSlider', (WidgetTester tester) async {
    final errorText = 'Value is too high';

    await tester.pumpWidget(getFastTestWidget(
      FastSlider(
        id: 'slider',
        min: 0,
        max: 10,
        validator: (value) => value > 0 ? errorText : null,
      ),
    ));

    final fastSliderFinder = find.byType(FastSlider);
    final widget = tester.widget(fastSliderFinder) as FastSlider;
    final state = tester.state(fastSliderFinder) as FastSliderState;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(widget.max);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
