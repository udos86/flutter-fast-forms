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
      (WidgetTester tester) async {
    expect(() => FastAutocomplete<String>(name: 'id'), throwsAssertionError);
  });

  testWidgets('renders FastAutocomplete', (WidgetTester tester) async {
    final widget = FastAutocomplete<String>(
      name: 'autocomplete',
      helperText: 'helper',
      labelText: 'label',
      options: options,
    );

    await tester.pumpWidget(buildMaterialTestApp(widget));

    expect(find.byType(typeOf<FastAutocomplete<String>>()), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    expect(find.text(widget.helperText!), findsOneWidget);
    expect(find.text(widget.labelText!), findsOneWidget);
  });

  testWidgets('shows FastAutocomplete options', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastAutocomplete<String>(name: 'autocomplete', options: options),
    ));

    final text = options.last;

    await tester.enterText(find.byType(TextFormField), text);
    await tester.pumpAndSettle();

    expect(find.text(text), findsNWidgets(2));
  });

  testWidgets('updates FastAutocomplete', (WidgetTester tester) async {
    final spy = OnChangedSpy<String>();

    await tester.pumpWidget(buildMaterialTestApp(
      FastAutocomplete<String>(
        name: 'autocomplete',
        options: options,
        onChanged: spy.fn,
      ),
    ));

    final state = tester.state(find.byType(typeOf<FastAutocomplete<String>>()))
        as FastAutocompleteState<String>;
    expect(state.value, state.widget.initialValue);

    final testValue = options.first;

    await tester.enterText(find.byType(TextFormField), testValue);
    await tester.pumpAndSettle();

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });
}
