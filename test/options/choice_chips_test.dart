import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<FastChoiceChip> chips;

  setUp(() {
    chips = [
      FastChoiceChip(value: 'chip1'),
      FastChoiceChip(value: 'chip2'),
      FastChoiceChip(value: 'chip3'),
    ];
  });

  testWidgets('renders FastChoiceChips', (WidgetTester tester) async {
    const helperText = 'helper';
    const labelText = 'label';

    await tester.pumpWidget(buildMaterialTestApp(
      FastChoiceChips(
        name: 'choice_chips',
        helperText: helperText,
        labelText: labelText,
        chips: chips,
      ),
    ));

    expect(find.byType(FastChoiceChips), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(chips.length));

    expect(find.text(helperText), findsOneWidget);
    expect(find.text(labelText), findsOneWidget);
  });

  testWidgets('updates FastChoiceChips', (WidgetTester tester) async {
    final spy = OnChangedSpy<List<String>>();

    await tester.pumpWidget(buildMaterialTestApp(
      FastChoiceChips(name: 'choice_chips', chips: chips, onChanged: spy.fn),
    ));

    final state =
        tester.state(find.byType(FastChoiceChips)) as FastChoiceChipsState;
    expect(state.value, state.widget.initialValue);
    expect(state.value, <String>{});

    final testValue = {chips.first.value};

    await tester.tap(find.byType(ChoiceChip).first);
    await tester.pumpAndSettle();

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('validates FastChoiceChips', (WidgetTester tester) async {
    const errorText = 'At least one chip must be selected';

    await tester.pumpWidget(buildMaterialTestApp(
      FastChoiceChips(
        name: 'choice_chips',
        chips: chips,
        validator: (selected) =>
            selected == null || selected.isEmpty ? errorText : null,
      ),
    ));

    final errorTextFinder = find.text(errorText);
    final firstChoiceFinder = find.byType(ChoiceChip).first;

    expect(errorTextFinder, findsNothing);

    await tester.tap(firstChoiceFinder);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsNothing);

    await tester.tap(firstChoiceFinder);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
