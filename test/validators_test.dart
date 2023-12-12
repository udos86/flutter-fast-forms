import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String? staticErrorText<T>(T? value) => 'error text';
  String? dynamicErrorText<T, C>(T? value, C constraint) =>
      'error text with $constraint';

  test('required', () {
    final validator = Validators.required(staticErrorText);

    expect(validator('test'), null);
    expect(validator(''), staticErrorText(''));
    expect(validator(null), staticErrorText(null));
    expect(validator([]), staticErrorText([]));
    expect(validator({}), staticErrorText({}));
  });

  test('requiredTrue', () {
    final validator = Validators.requiredTrue(staticErrorText);

    expect(validator(true), null);
    expect(validator(false), staticErrorText(false));
    expect(validator(null), staticErrorText(null));
  });

  test('pattern', () {
    const pattern = "^test\$";
    final validator = Validators.pattern(pattern, dynamicErrorText);

    expect(validator('test'), null);
    expect(validator(''), null);
    expect(validator('abc'), dynamicErrorText('abc', pattern));
    expect(validator(null), null);
  });

  test('max', () {
    const max = 4;
    final validator = Validators.max(max, dynamicErrorText);

    expect(validator(max - 1), null);
    expect(validator(max + 1), dynamicErrorText(max + 1, max));
    expect(validator(null), null);
  });

  test('min', () {
    const min = 4;
    final validator = Validators.min(min, dynamicErrorText);

    expect(validator(min + 1), null);
    expect(validator(min - 1), dynamicErrorText(min - 1, min));
    expect(validator(null), null);
  });

  group('minLength / maxLength', () {
    const cases = [
      [
        [1, 2, 3, 4],
        [1, 2, 3],
        [],
      ],
      [
        {'k1': 1, 'k2': 2, 'k3': 3, 'k4': 4},
        {'k1': 1, 'k2': 2, 'k3': 3},
        {},
      ],
      [
        'test',
        'abc',
        '',
      ]
    ];

    test('minLength', () {
      const minLength = 4;

      for (var [length4, length3, empty] in cases) {
        final validator = Validators.minLength(minLength, dynamicErrorText);

        expect(validator(length4), null);
        expect(validator(length3), dynamicErrorText(length3, minLength));
        expect(validator(empty), dynamicErrorText(empty, minLength));
        expect(validator(null), null);
      }
    });

    test('maxLength', () {
      const maxLength = 3;

      for (var [length4, length3, empty] in cases) {
        final validator = Validators.maxLength(maxLength, dynamicErrorText);

        expect(validator(length4), dynamicErrorText(length4, maxLength));
        expect(validator(length3), null);
        expect(validator(empty), null);
        expect(validator(null), null);
      }
    });
  });

  test('compose', () {
    const minLength = 4;

    String? errorTextRequired(String? value) => 'value is required';
    String? errorTextMinLength(String? value, int minLength) =>
        'value requires a minimum length of $minLength';

    final validator = Validators.compose([
      Validators.required(errorTextRequired),
      Validators.minLength(minLength, errorTextMinLength),
    ]);

    expect(validator('test'), null);
    expect(validator('abc'), errorTextMinLength('abc', minLength));
    expect(validator(null), errorTextRequired(null));
  });
}
