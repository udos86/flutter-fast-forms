import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastSlider widget', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastSlider(
        id: 'slider',
        min: 0,
        max: 10,
      ),
    ));

    final formFieldFinder = find.byType(Slider);

    expect(formFieldFinder, findsOneWidget);
  });
}
