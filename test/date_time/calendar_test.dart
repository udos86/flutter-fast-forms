import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastCalendar', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(FastCalendar(
      name: 'calendar',
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    )));

    expect(findFastCalendar(), findsOneWidget);
    expect(findCalendarDatePicker(), findsOneWidget);
  });

  testWidgets('updates FastCalendar', (tester) async {
    final spy = OnChangedSpy<DateTime>();

    await tester.pumpWidget(buildMaterialTestApp(FastCalendar(
      name: 'calendar',
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onChanged: spy.fn,
    )));

    final state = tester.state<FastCalendarState>(findFastCalendar());
    expect(state.value, state.widget.initialValue);

    const day = 21;

    await tester.tap(find.text(day.toString()));
    await tester.pumpAndSettle();

    expect(spy.calledWith?.day, day);
    expect(state.value?.day, day);
  });

  testWidgets('validates FastCalendar', (tester) async {
    const invalidValue = 21;
    const errorText = 'Invalid day';

    await tester.pumpWidget(buildMaterialTestApp(FastCalendar(
      name: 'calendar',
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      validator: (value) => value?.day == invalidValue ? errorText : null,
    )));

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    final state = tester.state<FastCalendarState>(findFastCalendar());
    state.didChange(DateTime(2020, 12, invalidValue));
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
