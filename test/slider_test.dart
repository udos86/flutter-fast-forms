import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('FastSlider', (WidgetTester tester) async {
    await tester.pumpWidget(
      Utils.wrapMaterial(
        FastSlider(
          id: 'slider',
          min: 0,
          max: 10,
        ),
      ),
    );

    final formFieldFinder = find.byType(SliderFormField);

    expect(formFieldFinder, findsOneWidget);
  });
}
