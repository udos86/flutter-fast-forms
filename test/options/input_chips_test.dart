import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<String> options;

  setUp(() {
    options = const ['Alabama', 'Montana', 'Nebraska', 'Wyoming'];
  });

  testWidgets('renders FastInputChips', (WidgetTester tester) async {
    const helper = 'helper';
    const label = 'label';

    await tester.pumpWidget(buildMaterialTestApp(
      FastInputChips(id: 'input_chips', helperText: helper, label: label),
    ));

    expect(find.byType(FastInputChips), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    expect(find.text(helper), findsOneWidget);
    expect(find.text(label), findsOneWidget);
  });

  testWidgets('shows InputChip', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastInputChips(id: 'input_chips', options: options),
    ));

    const text = 'Hello';

    await tester.enterText(find.byType(TextFormField), text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byType(InputChip), findsOneWidget);
  });

  testWidgets('updates FastInputChips by text input',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastInputChips(id: 'input_chips', options: options),
    ));

    final state =
        tester.state(find.byType(FastInputChips)) as FastInputChipsState;

    expect(state.value, state.widget.initialValue);

    const text = 'Hello';

    await tester.enterText(find.byType(TextFormField), text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(state.value, {text});
  });

  testWidgets('updates FastInputChips by selecting option',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastInputChips(id: 'input_chips', options: options),
    ));

    final state =
        tester.state(find.byType(FastInputChips)) as FastInputChipsState;
    final text = options.last;

    await tester.enterText(find.byType(TextFormField), text);
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
}
