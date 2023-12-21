import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('renders FastFormSection', (tester) async {
    const header = Text('Test Form Section');

    await tester.pumpWidget(buildMaterialTestApp(const FastFormSection(
      header: header,
      children: [
        FastTextField(name: 'text_field'),
      ],
    )));

    expect(findFastFormSection(), findsOneWidget);
    expect(find.byWidget(header), findsOneWidget);
    expect(findFastTextField(), findsOneWidget);
  });

  testWidgets('renders FastFormSection horizontally', (tester) async {
    await tester.pumpWidget(buildMaterialTestApp(const FastFormSection(
      orientation: FastFormSectionOrientation.horizontal,
      children: [
        FastTextField(name: 'text_field'),
      ],
    )));

    expect(findFastFormSection(), findsOneWidget);
    expect(findRow(), findsOneWidget);
    expect(findExpanded(), findsOneWidget);
    expect(findFastTextField(), findsOneWidget);
  });

  testWidgets('renders CupertinoFormSection', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    const header = Text('Test Form Section');

    await tester.pumpWidget(buildMaterialTestApp(const FastFormSection(
      adaptive: true,
      header: header,
      children: [
        FastTextField(name: 'text_field'),
      ],
    )));

    expect(findCupertinoFormSection(), findsOneWidget);
    expect(find.byWidget(header), findsOneWidget);
    expect(findFastTextField(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('renders CupertinoFormSection.insetGrouped', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildMaterialTestApp(const FastFormSection(
      adaptive: true,
      insetGrouped: true,
      children: [
        FastTextField(name: 'text_field'),
      ],
    )));

    expect(findCupertinoFormSection(), findsOneWidget);
    expect(findFastTextField(), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
