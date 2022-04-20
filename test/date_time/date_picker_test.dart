import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDatePicker', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastDatePicker(
        name: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    expect(find.byType(FastDatePicker), findsOneWidget);
    expect(find.byType(InkWell).first, findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('shows CalendarDatePicker on GestureDetector tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastDatePicker(
        name: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.byType(InputDatePickerFormField), findsOneWidget);
  });

  testWidgets('updates FastDatePicker', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastDatePicker(
        name: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    final state =
        tester.state(find.byType(FastDatePicker)) as FastDatePickerState;
    expect(state.value, state.widget.initialValue);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    final datePickerText = datePickerTextBuilder(state);

    expect(find.text(datePickerText.data!), findsOneWidget);
  });

  testWidgets('validates FastDatePicker', (WidgetTester tester) async {
    const errorText = 'invalid date';
    final invalidDate = DateTime(1974);

    await tester.pumpWidget(buildMaterialTestApp(
      FastDatePicker(
        name: 'date_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        validator: (value) =>
            value?.year == invalidDate.year ? errorText : null,
      ),
    ));

    final state =
        tester.state(find.byType(FastDatePicker)) as FastDatePickerState;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(invalidDate);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('adapts FastDatePicker to Android', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(buildMaterialTestApp(
      FastDatePicker(
        name: 'date_picker',
        adaptive: true,
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    expect(find.byType(IconButton), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('adapts FastDatePicker to iOS', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildCupertinoTestApp(
      FastDatePicker(
        name: 'date_picker',
        adaptive: true,
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    expect(find.byType(CupertinoFormRow), findsOneWidget);
    expect(find.byType(CupertinoDatePicker), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('shows CupertinoDatePicker in CupertinoModalPopup',
      (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildCupertinoTestApp(
      FastDatePicker(
        name: 'date_picker',
        adaptive: true,
        showModalPopup: true,
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    ));

    expect(find.byType(FastDatePicker), findsOneWidget);

    await tester.tap(find.byType(CupertinoButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoDatePicker), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
