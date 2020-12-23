import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('FastTimePicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTimePicker(
        id: 'time_picker',
      ),
    ));

    final iconButtonFinder = find.byType(IconButton);

    expect(iconButtonFinder, findsOneWidget);
  });
}
