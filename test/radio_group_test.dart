import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('FastRadioGroup', (WidgetTester tester) async {
    final options = [
      RadioOption(
        title: 'Option 1',
        value: 'option-1',
      ),
      RadioOption(
        title: 'Option 2',
        value: 'option-2',
      ),
      RadioOption(
        title: 'Option 3',
        value: 'option-3',
      ),
    ];

    await tester.pumpWidget(
      Utils.wrapMaterial(
        FastRadioGroup(
          id: 'radio_group',
          options: options,
        ),
      ),
    );

    final formFieldFinder =
        find.byType(Utils.typeOf<RadioGroupFormField<String>>());
    final optionsFinder = find.byType(RadioListTile);

    expect(formFieldFinder, findsOneWidget);
    expect(optionsFinder, findsNWidgets(options.length));
  });
}
