import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDropdown widget', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDropdown(
        id: 'dropdown',
        items: [],
      ),
    ));

    final fastDropdownFinder = find.byType(FastDropdown);
    final dropdownFormFieldFinder =
        find.byType(typeOf<DropdownButtonFormField<String>>());
    final dropdownButtonFinder = find.byType(typeOf<DropdownButton<String>>());

    expect(fastDropdownFinder, findsOneWidget);
    expect(dropdownFormFieldFinder, findsOneWidget);
    expect(dropdownButtonFinder, findsOneWidget);
  });

  testWidgets('updates FastDropdown value', (WidgetTester tester) async {
    final itemsLength = 3;
    final items = List.generate(itemsLength, (int index) => 'item $index');
    final testIndex = 2;

    await tester.pumpWidget(getFastTestWidget(
      FastDropdown(
        id: 'dropdown',
        items: items,
      ),
    ));

    final fastDropdownFinder = find.byType(FastDropdown);
    final state = tester.state(fastDropdownFinder) as FastDropdownState;

    final dropdownButtonFinder = find.byType(typeOf<DropdownButton<String>>());
    final itemsFinder = find.byType(typeOf<DropdownMenuItem<String>>());

    expect(itemsFinder, findsNWidgets(itemsLength));

    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    expect(itemsFinder, findsNWidgets(itemsLength * 2));

    await tester.tap(itemsFinder.at(itemsLength + testIndex));
    await tester.pumpAndSettle();

    expect(state.value, items[testIndex]);
  });
}
