import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('required', () {
    String errorTextFn(_value) => 'error text';
    final validator = Validators.required(errorTextFn);

    expect(validator(42), null);
    expect(validator('test'), null);

    expect(validator(null), errorTextFn(null));
    expect(validator(''), errorTextFn(''));
    expect(validator({}), errorTextFn({}));
    expect(validator([]), errorTextFn([]));
  });

  test('requiredTrue', () {
    String errorTextFn(_value) => 'error text';
    final validator = Validators.requiredTrue(errorTextFn);

    expect(validator(true), null);

    expect(validator(false), errorTextFn(false));
    expect(validator(null), errorTextFn(null));
  });

  test('pattern', () {
    const pattern = "^test\$";
    String errorTextFn(_value, _pattern) => 'error text';
    final validator = Validators.pattern(pattern, errorTextFn);

    expect(validator('test'), null);
    expect(validator(''), null);
    expect(validator(null), null);

    expect(validator('abc'), errorTextFn('abc', pattern));
  });

  test('maxLength', () {
    const maxLength = 4;
    String errorTextFn(_value, _maxLength) => 'error text';
    final validator = Validators.maxLength(maxLength, errorTextFn);

    expect(validator('test'), null);
    expect(validator('abc'), null);
    expect(validator(''), null);
    expect(validator([]), null);
    expect(validator([1, 2, 3, 4]), null);
    expect(validator(null), null);

    expect(validator('testtest'), errorTextFn('testtest', maxLength));
    expect(validator([1, 2, 3, 4, 5]), errorTextFn([1, 2, 3, 4, 5], maxLength));
  });

  test('minLength', () {
    const minLength = 4;
    String errorTextFn(_value, _minLength) => 'error text';
    final validator = Validators.minLength(minLength, errorTextFn);

    expect(validator('test'), null);
    expect(validator(null), null);

    expect(validator('abc'), errorTextFn('abc', minLength));
    expect(validator(''), errorTextFn('', minLength));
    expect(validator([]), errorTextFn([], minLength));
    expect(validator([1, 2, 3]), errorTextFn([1, 2, 3], minLength));
  });

  test('max', () {
    const max = 4;
    String errorTextFn(_value, _max) => 'error text';
    final validator = Validators.max(max, errorTextFn);

    expect(validator(max - 1), null);
    expect(validator(max + 1), errorTextFn(max + 1, max));
    expect(validator(null), null);
  });

  test('min', () {
    const min = 4;
    String errorTextFn(_value, _min) => 'error text';
    final validator = Validators.min(min, errorTextFn);

    expect(validator(min + 1), null);

    expect(validator(min - 1), errorTextFn(min - 1, min));
    expect(validator(null), null);
  });

  test('compose', () {
    const minLength = 4;
    String errorTextRequiredFn(_value) => 'error text required';
    String errorTextMinLengthFn(_value, _minLength) => 'error text minLength';
    final validator = Validators.compose([
      Validators.required(errorTextRequiredFn),
      Validators.minLength(minLength, errorTextMinLengthFn),
    ]);

    expect(validator('test'), null);
    expect(validator([1, 2, 3, 4]), null);

    expect(validator('abc'), errorTextMinLengthFn('abc', minLength));
    expect(validator([1, 2, 3]), errorTextMinLengthFn([1, 2, 3], minLength));
    expect(validator(null), errorTextRequiredFn(null));
  });
}
