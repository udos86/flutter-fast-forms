import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastRadioGroup widget', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastRadioGroup<String>(
        name: 'radio_group',
        options: const [
          FastRadioOption(title: Text('Option 1'), value: 'option-1'),
          FastRadioOption(title: Text('Option 2'), value: 'option-2'),
        ],
      ),
    ]));

    final fastRadioGroupFinder = findFastRadioGroup<String>();
    final widget = tester.widget<FastRadioGroup<String>>(fastRadioGroupFinder);

    expect(fastRadioGroupFinder, findsOneWidget);
    expect(findInputDecorator(), findsOneWidget);
    expect(findRadioListTile<String>(), findsNWidgets(widget.options.length));
  });

  testWidgets('renders FastRadioGroup widget without InputDecorator',
      (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastRadioGroup<String>(
        name: 'radio_group',
        options: const [
          FastRadioOption(title: Text('Option 1'), value: 'option-1'),
          FastRadioOption(title: Text('Option 2'), value: 'option-2'),
        ],
        showInputDecoration: false,
      ),
    ]));

    final fastRadioGroupFinder = findFastRadioGroup<String>();
    final widget = tester.widget<FastRadioGroup<String>>(fastRadioGroupFinder);

    expect(fastRadioGroupFinder, findsOneWidget);
    expect(findInputDecorator(), findsNothing);
    expect(findRadioListTile<String>(), findsNWidgets(widget.options.length));
  });

  testWidgets('renders FastRadioGroup widget horizontally', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastRadioGroup<String>(
        name: 'radio_group',
        options: const [
          FastRadioOption(title: Text('Option 1'), value: 'option-1'),
          FastRadioOption(title: Text('Option 2'), value: 'option-2'),
        ],
        orientation: FastRadioGroupOrientation.horizontal,
      ),
    ]));

    final widget =
        tester.widget<FastRadioGroup<String>>(findFastRadioGroup<String>());

    expect(findExpanded(), findsNWidgets(widget.options.length));
    expect(findRadioListTile<String>(), findsNWidgets(widget.options.length));
  });

  testWidgets('updates FastRadioGroup value', (tester) async {
    const options = [
      FastRadioOption(title: Text('Option 1'), value: 'option-1'),
      FastRadioOption(title: Text('Option 2'), value: 'option-2'),
    ];
    final spy = OnChangedSpy<String>();

    await tester.pumpWidget(buildMaterialTestApp([
      FastRadioGroup<String>(
        name: 'radio_group',
        options: options,
        onChanged: spy.fn,
      ),
    ]));

    final state =
        tester.state<FastRadioGroupState<String>>(findFastRadioGroup<String>());
    expect(state.value, options.first.value);

    await tester.tap(findRadioListTile<String>().last);
    await tester.pumpAndSettle();

    final testValue = options.last.value;

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('validates FastRadioGroup', (tester) async {
    const errorText = 'Do not touch this';
    const invalidOption = FastRadioOption(
      title: Text('Invalid Option'),
      value: 'invalid-option',
    );

    await tester.pumpWidget(buildMaterialTestApp([
      FastRadioGroup<String>(
        name: 'radio_group',
        options: const [
          FastRadioOption(title: Text('Option 1'), value: 'option-1'),
          invalidOption,
        ],
        validator: (value) => value == invalidOption.value ? errorText : null,
      ),
    ]));

    final state =
        tester.state<FastRadioGroupState<String>>(findFastRadioGroup<String>());

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(invalidOption.value);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
