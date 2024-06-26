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
      (tester) async {
    expect(() => FastAutocomplete<String>(name: 'id'), throwsAssertionError);
  });

  testWidgets('renders FastAutocomplete', (tester) async {
    final widget = FastAutocomplete<String>(
      name: 'autocomplete',
      helperText: 'helper',
      labelText: 'label',
      options: options,
    );

    await tester.pumpWidget(buildMaterialTestApp([widget]));

    expect(findFastAutocomplete<String>(), findsOneWidget);
    expect(findTextFormField(), findsOneWidget);

    expect(find.text(widget.helperText!), findsOneWidget);
    expect(find.text(widget.labelText!), findsOneWidget);
  });

  testWidgets('shows FastAutocomplete options', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastAutocomplete<String>(
        name: 'autocomplete',
        options: options,
      ),
    ]));

    final text = options.last;

    await tester.enterText(findTextFormField(), text);
    await tester.pumpAndSettle();

    expect(find.text(text), findsNWidgets(2));
  });

  testWidgets('updates FastAutocomplete', (tester) async {
    final spy = OnChangedSpy<String>();

    await tester.pumpWidget(buildMaterialTestApp([
      FastAutocomplete<String>(
        name: 'autocomplete',
        options: options,
        onChanged: spy.fn,
      ),
    ]));

    final state = tester
        .state<FastAutocompleteState<String>>(findFastAutocomplete<String>());
    expect(state.value, state.widget.initialValue);

    final testValue = options.first;

    await tester.enterText(findTextFormField(), testValue);
    await tester.pumpAndSettle();

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('updates touched state', (tester) async {
    final spy = VoidCallbackSpy();

    await tester.pumpWidget(buildMaterialTestApp([
      FastAutocomplete<String>(
        name: 'autocomplete',
        options: options,
        onTouched: spy.fn,
      ),
    ]));

    final autocompleteFinder = findFastAutocomplete<String>();
    final textFieldFinder =
        find.descendant(of: autocompleteFinder, matching: findTextFormField());
    final state =
        tester.state<FastAutocompleteState<String>>(autocompleteFinder);

    expect(state.status.touched, false);

    await tester.tap(textFieldFinder);
    state.autocompleteFocusNode?.unfocus();
    await tester.pumpAndSettle();

    expect(spy.called, true);
    expect(state.status.touched, true);
  });
}
