import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('required', () {
    String? errorTextBuilder1(String? _value) => 'error text';
    final validator1 = Validators.required<String>(errorTextBuilder1);

    expect(validator1('test'), null);
    expect(validator1(''), errorTextBuilder1(''));
    expect(validator1(null), errorTextBuilder1(null));

    String? errorTextBuilder2(Iterable? _value) => 'error text';
    final validator2 = Validators.required<Iterable>(errorTextBuilder2);

    expect(validator2([]), errorTextBuilder2([]));
    expect(validator2({}), errorTextBuilder2({}));
  });

  test('requiredTrue', () {
    String? errorTextBuilder(bool? _value) => 'error text';
    final validator = Validators.requiredTrue(errorTextBuilder);

    expect(validator(true), null);
    expect(validator(false), errorTextBuilder(false));
    expect(validator(null), errorTextBuilder(null));
  });

  test('pattern', () {
    const pattern = "^test\$";
    String? errorTextBuilder(String? _value, Pattern _pattern) => 'error text';
    final validator = Validators.pattern(pattern, errorTextBuilder);

    expect(validator('test'), null);
    expect(validator(''), null);
    expect(validator('abc'), errorTextBuilder('abc', pattern));
    expect(validator(null), null);
  });

  test('maxLength', () {
    const maxLength = 4;
    String? errorTextBuilder1(String? _value, int _maxLength) => 'error text';
    final validator1 =
        Validators.maxLength<String>(maxLength, errorTextBuilder1);

    expect(validator1('test'), null);
    expect(validator1('abc'), null);
    expect(validator1('testtest'), errorTextBuilder1('testtest', maxLength));
    expect(validator1(''), null);

    String? errorTextBuilder2(Iterable? _value, int _maxLength) => 'error text';
    final validator2 =
        Validators.maxLength<Iterable>(maxLength, errorTextBuilder2);

    expect(validator2([1, 2, 3, 4]), null);
    expect(validator2([]), null);
    expect(validator2([1, 2, 3, 4, 5]),
        errorTextBuilder2([1, 2, 3, 4, 5], maxLength));
    expect(validator2(null), null);
  });

  test('minLength', () {
    const minLength = 4;
    String? errorTextBuilder1(String? _value, int _minLength) => 'error text';
    final validator1 =
        Validators.minLength<String>(minLength, errorTextBuilder1);

    expect(validator1('test'), null);
    expect(validator1('abc'), errorTextBuilder1('abc', minLength));
    expect(validator1(''), errorTextBuilder1('', minLength));
    expect(validator1(null), null);

    String? errorTextBuilder2(Iterable? _value, int _minLength) => 'error text';
    final validator2 =
        Validators.minLength<Iterable>(minLength, errorTextBuilder2);

    expect(validator2([]), errorTextBuilder2([], minLength));
    expect(validator2([1, 2, 3]), errorTextBuilder2([1, 2, 3], minLength));
  });

  test('max', () {
    const max = 4;
    String? errorTextBuilder(num? _value, num _max) => 'error text';
    final validator = Validators.max(max, errorTextBuilder);

    expect(validator(max - 1), null);
    expect(validator(max + 1), errorTextBuilder(max + 1, max));
    expect(validator(null), null);
  });

  test('min', () {
    const min = 4;
    String? errorTextBuilder(num? _value, num _min) => 'error text';
    final validator = Validators.min(min, errorTextBuilder);

    expect(validator(min + 1), null);
    expect(validator(min - 1), errorTextBuilder(min - 1, min));
    expect(validator(null), null);
  });

  test('compose', () {
    const minLength = 4;
    String? errorTextBuilderRequired(String? _value) => 'error text required';
    String? errorTextBuilderMinLength(String? _value, int _minLength) =>
        'error text minLength';
    final validator = Validators.compose<String>([
      Validators.required(errorTextBuilderRequired),
      Validators.minLength(minLength, errorTextBuilderMinLength),
    ]);

    expect(validator('test'), null);
    expect(validator('abc'), errorTextBuilderMinLength('abc', minLength));
    expect(validator(null), errorTextBuilderRequired(null));
  });
}
