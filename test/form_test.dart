import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('renders FastForm', (tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FastForm(
          formKey: formKey,
          children: const [FastTextField(name: 'text_field')],
        ),
      ),
    ));

    expect(findFastForm(), findsOneWidget);
    expect(findForm(), findsOneWidget);
    expect(findFastTextField(), findsOneWidget);
  });

  testWidgets('registers form fields', (tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FastForm(
          formKey: formKey,
          children: const [FastTextField(name: 'text_field')],
        ),
      ),
    ));

    final fieldState = tester.state<FastTextFieldState>(findFastTextField());
    final formState = FastForm.of(fieldState.context);

    expect(formState?.values.containsKey(fieldState.widget.name), true);
    expect(formState?.values.containsValue(fieldState.value), true);
  });

  testWidgets('updates form fields', (tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FastForm(
          formKey: formKey,
          children: const [
            FastTextField(name: 'text_field'),
          ],
        ),
      ),
    ));

    final fieldState = tester.state<FastTextFieldState>(findFastTextField());
    final formState = FastForm.of(fieldState.context);

    const text = 'Hello Test';

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    expect(formState?.values.containsKey(fieldState.widget.name), true);
    expect(formState?.values.containsValue(fieldState.value), true);
  });

  testWidgets('calls callback on change', (tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    var onChangedCalled = false;
    late Map<String, dynamic> onChangedValues;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FastForm(
          formKey: formKey,
          onChanged: (values) {
            onChangedCalled = true;
            onChangedValues = values;
          },
          children: const [
            FastTextField(name: 'text_field'),
          ],
        ),
      ),
    ));

    expect(onChangedCalled, false);

    const text = 'Hello Test';

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    expect(onChangedCalled, true);
    expect(onChangedValues.containsValue(text), true);
  });

  testWidgets('resets FastForm', (tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FastForm(
            formKey: formKey,
            children: const [
              FastTextField(
                name: 'text_field',
                initialValue: 'Hello Test',
              )
            ],
          ),
        ),
      ),
    );

    final state = tester.state<FastTextFieldState>(findFastTextField());
    const text = 'Update Test';

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    expect(state.value, text);

    formKey.currentState?.reset();
    await tester.pumpAndSettle();

    expect(state.value, state.widget.initialValue);
  });

  testWidgets('saves FastForm', (tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    var onSavedCalled = false;
    String? onSavedValue;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FastForm(
          formKey: formKey,
          children: <Widget>[
            FastTextField(
              name: 'text_field',
              initialValue: 'Hello Test',
              onSaved: (String? value) {
                onSavedCalled = true;
                onSavedValue = value;
              },
            )
          ],
        ),
      ),
    ));

    const text = 'Update Test';

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    formKey.currentState?.save();
    await tester.pumpAndSettle();

    expect(onSavedCalled, true);
    expect(onSavedValue, text);
  });
}
