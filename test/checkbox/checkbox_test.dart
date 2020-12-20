import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('FastCheckbox', (WidgetTester tester) async {
    final helper = 'helper';
    final label = 'label';
    final title = 'title';

    await tester.pumpWidget(
      Utils.wrapMaterial(
        FastCheckbox(
          id: 'checkbox',
          helper: helper,
          label: label,
          title: title,
        ),
      ),
    );

    final formFieldFinder = find.byType(CheckboxFormField);
    final helperFinder = find.text(helper);
    final labelFinder = find.text(label);
    final titleFinder = find.text(title);

    expect(formFieldFinder, findsOneWidget);
    expect(helperFinder, findsOneWidget);
    expect(labelFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
  });
}
