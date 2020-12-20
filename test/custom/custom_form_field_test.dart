import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('FastTextField', (WidgetTester tester) async {
    await tester.pumpWidget(
      Utils.wrapMaterial(
        FastCustomFormField(
          id: 'text_field',
          builder: (context, state) => RaisedButton(
            onPressed: () {},
          ),
        ),
      ),
    );

    final formFieldFinder = find.byType(RaisedButton);

    expect(formFieldFinder, findsOneWidget);
  });
}
