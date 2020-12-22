import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('FastDateRangerPicker', (WidgetTester tester) async {
    await tester.pumpWidget(
      Utils.wrapMaterial(
        FastDateRangePicker(
          id: 'date_range_picker',
          firstDate: DateTime(1900),
          lastDate: DateTime(2000),
        ),
      ),
    );

    final fastDateRangePickerFinder = find.byType(FastDateRangePicker);
    final iconButtonFinder = find.byType(IconButton);

    expect(fastDateRangePickerFinder, findsOneWidget);
    expect(iconButtonFinder, findsOneWidget);

    await tester.tap(iconButtonFinder);
    await tester.pumpAndSettle();
  });
}
