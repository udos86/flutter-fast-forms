import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastTimePicker', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      const FastTimePicker(name: 'time_picker'),
    ]));

    expect(findFastTimePicker(), findsOneWidget);
    expect(findIconButton(), findsOneWidget);

    final inkWellFinder = findInkWell();
    expect(inkWellFinder.first, findsOneWidget);

    await tester.tap(inkWellFinder.first);
    await tester.pumpAndSettle();
  });

  testWidgets('updates FastTimePicker', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp([
      const FastTimePicker(name: 'time_picker'),
    ]));

    final state = tester.state<FastTimePickerState>(findFastTimePicker());
    expect(state.value, state.widget.initialValue);

    await tester.tap(findIconButton());
    await tester.pumpAndSettle();

    await tester.tap(findTextButton().last);
    await tester.pumpAndSettle();

    final timePickerText = timePickerTextBuilder(state);
    final timePickerTextFinder = find.text(timePickerText.data!);

    expect(timePickerTextFinder, findsOneWidget);
  });
}
