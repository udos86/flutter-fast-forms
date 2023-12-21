import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastTextField', (tester) async {
    const prefix = Text('prefix');
    const suffix = Text('suffix');

    await tester.pumpWidget(buildMaterialTestApp(const FastTextField(
      name: 'text_field',
      prefix: prefix,
      suffix: suffix,
    )));

    expect(findFastTextField(), findsOneWidget);
    expect(findTextFormField(), findsOneWidget);

    expect(find.byWidget(prefix), findsOneWidget);
    expect(find.byWidget(suffix), findsOneWidget);
  });

  testWidgets('builds input counter', (tester) async {
    const maxLength = 7;

    await tester.pumpWidget(buildMaterialTestApp(const FastTextField(
      name: 'text_field',
      maxLength: maxLength,
      buildCounter: inputCounterWidgetBuilder,
    )));

    final state = tester.state<FastTextFieldState>(findFastTextField());

    final inputCounterText = inputCounterWidgetBuilder(
      state.context,
      currentLength: state.value!.length,
      maxLength: maxLength,
      isFocused: false,
    );

    final inputCounterTextFinder =
        find.bySemanticsLabel(inputCounterText.semanticsLabel as Pattern);

    expect(inputCounterTextFinder, findsOneWidget);
  });

  testWidgets('updates FastTextField', (tester) async {
    final spy = OnChangedSpy<String>();

    await tester.pumpWidget(buildMaterialTestApp(FastTextField(
      name: 'text_field',
      onChanged: spy.fn,
    )));

    final state = tester.state<FastTextFieldState>(findFastTextField());
    expect(state.value, state.widget.initialValue);

    const text = 'This is a test';

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    expect(spy.calledWith, text);
    expect(state.value, text);
  });

  testWidgets('validates FastTextField on touched', (tester) async {
    const errorText = 'Field is required';

    await tester.pumpWidget(buildMaterialTestApp(FastTextField(
      name: 'text_field',
      validator: (value) => value == null || value.isEmpty ? errorText : null,
    )));

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    final textFieldFinder = findFastTextField();
    final state = tester.state<FastTextFieldState>(textFieldFinder);

    await tester.tap(textFieldFinder);
    state.focusNode.unfocus();
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('validates FastTextField', (tester) async {
    const invalidText = 'This is an invalid text';
    const errorText = 'Invalid input text';

    await tester.pumpWidget(buildMaterialTestApp(FastTextField(
      name: 'text_field',
      autovalidateOnTouched: false,
      validator: (value) => value == invalidText ? errorText : null,
    )));

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    await tester.enterText(findTextFormField(), invalidText);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('adapts FastTextField to Android', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(buildMaterialTestApp(const FastTextField(
      name: 'text_field',
      adaptive: true,
    )));

    expect(findTextFormField(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('adapts FastTextField to iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildMaterialTestApp(const FastTextField(
      name: 'text_field',
      adaptive: true,
    )));

    expect(findCupertinoTextFormFieldRow(), findsOneWidget);
    expect(findCupertinoTextField(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
