import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastTextField', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
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

    final state =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;

    final inputCounterText = inputCounterWidgetBuilder(
      state.context,
      currentLength: state.value!.length,
      maxLength: maxLength,
      isFocused: false,
    ) as Text;

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

    final text = 'This is a test';

    await tester.enterText(find.byType(TextFormField), text);
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

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.touched = true;
    await tester.enterText(find.byType(TextFormField), invalidText);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
