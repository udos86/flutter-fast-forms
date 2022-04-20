import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastCheckbox', (WidgetTester tester) async {
    const helperText = 'helper';
    const labelText = 'label';
    const titleText = 'title';

    await tester.pumpWidget(buildMaterialTestApp(
      const FastCheckbox(
        name: 'checkbox',
        helperText: helperText,
        labelText: labelText,
        titleText: titleText,
      ),
    ));

    expect(find.byType(FastCheckbox), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);
    expect(find.text(helperText), findsOneWidget);
    expect(find.text(labelText), findsOneWidget);
    expect(find.text(titleText), findsOneWidget);
  });

  testWidgets('updates FastCheckbox', (WidgetTester tester) async {
    final spy = OnChangedSpy<bool>();

    await tester.pumpWidget(buildMaterialTestApp(
      FastCheckbox(name: 'checkbox', titleText: 'title', onChanged: spy.fn),
    ));

    final state = tester.state(find.byType(FastCheckbox)) as FastCheckboxState;
    expect(state.value, state.widget.initialValue);

    final testValue = !state.widget.initialValue!;

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
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
