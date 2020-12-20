import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('FastTimePicker', (WidgetTester tester) async {
    await tester.pumpWidget(
      Utils.wrapMaterial(
        FastTimePicker(
          id: 'time_picker',
        ),
      ),
    );

    final formFieldFinder = find.byType(TimePickerFormField);
    final iconButtonFinder = find.byType(IconButton);

    expect(formFieldFinder, findsOneWidget);
    expect(iconButtonFinder, findsOneWidget);
  });
}
