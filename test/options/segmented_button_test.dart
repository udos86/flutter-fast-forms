import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

findFastSegmentedButton() => find.byType(typeOf<FastSegmentedButton<String>>());

findInputDecorator() => find.byType(InputDecorator);

findSegmentedButton() => find.byType(typeOf<SegmentedButton<String>>());

findButtonSegments() => find.descendant(
      of: findSegmentedButton(),
      matching: find.byType(Text),
    );

void main() {
  late List<ButtonSegment<String>> segments;

  setUp(() {
    segments = const <ButtonSegment<String>>[
      ButtonSegment<String>(value: 'test1', label: Text('Test 1')),
      ButtonSegment<String>(value: 'test2', label: Text('Test 2')),
      ButtonSegment<String>(value: 'test3', label: Text('Test 3')),
    ];
  });

  testWidgets('renders FastSegmentedButton', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastSegmentedButton<String>(
      name: 'segmented_button',
      segments: segments,
    )));

    expect(findFastSegmentedButton(), findsOneWidget);
    expect(findInputDecorator(), findsOneWidget);
    expect(findSegmentedButton(), findsOneWidget);
    expect(findButtonSegments(), findsNWidgets(segments.length));
  });

  testWidgets('renders without InputDecoration', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastSegmentedButton<String>(
      name: 'segmented_button',
      segments: segments,
      showInputDecoration: false,
    )));

    expect(findFastSegmentedButton(), findsOneWidget);
    expect(findInputDecorator(), findsNothing);
    expect(findSegmentedButton(), findsOneWidget);
    expect(findButtonSegments(), findsNWidgets(segments.length));
  });

  testWidgets('updates FastSegmentedButton', (tester) async {
    final initialValue = {segments.first.value};
    final spy = OnChangedSpy<Set<String>>();

    await tester.pumpWidget(buildMaterialTestApp(FastSegmentedButton<String>(
      name: 'segmented_button',
      initialValue: initialValue,
      segments: segments,
      onChanged: spy.fn,
    )));

    final state = tester.state(findFastSegmentedButton());
    state as FastSegmentedButtonState<String>;
    expect(state.value, initialValue);

    await tester.tap(findButtonSegments().last);
    await tester.pumpAndSettle();

    final updatedValue = {segments.last.value};

    expect(spy.calledWith, updatedValue);
    expect(state.value, updatedValue);
  });

  testWidgets('allows empty and multiple selections', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastSegmentedButton<String>(
      name: 'segmented_button',
      emptySelectionAllowed: true,
      multiSelectionEnabled: true,
      segments: segments,
    )));

    final state = tester.state(findFastSegmentedButton());
    state as FastSegmentedButtonState<String>;
    expect(state.value, <String>{});

    final buttonSegmentsFinder = findButtonSegments();
    await tester.tap(buttonSegmentsFinder.first);
    await tester.pumpAndSettle();
    await tester.tap(buttonSegmentsFinder.last);
    await tester.pumpAndSettle();

    expect(state.value, {segments.first.value, segments.last.value});
  });
}
