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

  testWidgets('renders FastChipsInput as Wrap', (WidgetTester tester) async {
    const helperText = 'helper';
    const labelText = 'label';

    await tester.pumpWidget(buildMaterialTestApp(
      const FastChipsInput(
        name: 'input_chips',
        helperText: helperText,
        labelText: labelText,
      ),
    ));

    expect(find.byType(FastChipsInput), findsOneWidget);
    expect(find.byType(Wrap), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    expect(find.text(helperText), findsOneWidget);
    expect(find.text(labelText), findsOneWidget);
  });

  testWidgets('renders FastChipsInput as ListView',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      const FastChipsInput(name: 'input_chips', wrap: false),
    ));

    expect(find.byType(FastChipsInput), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('shows InputChip', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastChipsInput(name: 'input_chips', options: options),
    ));

    const text = 'Test';

    await tester.enterText(find.byType(TextFormField).last, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byType(InputChip), findsOneWidget);
  });

  testWidgets('updates FastChipsInput by text input',
      (WidgetTester tester) async {
    final spy = OnChangedSpy<List<String>>();

    await tester.pumpWidget(buildMaterialTestApp(
      FastChipsInput(name: 'input_chips', options: options, onChanged: spy.fn),
    ));

    final state =
        tester.state(find.byType(FastChipsInput)) as FastChipsInputState;

    expect(state.value, state.widget.initialValue);

    const text = 'Test';

    await tester.enterText(find.byType(TextFormField).last, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final testValue = {text};

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('updates FastChipsInput by selecting option',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastChipsInput(name: 'input_chips', options: options),
    ));

    final state =
        tester.state(find.byType(FastChipsInput)) as FastChipsInputState;
    final text = options.last;

    await tester.enterText(find.byType(TextFormField).last, text);
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

  testWidgets('removes InputChip via backspace', (WidgetTester tester) async {
    const initialValue = ['Test1', 'Test2', 'Test3'];

    await tester.pumpWidget(buildMaterialTestApp(
      const FastChipsInput(name: 'input_chips', initialValue: initialValue),
    ));

    final state =
        tester.state(find.byType(FastChipsInput)) as FastChipsInputState;

    await tester.showKeyboard(find.byType(TextFormField).last);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();

    expect(state.selectedChipIndex, initialValue.indexOf(initialValue.last));
    expect(state.backspaceRemove, true);

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();

    expect(state.value, ['Test1', 'Test2']);
  });
}
