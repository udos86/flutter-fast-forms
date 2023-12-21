import 'package:flutter/foundation.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastCheckbox', (tester) async {
    const widget = FastCheckbox(
      name: 'checkbox',
      helperText: 'helper',
      labelText: 'label',
      titleText: 'title',
    );
    await tester.pumpWidget(buildMaterialTestApp(widget));

    expect(findFastCheckbox(), findsOneWidget);
    expect(findInputDecorator(), findsOneWidget);
    expect(findCheckboxListTile(), findsOneWidget);

    expect(find.text(widget.helperText!), findsOneWidget);
    expect(find.text(widget.labelText!), findsOneWidget);
    expect(find.text(widget.titleText!), findsOneWidget);
  });

  testWidgets('renders FastCheckbox without InputDecorator', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(const FastCheckbox(
      name: 'checkbox',
      showInputDecoration: false,
    )));

    expect(findFastCheckbox(), findsOneWidget);
    expect(findInputDecorator(), findsNothing);
    expect(findCheckboxListTile(), findsOneWidget);
  });

  testWidgets('updates FastCheckbox', (tester) async {
    final spy = OnChangedSpy<bool>();
    await tester.pumpWidget(buildMaterialTestApp(FastCheckbox(
      name: 'checkbox',
      titleText: 'Title',
      onChanged: spy.fn,
    )));

    final state = tester.state<FastCheckboxState>(findFastCheckbox());
    expect(state.value, state.widget.initialValue);

    final testValue = !state.widget.initialValue!;

    await tester.tap(findCheckboxListTile());
    await tester.pumpAndSettle();

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('validates FastCheckbox', (tester) async {
    const errorText = 'Must be checked';

    await tester.pumpWidget(buildMaterialTestApp(FastCheckbox(
      name: 'checkbox',
      titleText: 'title',
      initialValue: true,
      validator: (value) => value! ? null : errorText,
    )));

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    final state = tester.state<FastCheckboxState>(findFastCheckbox());
    state.didChange(false);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('adapts FastCheckbox to iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildCupertinoTestApp(const FastCheckbox(
      name: 'switch',
      adaptive: true,
      titleText: 'title',
    )));

    expect(findCupertinoFormRow(), findsOneWidget);
    expect(findCupertinoCheckbox(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
