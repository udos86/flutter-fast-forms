import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastRadioGroup widget', (WidgetTester tester) async {
    final options = [
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

    final optionsFinder = find.byType(RadioListTile);

    expect(fastRadioGroupFinder, findsOneWidget);

    expect(options.length, widget.options.length);
    expect(optionsFinder, findsNWidgets(options.length));
  });

  testWidgets('renders FastRadioGroup widget horizontally',
      (WidgetTester tester) async {
    final options = [
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

    final expandedsFinder = find.byType(Expanded);
    final optionsFinder = find.byType(RadioListTile);

    expect(expandedsFinder, findsNWidgets(options.length));
    expect(optionsFinder, findsNWidgets(options.length));
  });

  testWidgets('updates FastRadioGroup value', (WidgetTester tester) async {
    final options = [
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

    final optionsFinder = find.byType(RadioListTile);

    expect(state.value, options.first.value);

    await tester.tap(optionsFinder.last);
    await tester.pumpAndSettle();

    expect(state.value, options.last.value);
  });

  testWidgets('validates FastRadioGroup', (WidgetTester tester) async {
    final errorOption =
        RadioOption(title: 'Error Option', value: 'error-option');
    final errorText = 'Do not touch this';
    final options = [
      RadioOption(title: 'Option 1', value: 'option-1'),
      errorOption,
    ];

    await tester.pumpWidget(getFastTestWidget(
      FastRadioGroup<String>(
        id: 'radio_group',
        options: options,
        validator: (value) => value == errorOption.value ? errorText : null,
      ),
    ));

    final fastRadioGroupFinder = find.byType(typeOf<FastRadioGroup<String>>());
    final state =
        tester.state(fastRadioGroupFinder) as FastRadioGroupState<String>;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(errorOption.value);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
