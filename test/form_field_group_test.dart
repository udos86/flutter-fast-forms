import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('renders FastFormFieldGroup', (WidgetTester tester) async {
    final titleWidget = Text('Test Form Group');

    await tester.pumpWidget(getFastTestWidget(
      FastFormFieldGroup(
        title: titleWidget,
        children: [
          FastTextField(
            id: 'text_field',
          ),
        ],
      ),
    ));

    final fastFormFieldGroupFinder = find.byType(FastFormFieldGroup);
    final titleFinder = find.byWidget(titleWidget);
    final fastTextFieldFinder = find.byType(FastTextField);

    expect(fastFormFieldGroupFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
    expect(fastTextFieldFinder, findsOneWidget);
  });

  testWidgets('renders FastFormFieldGroup horizontally',
      (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastFormFieldGroup(
        orientation: FormFieldGroupOrientation.horizontal,
        children: [
          FastTextField(
            id: 'text_field',
          ),
        ],
      ),
    ));

    final fastFormFieldGroupFinder = find.byType(FastFormFieldGroup);
    final rowFinder = find.byType(Row);
    final expandedFinder = find.byType(Expanded);
    final fastTextFieldFinder = find.byType(FastTextField);

    expect(fastFormFieldGroupFinder, findsOneWidget);
    expect(rowFinder, findsOneWidget);
    expect(expandedFinder, findsOneWidget);
    expect(fastTextFieldFinder, findsOneWidget);
  });
}
