import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders FastForm', (WidgetTester tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FastForm(
            formKey: formKey,
            children: <Widget>[
              FastTextField(
                id: 'text_field',
              )
            ],
          ),
        ),
      ),
    );

    final fastFormFinder = find.byType(FastForm);
    final formFinder = find.byType(Form);
    final fastFormScopeFinder = find.byType(FastFormScope);
    final fastTextFieldFinder = find.byType(FastTextField);

    expect(fastFormFinder, findsOneWidget);
    expect(formFinder, findsOneWidget);
    expect(fastFormScopeFinder, findsOneWidget);
    expect(fastTextFieldFinder, findsOneWidget);
  });

  testWidgets('registers form fields', (WidgetTester tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FastForm(
            formKey: formKey,
            children: <Widget>[
              FastTextField(
                id: 'text_field',
              )
            ],
          ),
        ),
      ),
    );

    final fieldState =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;
    final formState = FastFormScope.of(fieldState.context)?.formState;

    expect(formState?.values.containsKey(fieldState.widget.id), true);
    expect(formState?.values.containsValue(fieldState.value), true);
  });

  testWidgets('updates form fields', (WidgetTester tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FastForm(
            formKey: formKey,
            children: <Widget>[
              FastTextField(
                id: 'text_field',
              )
            ],
          ),
        ),
      ),
    );

    final fieldState =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;
    final formState = FastFormScope.of(fieldState.context)?.formState;

    final text = 'Hello Test';

    await tester.enterText(find.byType(TextFormField), text);
    await tester.pumpAndSettle();

    expect(formState?.values.containsKey(fieldState.widget.id), true);
    expect(formState?.values.containsValue(fieldState.value), true);
  });

  testWidgets('calls callback on change', (WidgetTester tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    var onChangedCalled = false;
    late Map<String, dynamic> onChangedValues;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FastForm(
            formKey: formKey,
            onChanged: (values) {
              onChangedCalled = true;
              onChangedValues = values;
            },
            children: <Widget>[
              FastTextField(
                id: 'text_field',
              )
            ],
          ),
        ),
      ),
    );

    expect(onChangedCalled, false);

    final text = 'Hello Test';

    await tester.enterText(find.byType(TextFormField), text);
    await tester.pumpAndSettle();

    expect(onChangedCalled, true);
    expect(onChangedValues.containsValue(text), true);
  });

  testWidgets('resets FastForm', (WidgetTester tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FastForm(
            formKey: formKey,
            children: <Widget>[
              FastTextField(
                id: 'text_field',
                initialValue: 'Hello Test',
              )
            ],
          ),
        ),
      ),
    );

    final state =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;
    final text = 'Update Test';

    await tester.enterText(find.byType(TextFormField), text);
    await tester.pumpAndSettle();

    expect(state.value, text);

    formKey.currentState?.reset();
    await tester.pumpAndSettle();

    expect(state.value, state.widget.initialValue);
  });
}
