import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('required', () {
    final errorText = 'error text';
    final validator = Validators.required(errorText);

    expect(validator(42), null);
    expect(validator('test'), null);

    expect(validator(null), errorText);
    expect(validator(''), errorText);
    expect(validator({}), errorText);
    expect(validator([]), errorText);
  });

  test('requiredTrue', () {
    final errorText = 'error text';
    final validator = Validators.requiredTrue(errorText);

    expect(validator(true), null);

    expect(validator(false), errorText);
    expect(validator(null), errorText);
    expect(validator(42), errorText);
    expect(validator(''), errorText);
  });

  test('pattern', () {
    final errorText = 'error text';
    final validator = Validators.pattern("^test\$", errorText);

    expect(validator('test'), null);
    expect(validator(''), null);
    expect(validator(null), null);

    expect(validator('abc'), errorText);
  });

  test('maxLength', () {
    final errorText = 'error text';
    final validator = Validators.maxLength(4, errorText);

    expect(validator('test'), null);
    expect(validator('abc'), null);
    expect(validator(''), null);
    expect(validator([]), null);
    expect(validator([1, 2, 3, 4]), null);
    expect(validator(null), null);

    expect(validator('testtest'), errorText);
    expect(validator([1, 2, 3, 4, 5]), errorText);
  });

  test('minLength', () {
    final errorText = 'error text';
    final validator = Validators.minLength(4, errorText);

    expect(validator('test'), null);

    expect(validator('abc'), errorText);
    expect(validator(''), errorText);
    expect(validator([]), errorText);
    expect(validator([1, 2, 3]), errorText);
    expect(validator(null), errorText);
  });

  test('max', () {
    final max = 4;
    final errorText = 'error text';
    final validator = Validators.max(max, errorText);

    expect(validator(max - 1), null);
    expect(validator((max - 1).toString()), null);

    expect(validator(max + 1), errorText);
    expect(validator((max + 1).toString()), errorText);
    expect(() => validator(null), throwsNoSuchMethodError);
  });

  test('min', () {
    final min = 4;
    final errorText = 'error text';
    final validator = Validators.min(min, errorText);

    expect(validator(min + 1), null);
    expect(validator((min + 1).toString()), null);

    expect(validator(min - 1), errorText);
    expect(validator((min - 1).toString()), errorText);
    expect(() => validator(null), throwsNoSuchMethodError);
  });

  test('email', () {
    final errorText = 'error text';
    final validator = Validators.email(errorText);

    expect(validator('test@test.com'), null);

    expect(validator('test'), errorText);
    expect(validator('test@'), errorText);
    expect(validator('test@test'), errorText);
  });

  test('email', () {
    final errorTextRequired = 'error text required';
    final errorTextMinLength = 'error text minLength';
    final validator = Validators.compose([
      Validators.required(errorTextRequired),
      Validators.minLength(4, errorTextMinLength),
    ]);

    expect(validator('test'), null);
    expect(validator([1, 2, 3, 4]), null);

    expect(validator('abc'), errorTextMinLength);
    expect(validator([1, 2, 3]), errorTextMinLength);
    expect(validator(null), errorTextRequired);
  });
}
