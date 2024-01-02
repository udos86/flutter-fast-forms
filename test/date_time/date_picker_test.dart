import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDatePicker', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastDatePicker(
        name: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ]));

    expect(findFastDatePicker(), findsOneWidget);
    expect(findInkWell().first, findsOneWidget);
    expect(findIconButton(), findsOneWidget);
  });

  testWidgets('shows CalendarDatePicker on GestureDetector tap',
      (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastDatePicker(
        name: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ]));

    await tester.tap(findInkWell().first);
    await tester.pumpAndSettle();

    expect(find.byType(InputDatePickerFormField), findsOneWidget);
  });

  testWidgets('updates FastDatePicker', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      FastDatePicker(
        name: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ]));

    final state = tester.state<FastDatePickerState>(findFastDatePicker());
    expect(state.value, state.widget.initialValue);

    await tester.tap(findIconButton());
    await tester.pumpAndSettle();

    await tester.tap(findTextButton().last);
    await tester.pumpAndSettle();

    final datePickerText = datePickerTextBuilder(state);

    expect(find.text(datePickerText.data!), findsOneWidget);
  });

  testWidgets('validates FastDatePicker', (tester) async {
    const errorText = 'invalid date';
    final invalidDate = DateTime(1974);

    await tester.pumpWidget(buildMaterialTestApp([
      FastDatePicker(
        name: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        validator: (value) =>
            value?.year == invalidDate.year ? errorText : null,
      ),
    ]));

    final state = tester.state<FastDatePickerState>(findFastDatePicker());

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(invalidDate);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('adapts FastDatePicker to Android', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(buildMaterialTestApp([
      FastDatePicker(
        name: 'date_picker',
        adaptive: true,
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ]));

    expect(findIconButton(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('adapts FastDatePicker to iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildCupertinoTestApp([
      FastDatePicker(
        name: 'date_picker',
        adaptive: true,
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ]));

    expect(findCupertinoFormRow(), findsOneWidget);
    expect(findCupertinoDatePicker(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('shows CupertinoDatePicker in CupertinoModalPopup',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildCupertinoTestApp([
      FastDatePicker(
        name: 'date_picker',
        adaptive: true,
        showModalPopup: true,
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ]));

    expect(findFastDatePicker(), findsOneWidget);

    await tester.tap(find.byType(CupertinoButton).first);
    await tester.pumpAndSettle();

    expect(findCupertinoDatePicker(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
