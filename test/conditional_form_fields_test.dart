import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import './test_utils.dart';

void main() {
  late FastCheckbox fastCheckbox;
  late FastSwitch fastSwitch;
  late FastCondition checkboxCondition;
  late FastCondition switchCondition;

  const Map<FastConditionHandler, bool> cases = {
    FastCondition.disabled: false,
    FastCondition.enabled: true,
  };

  setUp(() {
    fastCheckbox = const FastCheckbox(
      name: 'checkbox',
      showInputDecoration: false,
    );

    fastSwitch = const FastSwitch(
      name: 'switch',
      showInputDecoration: false,
    );

    checkboxCondition = FastCondition(
      target: 'checkbox',
      test: (value, field) => value is bool && value,
    );

    switchCondition = FastCondition(
      target: 'switch',
      test: (value, field) => value is bool && value,
    );
  });

  for (var MapEntry(key: handler, value: enabled) in cases.entries) {
    final testCase = enabled ? 'enabled' : 'disabled';

    testWidgets('$testCase by single condition', (tester) async {
      await tester.pumpWidget(buildMaterialTestApp([
        fastSwitch,
        FastTextField(
          enabled: !enabled,
          name: 'text_field',
          conditions: {
            handler: FastConditionList([switchCondition]),
          },
        ),
      ]));

      final widget = tester.widget<FastTextField>(findFastTextField());
      final state = tester.state<FastTextFieldState>(findFastTextField());

      expect(state.enabled, widget.enabled);

      await tester.tap(findSwitchListTile());
      await tester.pumpAndSettle();

      expect(state.enabled, enabled);
    });

    testWidgets('$testCase by multiple conditions', (tester) async {
      await tester.pumpWidget(buildMaterialTestApp([
        fastCheckbox,
        fastSwitch,
        FastTextField(
          enabled: !enabled,
          name: 'text_field',
          conditions: {
            handler: FastConditionList([checkboxCondition, switchCondition]),
          },
        ),
      ]));

      final widget = tester.widget<FastTextField>(findFastTextField());
      final state = tester.state<FastTextFieldState>(findFastTextField());

      expect(state.enabled, widget.enabled);

      await tester.tap(findCheckboxListTile());
      await tester.pumpAndSettle();

      expect(state.enabled, enabled);

      state.enabled = widget.enabled;

      await tester.tap(findSwitchListTile());
      await tester.pumpAndSettle();

      expect(state.enabled, enabled);
    });

    testWidgets('$testCase by required condition', (tester) async {
      await tester.pumpWidget(buildMaterialTestApp([
        fastCheckbox,
        fastSwitch,
        FastTextField(
          enabled: !enabled,
          name: 'text_field',
          conditions: {
            handler: FastConditionList(
              [checkboxCondition, switchCondition],
              match: FastConditionMatch.every,
            ),
          },
        ),
      ]));

      final widget = tester.widget<FastTextField>(findFastTextField());
      final state = tester.state<FastTextFieldState>(findFastTextField());

      expect(state.enabled, widget.enabled);

      await tester.tap(findCheckboxListTile());
      await tester.pumpAndSettle();

      expect(state.enabled, widget.enabled);

      await tester.tap(findSwitchListTile());
      await tester.pumpAndSettle();

      expect(state.enabled, enabled);
    });
  }
}
