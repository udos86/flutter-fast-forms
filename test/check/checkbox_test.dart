import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastCheckbox', (WidgetTester tester) async {
    const helper = 'helper';
    const label = 'label';
    const title = 'title';

    await tester.pumpWidget(buildMaterialTestApp(
      const FastCheckbox(
        name: 'checkbox',
        helperText: helper,
        labelText: label,
        titleText: title,
      ),
    ));

    expect(find.byType(FastCheckbox), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);
    expect(find.text(helper), findsOneWidget);
    expect(find.text(label), findsOneWidget);
    expect(find.text(title), findsOneWidget);
  });

  testWidgets('updates FastCheckbox', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      const FastCheckbox(name: 'checkbox', titleText: 'title'),
    ));

    final state = tester.state(find.byType(FastCheckbox)) as FastCheckboxState;

    expect(state.value, state.widget.initialValue);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    expect(state.value, !state.widget.initialValue!);
  });

  testWidgets('validates FastCheckbox', (WidgetTester tester) async {
    const errorText = 'Must be checked';

    await tester.pumpWidget(buildMaterialTestApp(
      FastCheckbox(
        name: 'checkbox',
        titleText: 'title',
        initialValue: true,
        validator: (value) => value! ? null : errorText,
      ),
    ));

    final state = tester.state(find.byType(FastCheckbox)) as FastCheckboxState;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(false);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
