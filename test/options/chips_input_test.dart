import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<String> options;

  setUp(() {
    options = const ['Alabama', 'Montana', 'Nebraska', 'Wyoming'];
  });

  testWidgets('renders FastChipsInput as Wrap', (tester) async {
    const helperText = 'helper';
    const labelText = 'label';

    await tester.pumpWidget(buildMaterialTestApp(const FastChipsInput(
      name: 'input_chips',
      helperText: helperText,
      labelText: labelText,
    )));

    expect(findFastChipsInput(), findsOneWidget);
    expect(findWrap(), findsOneWidget);
    expect(findTextFormField(), findsNWidgets(2));

    expect(find.text(helperText), findsOneWidget);
    expect(find.text(labelText), findsOneWidget);
  });

  testWidgets('renders FastChipsInput as ListView', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(const FastChipsInput(
      name: 'input_chips',
      wrap: false,
    )));

    expect(findFastChipsInput(), findsOneWidget);
    expect(findListView(), findsOneWidget);
    expect(findTextFormField(), findsNWidgets(2));
  });

  testWidgets('shows InputChip', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastChipsInput(name: 'input_chips', options: options),
    ));

    const text = 'Test';

    await tester.enterText(findTextFormField().last, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(findInputChip(), findsOneWidget);
  });

  testWidgets('updates FastChipsInput by text input', (tester) async {
    final spy = OnChangedSpy<List<String>>();

    await tester.pumpWidget(buildMaterialTestApp(FastChipsInput(
      name: 'input_chips',
      options: options,
      onChanged: spy.fn,
    )));

    final state = tester.state<FastChipsInputState>(findFastChipsInput());
    expect(state.value, state.widget.initialValue);

    const text = 'Test';

    await tester.enterText(findTextFormField().last, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final testValue = {text};

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('updates FastChipsInput by selecting option', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastChipsInput(
      name: 'input_chips',
      options: options,
    )));

    final state = tester.state<FastChipsInputState>(findFastChipsInput());
    final text = options.last;

    await tester.enterText(findTextFormField().last, text);
    await tester.pumpAndSettle();

    final optionFinder = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(InkWell),
    );

    expect(optionFinder, findsOneWidget);

    await tester.tap(optionFinder);
    await tester.pumpAndSettle();

    expect(state.value, {text});
  });

  testWidgets('removes InputChip via backspace', (tester) async {
    const initialValue = ['Test1', 'Test2', 'Test3'];

    await tester.pumpWidget(buildMaterialTestApp(const FastChipsInput(
      name: 'input_chips',
      initialValue: initialValue,
    )));

    final state = tester.state<FastChipsInputState>(findFastChipsInput());

    await tester.showKeyboard(findTextFormField().last);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();

    expect(state.selectedChipIndex, initialValue.indexOf(initialValue.last));
    expect(state.backspaceRemove, true);

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();

    expect(state.value, ['Test1', 'Test2']);
  });

  testWidgets('adds zwsp character on new text input', (tester) async {
    const testInput = 't';

    await tester.pumpWidget(buildMaterialTestApp(const FastChipsInput(
      name: 'input_chips',
    )));

    final state = tester.state<FastChipsInputState>(findFastChipsInput());

    await tester.enterText(findTextFormField().last, testInput);
    await tester.pumpAndSettle();

    expect(state.text, Zwsp.raw + testInput);
  });
}
