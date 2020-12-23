import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastTextField', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        maxLength: 7,
        buildCounter: inputCounterWidgetBuilder,
      ),
    ));

    final fastTextField = find.byType(FastTextField);
    final textFormFieldFinder = find.byType(TextFormField);

    expect(fastTextField, findsOneWidget);
    expect(textFormFieldFinder, findsOneWidget);
  });

  testWidgets('builds input counter', (WidgetTester tester) async {
    final maxLength = 7;

    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        maxLength: maxLength,
        buildCounter: inputCounterWidgetBuilder,
      ),
    ));

    final fastTextFieldFinder = find.byType(FastTextField);
    final state = tester.state(fastTextFieldFinder) as FastTextFieldState;

    final inputCounterText = inputCounterWidgetBuilder(
      state.context,
      currentLength: state.value.length,
      maxLength: maxLength,
      isFocused: false,
    ) as Text;
    final inputCounterTextFinder =
        find.bySemanticsLabel(inputCounterText.semanticsLabel);

    expect(inputCounterTextFinder, findsOneWidget);
  });

  testWidgets('updates FastTextField', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
      ),
    ));

    final fastTextFieldFinder = find.byType(FastTextField);
    final state = tester.state(fastTextFieldFinder) as FastTextFieldState;

    expect(state.value, state.widget.initialValue);

    final textFormFieldFinder = find.byType(TextFormField);
    final text = 'This is a test';

    await tester.enterText(textFormFieldFinder, text);
    await tester.pumpAndSettle();

    expect(state.value, text);
  });

  testWidgets('validates FastTextField', (WidgetTester tester) async {
    final invalidText = 'This is an invalid text';
    final errorText = 'Invalid input text';

    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        validator: (value) => value == invalidText ? errorText : null,
      ),
    ));

    final state =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;
    final textFormFieldFinder = find.byType(TextFormField);

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.touched = true;
    await tester.enterText(textFormFieldFinder, invalidText);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
