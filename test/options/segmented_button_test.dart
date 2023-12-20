import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

_findFastSegmentedButton() => find.byType(typeOf<FastSegmentedButton<String>>());

_findInputDecorator() => find.byType(InputDecorator);

_findSegmentedButton() => find.byType(typeOf<SegmentedButton<String>>());

_findButtonSegments() => find.descendant(
      of: _findSegmentedButton(),
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

    expect(_findFastSegmentedButton(), findsOneWidget);
    expect(_findInputDecorator(), findsOneWidget);
    expect(_findSegmentedButton(), findsOneWidget);
    expect(_findButtonSegments(), findsNWidgets(segments.length));
  });

  testWidgets('renders without InputDecoration', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastSegmentedButton<String>(
      name: 'segmented_button',
      segments: segments,
      showInputDecoration: false,
    )));

    expect(_findFastSegmentedButton(), findsOneWidget);
    expect(_findInputDecorator(), findsNothing);
    expect(_findSegmentedButton(), findsOneWidget);
    expect(_findButtonSegments(), findsNWidgets(segments.length));
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

    final state = tester.state(_findFastSegmentedButton())
        as FastSegmentedButtonState<String>;
    expect(state.value, initialValue);

    final buttonSegmentsFinder = _findButtonSegments();
    await tester.tap(buttonSegmentsFinder.last);
    await tester.pumpAndSettle();

    final testValue = {segments.last.value};

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('allows empty and multiple selections', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastSegmentedButton<String>(
      name: 'segmented_button',
      emptySelectionAllowed: true,
      multiSelectionEnabled: true,
      segments: segments,
    )));

    final state = tester.state(_findFastSegmentedButton())
        as FastSegmentedButtonState<String>;
    expect(state.value, <String>{});

    final buttonSegmentsFinder = _findButtonSegments();
    await tester.tap(buttonSegmentsFinder.first);
    await tester.pumpAndSettle();
    await tester.tap(buttonSegmentsFinder.last);
    await tester.pumpAndSettle();

    expect(state.value, {segments.first.value, segments.last.value});
  });
}
