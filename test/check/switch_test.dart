import 'package:flutter/foundation.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastSwitch', (tester) async {
    const widget = FastSwitch(name: 'switch', titleText: 'title');
    await tester.pumpWidget(buildMaterialTestApp(widget));

    expect(findFastSwitch(), findsOneWidget);
    expect(findInputDecorator(), findsOneWidget);
    expect(findSwitchListTile(), findsOneWidget);
    expect(findSwitch(), findsOneWidget);

    expect(find.text(widget.titleText!), findsOneWidget);
  });

  testWidgets('renders FastSwitch without InputDecorator', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(const FastSwitch(
      name: 'switch',
      showInputDecoration: false,
    )));

    expect(findFastSwitch(), findsOneWidget);
    expect(findInputDecorator(), findsNothing);
    expect(findSwitchListTile(), findsOneWidget);
    expect(findSwitch(), findsOneWidget);
  });

  testWidgets('updates FastSwitch', (tester) async {
    final spy = OnChangedSpy<bool>();

    await tester.pumpWidget(buildMaterialTestApp(FastSwitch(
      name: 'switch',
      titleText: 'title',
      onChanged: spy.fn,
    )));

    final state = tester.state<FastSwitchState>(findFastSwitch());
    expect(state.value, state.widget.initialValue);

    final testValue = !state.widget.initialValue!;

    await tester.tap(findSwitchListTile());
    await tester.pumpAndSettle();

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('validates FastSwitch', (tester) async {
    const errorText = 'Must be switched on';

    await tester.pumpWidget(buildMaterialTestApp(FastSwitch(
      name: 'switch',
      titleText: 'title',
      initialValue: true,
      validator: (value) => value! ? null : errorText,
    )));

    final state = tester.state<FastSwitchState>(findFastSwitch());

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(false);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('adapts FastSwitch to Android', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(buildMaterialTestApp(const FastSwitch(
      name: 'switch',
      titleText: 'title',
      adaptive: true,
    )));

    expect(findSwitchListTile(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('adapts FastSwitch to iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildCupertinoTestApp(const FastSwitch(
      name: 'switch',
      adaptive: true,
      titleText: 'title',
    )));

    expect(findCupertinoFormRow(), findsOneWidget);
    expect(findCupertinoSwitch(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
