import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  Widget getTestWidget([List<String> items = const []]) {
    return Utils.wrapMaterial(
      FastDropdown(
        id: 'dropdown',
        items: items,
      ),
    );
  }

  testWidgets('renders FastDropdown', (WidgetTester tester) async {
    await tester.pumpWidget(getTestWidget());

    final fastDropdownFinder = find.byType(FastDropdown);
    final dropdownFormFieldFinder =
        find.byType(Utils.typeOf<DropdownButtonFormField<String>>());
    final dropdownButtonFinder =
        find.byType(Utils.typeOf<DropdownButton<String>>());

    expect(fastDropdownFinder, findsOneWidget);
    expect(dropdownFormFieldFinder, findsOneWidget);
    expect(dropdownButtonFinder, findsOneWidget);
  });

  testWidgets('selects FastDropdown item', (WidgetTester tester) async {
    final itemsLength = 3;
    final items = List.generate(itemsLength, (int index) => 'item $index');
    final testIndex = 2;

    await tester.pumpWidget(getTestWidget(items));

    final fastDropdownFinder = find.byType(FastDropdown);
    final dropdownButtonFinder =
        find.byType(Utils.typeOf<DropdownButton<String>>());
    final itemsFinder = find.byType(Utils.typeOf<DropdownMenuItem<String>>());

    expect(itemsFinder, findsNWidgets(itemsLength));

    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    expect(itemsFinder, findsNWidgets(itemsLength * 2));

    await tester.tap(itemsFinder.at(itemsLength + testIndex));
    await tester.pumpAndSettle();

    final state = tester.state(fastDropdownFinder) as FastDropdownState;
    expect(state.value, items[testIndex]);
  });
}
