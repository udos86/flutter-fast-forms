import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastRadioGroup widget', (WidgetTester tester) async {
    const options = [
      RadioOption(title: 'Option 1', value: 'option-1'),
      RadioOption(title: 'Option 2', value: 'option-2'),
    ];

    await tester.pumpWidget(getFastTestWidget(
      FastRadioGroup<String>(
        id: 'radio_group',
        options: options,
      ),
    ));

    final fastRadioGroupFinder = find.byType(typeOf<FastRadioGroup<String>>());
    final widget =
        tester.widget(fastRadioGroupFinder) as FastRadioGroup<String>;

    final optionsFinder = find.byType(typeOf<RadioListTile<String>>());

    expect(fastRadioGroupFinder, findsOneWidget);

    expect(options.length, widget.options.length);
    expect(optionsFinder, findsNWidgets(options.length));
  });

  testWidgets('renders FastRadioGroup widget horizontally',
      (WidgetTester tester) async {
    const options = [
      RadioOption(title: 'Option 1', value: 'option-1'),
      RadioOption(title: 'Option 2', value: 'option-2'),
    ];

    await tester.pumpWidget(getFastTestWidget(
      FastRadioGroup<String>(
        id: 'radio_group',
        options: options,
        orientation: RadioGroupOrientation.horizontal,
      ),
    ));

    final expandedFinder = find.byType(Expanded);
    final optionsFinder = find.byType(typeOf<RadioListTile<String>>());

    expect(expandedFinder, findsNWidgets(options.length));
    expect(optionsFinder, findsNWidgets(options.length));
  });

  testWidgets('updates FastRadioGroup value', (WidgetTester tester) async {
    const options = [
      RadioOption(title: 'Option 1', value: 'option-1'),
      RadioOption(title: 'Option 2', value: 'option-2'),
    ];

    await tester.pumpWidget(getFastTestWidget(
      FastRadioGroup<String>(
        id: 'radio_group',
        options: options,
      ),
    ));

    final fastRadioGroupFinder = find.byType(typeOf<FastRadioGroup<String>>());
    final state =
        tester.state(fastRadioGroupFinder) as FastRadioGroupState<String>;

    final optionsFinder = find.byType(typeOf<RadioListTile<String>>());

    expect(state.value, options.first.value);

    await tester.tap(optionsFinder.last);
    await tester.pumpAndSettle();

    expect(state.value, options.last.value);
  });

  testWidgets('validates FastRadioGroup', (WidgetTester tester) async {
    const errorText = 'Do not touch this';
    const invalidOption =
        RadioOption(title: 'Invalid Option', value: 'invalid-option');
    final options = [
      const RadioOption(title: 'Option 1', value: 'option-1'),
      invalidOption,
    ];

    await tester.pumpWidget(getFastTestWidget(
      FastRadioGroup<String>(
        id: 'radio_group',
        options: options,
        validator: (value) => value == invalidOption.value ? errorText : null,
      ),
    ));

    final fastRadioGroupFinder = find.byType(typeOf<FastRadioGroup<String>>());
    final state =
        tester.state(fastRadioGroupFinder) as FastRadioGroupState<String>;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(invalidOption.value);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
