import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maskText', () {
    final mask = '+# (###) ###-##-##';
    final formatter = InputFormatters.maskText(mask);
    final text = '01234567890';

    expect(formatter.getMask(), mask);
    expect(formatter.maskText(text), '+0 (123) 456-78-90');
    expect(formatter.unmaskText(formatter.maskText(text)), text);
  });
}
