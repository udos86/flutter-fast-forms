import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastSlider', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastSlider(
      name: 'slider',
      labelBuilder: sliderLabelBuilder,
      prefixBuilder: (state) => const Icon(Icons.volume_up),
      suffixBuilder: sliderSuffixBuilder,
    )));

    final fastSliderFinder = findFastSlider();

    expect(fastSliderFinder, findsOneWidget);
    expect(findInputDecorator(), findsOneWidget);
    expect(findSlider(), findsOneWidget);

    final widget = tester.widget<FastSlider>(fastSliderFinder);

    final prefixFinder = find.byIcon(Icons.volume_up);
    final suffixFinder = find.text(widget.initialValue!.toStringAsFixed(0));

    expect(prefixFinder, findsOneWidget);
    expect(suffixFinder, findsOneWidget);
  });

  testWidgets('renders FastSlider without InputDecoration', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(const FastSlider(
      name: 'slider',
      showInputDecoration: false,
    )));

    expect(findFastSlider(), findsOneWidget);
    expect(findInputDecorator(), findsNothing);
    expect(findSlider(), findsOneWidget);
  });

  testWidgets('renders Cupertino FastSlider', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastSlider(
      name: 'slider',
      builder: cupertinoSliderBuilder,
      labelBuilder: sliderLabelBuilder,
      prefixBuilder: (state) => const Icon(Icons.volume_up),
      suffixBuilder: sliderSuffixBuilder,
    )));

    final fastSliderFinder = findFastSlider();
    final sliderFinder = findCupertinoSlider();

    expect(fastSliderFinder, findsOneWidget);
    expect(sliderFinder, findsOneWidget);

    final widget = tester.widget<FastSlider>(fastSliderFinder);

    final prefixFinder = find.byIcon(Icons.volume_up);
    final suffixFinder = find.text(widget.initialValue!.toStringAsFixed(0));

    expect(prefixFinder, findsOneWidget);
    expect(suffixFinder, findsOneWidget);
  });

  testWidgets('updates FastSlider', (tester) async {
    final spy = OnChangedSpy<double>();

    await tester.pumpWidget(buildMaterialTestApp(FastSlider(
      name: 'slider',
      suffixBuilder: sliderSuffixBuilder,
      onChanged: spy.fn,
    )));

    final state = tester.state<FastSliderState>(findFastSlider());
    final testValue = state.widget.max;

    state.didChange(testValue);
    await tester.pumpAndSettle();

    expect(spy.calledWith, testValue);
    expect(find.text(testValue.toStringAsFixed(0)), findsOneWidget);
  });

  testWidgets('validates FastSlider', (tester) async {
    const errorText = 'Value is too high';

    await tester.pumpWidget(buildMaterialTestApp(FastSlider(
      name: 'slider',
      validator: (value) => value! > 0 ? errorText : null,
    )));

    final state = tester.state<FastSliderState>(findFastSlider());

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(state.widget.max);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('adapts FastSlider to Android', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(buildMaterialTestApp(const FastSlider(
      name: 'slider',
      adaptive: true,
    )));

    expect(findSlider(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('adapts FastSlider to iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildMaterialTestApp(const FastSlider(
      name: 'slider',
      adaptive: true,
    )));

    expect(findCupertinoFormRow(), findsOneWidget);
    expect(findCupertinoSlider(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
