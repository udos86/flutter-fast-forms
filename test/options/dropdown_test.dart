import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDropdown', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(const FastDropdown<String>(
      name: 'dropdown',
      items: [],
    )));

    expect(findFastDropdown<String>(), findsOneWidget);
    expect(findDropdownButtonFormField<String>(), findsOneWidget);
    expect(findDropdown<String>(), findsOneWidget);
  });

  testWidgets('updates FastDropdown', (tester) async {
    const testIndex = 2;
    const itemsLength = 3;
    final items = List.generate(itemsLength, (int index) => 'item $index');
    final spy = OnChangedSpy<String>();

    await tester.pumpWidget(buildMaterialTestApp(FastDropdown<String>(
      name: 'dropdown',
      items: items,
      onChanged: spy.fn,
    )));

    final state =
        tester.state<FastDropdownState<String>>(findFastDropdown<String>());

    await tester.tap(findDropdownButton<String>());
    await tester.pumpAndSettle();

    final itemsFinder = findDropdownMenuItem<String>();
    expect(itemsFinder, findsNWidgets(itemsLength));

    await tester.tap(itemsFinder.at(testIndex), warnIfMissed: false);
    await tester.pumpAndSettle();

    final testValue = items[testIndex];

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('validates FastDropdown', (tester) async {
    const invalidItem = 'invalid item';
    const errorText = 'Do not touch this';

    await tester.pumpWidget(buildMaterialTestApp(FastDropdown<String>(
      name: 'dropdown',
      items: const ['item', invalidItem],
      validator: (value) => value == invalidItem ? errorText : null,
    )));

    final state = tester
        .state<FormFieldState<String>>(findDropdownButtonFormField<String>());

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(invalidItem);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
