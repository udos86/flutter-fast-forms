import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('renders FastForm', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      const FastTextField(name: 'text_field'),
    ]));

    expect(findFastForm(), findsOneWidget);
    expect(findForm(), findsOneWidget);
    expect(findFastTextField(), findsOneWidget);
  });

  testWidgets('registers form fields', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      const FastTextField(name: 'text_field'),
    ]));

    final field = tester.state<FastTextFieldState>(findFastTextField());
    final form = FastForm.of(field.context);

    final fieldStatus = form?.status[field.widget.name];
    expect(fieldStatus is FastFormFieldStatus, true);
    expect(fieldStatus?.value, field.value);
  });

  testWidgets('updates form fields', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      const FastTextField(name: 'text_field'),
    ]));

    final field = tester.state<FastTextFieldState>(findFastTextField());
    final form = FastForm.of(field.context);

    const text = 'Hello Test';

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    final fieldStatus = form?.status[field.widget.name];

    expect(fieldStatus is FastFormFieldStatus, true);
    expect(fieldStatus?.value, field.value);
  });

  testWidgets('calls callback on change', (tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    const fieldName = 'text_field';

    var onChangedCalled = false;
    late Map<String, FastFormFieldStatus<dynamic>> onChangedStatus;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FastForm(
          formKey: formKey,
          onChanged: (status) {
            onChangedCalled = true;
            onChangedStatus = status;
          },
          children: const [
            FastTextField(
              name: fieldName,
            ),
          ],
        ),
      ),
    ));

    expect(onChangedCalled, false);

    const text = 'Hello Test';

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    expect(onChangedCalled, true);
    expect(onChangedStatus[fieldName]?.value, text);
  });

  testWidgets('resets FastForm', (tester) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await tester.pumpWidget(buildMaterialTestApp([
      const FastTextField(
        name: 'text_field',
        initialValue: 'Hello Test',
      )
    ], formKey: formKey));

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

    await tester.pumpWidget(buildMaterialTestApp([
      FastTextField(
        name: 'text_field',
        initialValue: 'Hello Test',
        onSaved: (String? value) {
          onSavedCalled = true;
          onSavedValue = value;
        },
      )
    ], formKey: formKey));

    const text = 'Update Test';

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    formKey.currentState?.save();
    await tester.pumpAndSettle();

    expect(onSavedCalled, true);
    expect(onSavedValue, text);
  });
}
