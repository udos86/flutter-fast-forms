import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('FastDropdown', (WidgetTester tester) async {
    final itemsLength = 3;
    final items = List.generate(itemsLength, (int index) => 'item $index');

    await tester.pumpWidget(
      Utils.wrapMaterial(
        FastDropdown(
          id: 'dropdown',
          items: items,
        ),
      ),
    );

    final dropdownFormFieldFinder =
        find.byType(Utils.typeOf<DropdownButtonFormField<String>>());
    final dropdownButtonFinder =
        find.byType(Utils.typeOf<DropdownButton<String>>());
    final itemsFinder = find.byType(Utils.typeOf<DropdownMenuItem<String>>());

    expect(dropdownFormFieldFinder, findsOneWidget);
    expect(dropdownButtonFinder, findsOneWidget);
    expect(itemsFinder, findsNWidgets(itemsLength));

    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    expect(itemsFinder, findsNWidgets(itemsLength * 2));
  });
}
