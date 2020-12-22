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

    final formFieldFinder = find.byType(Utils.typeOf<DropdownButtonFormField<String>>());
    final itemsFinder = find.byType(Utils.typeOf<DropdownMenuItem<String>>());

    expect(formFieldFinder, findsOneWidget);
    expect(itemsFinder, findsNWidgets(itemsLength));
  });
}
