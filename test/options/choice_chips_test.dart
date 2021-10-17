import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<FastChoiceChip> chips;

  setUp(() {
    chips = const [
      FastChoiceChip(label: Text('chip1')),
      FastChoiceChip(label: Text('chip2')),
      FastChoiceChip(label: Text('chip3'))
    ];
  });

  testWidgets('renders FastChoiceChips', (WidgetTester tester) async {
    const helper = 'helper';
    const label = 'label';

    await tester.pumpWidget(getFastTestWidget(
      FastChoiceChips(
        id: 'choice_chips',
        helperText: helper,
        label: label,
        chips: chips,
      ),
    ));

    expect(find.byType(FastChoiceChips), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(chips.length));

    expect(find.text(helper), findsOneWidget);
    expect(find.text(label), findsOneWidget);
  });

  testWidgets('updates FastChoiceChips', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastChoiceChips(
        id: 'choice_chips',
        chips: chips,
      ),
    ));

    final state =
        tester.state(find.byType(FastChoiceChips)) as FastChoiceChipsState;

    expect(state.value, state.widget.initialValue);
    expect(state.value, <int>{});

    await tester.tap(find.byType(ChoiceChip).first);
    await tester.pumpAndSettle();

    expect(state.value, <int>{chips.indexOf(chips.first)});
  });

  testWidgets('validates FastChoiceChips', (WidgetTester tester) async {
    const errorText = 'At least one chip must be selected';

    await tester.pumpWidget(getFastTestWidget(
      FastChoiceChips(
        id: 'choice_chips',
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
