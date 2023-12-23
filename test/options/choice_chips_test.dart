import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<FastChoiceChip<String>> chips;

  setUp(() {
    chips = [
      FastChoiceChip(value: 'chip1'),
      FastChoiceChip(value: 'chip2'),
      FastChoiceChip(value: 'chip3'),
    ];
  });

  testWidgets('renders FastChoiceChips', (tester) async {
    const helperText = 'helper';
    const labelText = 'label';

    await tester.pumpWidget(buildMaterialTestApp(FastChoiceChips(
      name: 'choice_chips',
      helperText: helperText,
      labelText: labelText,
      chips: chips,
    )));

    expect(findFastChoiceChips<String>(), findsOneWidget);
    expect(findChoiceChip(), findsNWidgets(chips.length));

    expect(find.text(helperText), findsOneWidget);
    expect(find.text(labelText), findsOneWidget);
  });

  testWidgets('updates FastChoiceChips', (tester) async {
    final spy = OnChangedSpy<Set<String>>();

    await tester.pumpWidget(buildMaterialTestApp(FastChoiceChips(
      name: 'choice_chips',
      chips: chips,
      onChanged: spy.fn,
    )));

    final state = tester
        .state<FastChoiceChipsState<String>>(findFastChoiceChips<String>());
    expect(state.value, state.widget.initialValue);
    expect(state.value, <String>{});

    final testValue = {chips.first.value};

    await tester.tap(findChoiceChip().first);
    await tester.pumpAndSettle();

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('validates FastChoiceChips', (tester) async {
    const errorText = 'At least one chip must be selected';

    await tester.pumpWidget(buildMaterialTestApp(FastChoiceChips(
      name: 'choice_chips',
      chips: chips,
      validator: (selected) =>
          selected == null || selected.isEmpty ? errorText : null,
    )));

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    final firstChoiceFinder = findChoiceChip().first;
    await tester.tap(firstChoiceFinder);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsNothing);

    await tester.tap(firstChoiceFinder);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
