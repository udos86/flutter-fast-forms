import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

_findTestItem() => find.byType(TestItem);

class TestItem extends StatefulWidget {
  const TestItem(Key key, this.index, this.field) : super(key: key);

  final FastFormArrayState<int> field;
  final int index;

  @override
  State<TestItem> createState() => TestItemState();
}

class TestItemState extends State<TestItem> {
  late int counter;

  @override
  void initState() {
    super.initState();
    counter = widget.field.value?[widget.index] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          counter++;
          widget.field.didItemChange(widget.index, counter);
        });
      },
      child: Text('$counter'),
    );
  }
}

void main() {
  testWidgets('renders FastFormArray', (tester) async {
    const initialValue = [0, 10, 100];

    await tester.pumpWidget(buildMaterialTestApp(FastFormArray<int>(
      name: 'form_array',
      initialValue: initialValue,
      itemBuilder: (key, index, field) => TestItem(key, index, field),
    )));

    expect(findFastFormArray<int>(), findsOneWidget);
    expect(_findTestItem(), findsNWidgets(initialValue.length));
  });

  testWidgets('renders empty FastFormArray', (tester) async {
    const emptyText = 'Form array is empty';

    await tester.pumpWidget(buildMaterialTestApp(FastFormArray<int>(
      name: 'form_array',
      itemBuilder: (key, index, field) => TestItem(key, index, field),
      emptyBuilder: (field) => const Text(emptyText),
    )));

    expect(_findTestItem(), findsNothing);
    expect(tester.widget<Text>(find.byType(Text)).data, emptyText);
  });

  testWidgets('updates FastFormArray value', (tester) async {
    const initialValue = [0];

    await tester.pumpWidget(buildMaterialTestApp(FastFormArray<int>(
      name: 'form_array',
      initialValue: initialValue,
      itemBuilder: (key, index, field) => TestItem(key, index, field),
    )));

    final state =
        tester.state<FastFormArrayState<int>>(findFastFormArray<int>());
    expect(state.value, initialValue);

    await tester.tap(findTextButton().first);
    await tester.pumpAndSettle();
    expect(state.value, [initialValue.first + 1]);

    const testValue = 99;
    state.didItemChange(0, testValue);
    expect(state.value, [testValue]);
  });

  testWidgets('adds FastFormArray item', (tester) async {
    const initialValue = [0];

    await tester.pumpWidget(buildMaterialTestApp(FastFormArray<int>(
      name: 'form_array',
      initialValue: initialValue,
      itemBuilder: (key, index, field) => TestItem(key, index, field),
    )));

    final state =
        tester.state<FastFormArrayState<int>>(findFastFormArray<int>());
    const testValue = 42;
    state.add(testValue);

    await tester.pumpAndSettle();

    expect(state.value, [...initialValue, testValue]);
    expect(_findTestItem(), findsNWidgets(initialValue.length + 1));
  });

  testWidgets('inserts FastFormArray item', (tester) async {
    const initialValue = [0];

    await tester.pumpWidget(buildMaterialTestApp(FastFormArray<int>(
      name: 'form_array',
      initialValue: initialValue,
      itemBuilder: (key, index, field) => TestItem(key, index, field),
    )));

    final state =
        tester.state<FastFormArrayState<int>>(findFastFormArray<int>());
    const testValue = 42;
    state.insert(0, testValue);

    await tester.pumpAndSettle();

    expect(state.value, [testValue, ...initialValue]);
    expect(_findTestItem(), findsNWidgets(initialValue.length + 1));
  });

  testWidgets('removes FastFormArray item', (tester) async {
    const initialValue = [0, 42];

    await tester.pumpWidget(buildMaterialTestApp(FastFormArray<int>(
      name: 'form_array',
      initialValue: initialValue,
      itemBuilder: (key, index, field) => TestItem(key, index, field),
    )));

    final state =
        tester.state<FastFormArrayState<int>>(findFastFormArray<int>());
    final testIndex = initialValue.indexOf(initialValue.first);
    state.remove(testIndex);

    await tester.pumpAndSettle();

    expect(state.value, [...initialValue]..removeAt(testIndex));
    expect(_findTestItem(), findsNWidgets(initialValue.length - 1));
  });

  testWidgets('moves FastFormArray item', (tester) async {
    const initialValue = [0, 42, 99];

    await tester.pumpWidget(buildMaterialTestApp(FastFormArray<int>(
      name: 'form_array',
      reorderable: true,
      initialValue: initialValue,
      itemBuilder: (key, index, field) => TestItem(key, index, field),
    )));

    final state =
        tester.state<FastFormArrayState<int>>(findFastFormArray<int>());
    final testValue = initialValue.first;
    final oldIndex = initialValue.indexOf(testValue);
    final newIndex = oldIndex + 2;
    state.move(oldIndex, newIndex);

    await tester.pumpAndSettle();

    final newValue = [...initialValue]
      ..removeAt(oldIndex)
      ..insert(newIndex, testValue);

    expect(state.value, newValue);
    expect(_findTestItem(), findsNWidgets(initialValue.length));

    final itemState =
        tester.stateList<TestItemState>(_findTestItem()).elementAt(newIndex);
    expect(itemState.counter, testValue);
  });

  testWidgets('resets FastFormArray', (tester) async {
    final formKey = GlobalKey<FormState>();
    const initialValue = [0, 42, 99];

    await tester.pumpWidget(buildMaterialTestApp(
      FastFormArray<int>(
        name: 'form_array',
        initialValue: initialValue,
        itemBuilder: (key, index, field) => TestItem(key, index, field),
      ),
      formKey: formKey,
    ));

    final state =
        tester.state<FastFormArrayState<int>>(findFastFormArray<int>());
    const testValue = 1001;

    state.didItemChange(initialValue.indexOf(initialValue.first), testValue);
    state.remove(initialValue.indexOf(initialValue.last));

    await tester.pumpAndSettle();
    expect(_findTestItem(), findsNWidgets(state.value!.length));
    expect(state.value, [
      testValue,
      ...[...initialValue]
        ..remove(initialValue.first)
        ..remove(initialValue.last)
    ]);

    formKey.currentState?.reset();
    await tester.pumpAndSettle();
    expect(_findTestItem(), findsNWidgets(initialValue.length));
    expect(state.value, [...initialValue]);
  });
}
