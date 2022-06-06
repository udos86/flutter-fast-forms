import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

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
  testWidgets('renders FastFormArray', (WidgetTester tester) async {
    const initialValue = [0, 10, 100];

    await tester.pumpWidget(buildMaterialTestApp(
      FastFormArray<int>(
        name: 'form_array',
        initialValue: initialValue,
        itemBuilder: (key, index, field) => TestItem(key, index, field),
      ),
    ));

    expect(find.byType(typeOf<FastFormArray<int>>()), findsOneWidget);
    expect(find.byType(TestItem), findsNWidgets(initialValue.length));
  });

  testWidgets('renders empty FastFormArray', (WidgetTester tester) async {
    const emptyText = 'Form array is empty';

    await tester.pumpWidget(buildMaterialTestApp(
      FastFormArray<int>(
        name: 'form_array',
        itemBuilder: (key, index, field) => TestItem(key, index, field),
        emptyBuilder: (field) => const Text(emptyText),
      ),
    ));

    expect(find.byType(TestItem), findsNothing);
    expect(tester.widget<Text>(find.byType(Text)).data, emptyText);
  });

  testWidgets('updates FastFormArray value', (WidgetTester tester) async {
    const initialValue = [0];

    await tester.pumpWidget(buildMaterialTestApp(
      FastFormArray<int>(
        name: 'form_array',
        initialValue: initialValue,
        itemBuilder: (key, index, field) => TestItem(key, index, field),
      ),
    ));

    final state = tester.state<FastFormArrayState<int>>(
        find.byType(typeOf<FastFormArray<int>>()));
    expect(state.value, initialValue);

    await tester.tap(find.byType(TextButton).first);
    await tester.pumpAndSettle();
    expect(state.value, [initialValue.first + 1]);

    const testValue = 99;
    state.didItemChange(0, testValue);
    expect(state.value, [testValue]);
  });

  testWidgets('adds FastFormArray item', (WidgetTester tester) async {
    const initialValue = [0];

    await tester.pumpWidget(buildMaterialTestApp(
      FastFormArray<int>(
        name: 'form_array',
        initialValue: initialValue,
        itemBuilder: (key, index, field) => TestItem(key, index, field),
      ),
    ));

    final state = tester.state<FastFormArrayState<int>>(
        find.byType(typeOf<FastFormArray<int>>()));
    const testValue = 42;
    state.add(testValue);

    await tester.pumpAndSettle();

    expect(state.value, [...initialValue, testValue]);
    expect(find.byType(TestItem), findsNWidgets(initialValue.length + 1));
  });

  testWidgets('inserts FastFormArray item', (WidgetTester tester) async {
    const initialValue = [0];

    await tester.pumpWidget(buildMaterialTestApp(
      FastFormArray<int>(
        name: 'form_array',
        initialValue: initialValue,
        itemBuilder: (key, index, field) => TestItem(key, index, field),
      ),
    ));

    final state = tester.state<FastFormArrayState<int>>(
        find.byType(typeOf<FastFormArray<int>>()));
    const testValue = 42;
    state.insert(0, testValue);

    await tester.pumpAndSettle();

    expect(state.value, [testValue, ...initialValue]);
    expect(find.byType(TestItem), findsNWidgets(initialValue.length + 1));
  });

  testWidgets('removes FastFormArray item', (WidgetTester tester) async {
    const initialValue = [0, 42];

    await tester.pumpWidget(buildMaterialTestApp(
      FastFormArray<int>(
        name: 'form_array',
        initialValue: initialValue,
        itemBuilder: (key, index, field) => TestItem(key, index, field),
      ),
    ));

    final state = tester.state<FastFormArrayState<int>>(
        find.byType(typeOf<FastFormArray<int>>()));
    final testIndex = initialValue.indexOf(initialValue.first);
    state.remove(testIndex);

    await tester.pumpAndSettle();

    expect(state.value, [...initialValue]..removeAt(testIndex));
    expect(find.byType(TestItem), findsNWidgets(initialValue.length - 1));
  });

  testWidgets('moves FastFormArray item', (WidgetTester tester) async {
    const initialValue = [0, 42, 99];

    await tester.pumpWidget(buildMaterialTestApp(
      FastFormArray<int>(
        name: 'form_array',
        builder: reorderableFormArrayBuilder,
        initialValue: initialValue,
        itemBuilder: (key, index, field) => TestItem(key, index, field),
      ),
    ));

    final state = tester.state<FastFormArrayState<int>>(
        find.byType(typeOf<FastFormArray<int>>()));
    final testValue = initialValue.first;
    final oldIndex = initialValue.indexOf(testValue);
    final newIndex = oldIndex + 2;
    state.move(oldIndex, newIndex);

    await tester.pumpAndSettle();

    final newValue = [...initialValue]
      ..removeAt(oldIndex)
      ..insert(newIndex, testValue);

    expect(state.value, newValue);
    expect(find.byType(TestItem), findsNWidgets(initialValue.length));

    final itemState = tester
        .stateList<TestItemState>(find.byType(TestItem))
        .elementAt(newIndex);
    expect(itemState.counter, testValue);
  });
}
