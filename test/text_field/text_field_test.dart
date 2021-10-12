import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastTextField', (WidgetTester tester) async {
    const prefix = Text('prefix');
    const suffix = Text('suffix');

    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        prefix: prefix,
        suffix: suffix,
      ),
    ));

    expect(find.byType(FastTextField), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byWidget(prefix), findsOneWidget);
    expect(find.byWidget(suffix), findsOneWidget);
  });

  testWidgets('builds input counter', (WidgetTester tester) async {
    const maxLength = 7;

    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        maxLength: maxLength,
        buildCounter: inputCounterWidgetBuilder,
      ),
    ));

    final state =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;

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

  testWidgets('updates FastTextField', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
      ),
    ));

    final state =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;

    expect(state.value, state.widget.initialValue);

    const text = 'This is a test';

    await tester.enterText(find.byType(TextFormField), text);
    await tester.pumpAndSettle();

    expect(state.value, text);
  });

  testWidgets('validates FastTextField', (WidgetTester tester) async {
    const invalidText = 'This is an invalid text';
    const errorText = 'Invalid input text';

    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        validator: (value) => value == invalidText ? errorText : null,
      ),
    ));

    final state =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.touched = true;
    await tester.enterText(find.byType(TextFormField), invalidText);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('adapts FastTextField to Android', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        adaptive: true,
      ),
    ));

    expect(find.byType(TextFormField), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('adapts FastTextField to iOS', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        adaptive: true,
      ),
    ));

    expect(find.byType(CupertinoTextFormFieldRow), findsOneWidget);
    expect(find.byType(CupertinoTextField), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
