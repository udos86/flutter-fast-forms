import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'test_utils.dart';

void main() {
  testWidgets('registers FastFormField', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        initialValue: 'Hello Test',
      ),
    ));

    final state =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;
    final store = Provider.of<FastFormStore>(state.context, listen: false);

    expect(store.values.containsKey(state.widget.id), true);
    expect(store.values.containsValue(state.widget.initialValue), true);
  });

  testWidgets('unregisters FastFormField', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastTextField(
        id: 'text_field',
        initialValue: 'Hello Test',
      ),
    ));

    final state =
        tester.state(find.byType(FastTextField)) as FastTextFieldState;
    final store = Provider.of<FastFormStore>(state.context, listen: false);

    store.unregister(state.widget.id);

    expect(store.values.containsKey(state.widget.id), false);
    expect(store.values.containsValue(state.widget.initialValue), false);
  });
}
