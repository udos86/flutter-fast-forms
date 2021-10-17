import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<String> options;

  setUp(() {
    options = const ['Alabama', 'Montana', 'Nebraska', 'Wyoming'];
  });

  testWidgets(
      'throws when no options or optionsBuilder is present on FastAutocomplete',
      (WidgetTester _tester) async {
    expect(() => FastAutocomplete<String>(id: 'id'), throwsAssertionError);
  });

  testWidgets('renders FastAutocomplete', (WidgetTester tester) async {
    const helper = 'helper';
    const label = 'label';

    await tester.pumpWidget(getFastTestWidget(
      FastAutocomplete<String>(
        id: 'autocomplete',
        helperText: helper,
        label: label,
        options: options,
      ),
    ));

    expect(find.byType(typeOf<FastAutocomplete<String>>()), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    expect(find.text(helper), findsOneWidget);
    expect(find.text(label), findsOneWidget);
  });

  testWidgets('shows FastAutocomplete options', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastAutocomplete<String>(
        id: 'autocomplete',
        options: options,
      ),
    ));

    final text = options.last;

    await tester.enterText(find.byType(TextFormField), text);
    await tester.pumpAndSettle();

    expect(find.text(text), findsNWidgets(2));
  });

  testWidgets('updates FastAutocomplete', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastAutocomplete<String>(
        id: 'autocomplete',
        options: options,
      ),
    ));

    final state = tester.state(find.byType(typeOf<FastAutocomplete<String>>()))
        as FastAutocompleteState<String>;

    expect(state.value, state.widget.initialValue);

    await tester.enterText(find.byType(TextFormField), options.first);
    await tester.pumpAndSettle();

    expect(state.value, options.first);
  });
}
