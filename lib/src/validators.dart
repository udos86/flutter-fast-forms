import 'package:flutter/material.dart';

typedef ErrorTextBuilder<T> = String? Function(T? value);

typedef ErrorTextBuilderWithConstraint<T, C> = String? Function(
    T? value, C constraint);

/// Returns a [FormFieldValidator] validating if the value of a
/// [FormFieldState] is null or empty.
abstract class Validators {
  static FormFieldValidator<T> required<T>(
      ErrorTextBuilder<T> errorTextBuilder) {
    return (T? value) {
      switch (value) {
        case null:
        case Iterable(isEmpty: var isEmpty) ||
                Map(isEmpty: var isEmpty) ||
                String(isEmpty: var isEmpty)
            when isEmpty:
          return errorTextBuilder(value);
        default:
          return null;
      }
    };
  }

  /// Returns a [FormFieldValidator] validating if the [bool] value of a
  /// [FormFieldState] is true.
  ///
  /// Typically used in conjunction with form fields that are either checked or
  /// unchecked.
  static FormFieldValidator<bool> requiredTrue(
      ErrorTextBuilder<bool> errorTextBuilder) {
    return (bool? value) => value == true ? null : errorTextBuilder(value);
  }

  /// Returns a [FormFieldValidator] validating if the [String] value of a
  /// [FormFieldState] matches a certain [pattern].
  ///
  /// Does not return an error when the [String] value of [FormFieldState] is
  /// null or empty.
  static FormFieldValidator<String?> pattern(Pattern pattern,
      ErrorTextBuilderWithConstraint<String, Pattern> errorTextBuilder) {
    return (String? value) {
      if (value case String(isNotEmpty: var isNotEmpty) when isNotEmpty) {
        final regex = pattern is String ? RegExp(pattern) : pattern as RegExp;
        if (!regex.hasMatch(value)) return errorTextBuilder(value, pattern);
      }
      return null;
    };
  }

  /// Returns a [FormFieldValidator] validating if the value of a
  /// [FormFieldState] exceeds a maximum length of [maxLength].
  ///
  /// Does not return an error when the value of [FormFieldState] is null.
  static FormFieldValidator<T> maxLength<T>(
      int maxLength, ErrorTextBuilderWithConstraint<T, int> errorTextBuilder) {
    return (T? value) {
      switch (value) {
        case Iterable(length: var length) ||
                Map(length: var length) ||
                String(length: var length)
            when length > maxLength:
          return errorTextBuilder(value, maxLength);
        default:
          return null;
      }
    };
  }

  /// Returns a [FormFieldValidator] validating if the value of a
  /// [FormFieldState] has a minimum length of [minLength].
  ///
  /// Does not return an error when the value of [FormFieldState] is null.
  static FormFieldValidator<T> minLength<T>(
      int minLength, ErrorTextBuilderWithConstraint<T, int> errorTextBuilder) {
    return (T? value) {
      switch (value) {
        case Iterable(length: var length) ||
                Map(length: var length) ||
                String(length: var length)
            when length < minLength:
          return errorTextBuilder(value, minLength);
        default:
          return null;
      }
    };
  }

  /// Returns a [FormFieldValidator] validating if the [num] value of a
  /// [FormFieldState] is bigger than [max].
  ///
  /// Does not return an error when the value of the [FormFieldState] is null.
  static FormFieldValidator<num> max(
      num max, ErrorTextBuilderWithConstraint<num, num> errorTextBuilder) {
    return (num? value) {
      return value is num && value > max ? errorTextBuilder(value, max) : null;
    };
  }

  /// Returns a [FormFieldValidator] validating if the [num] value of a
  /// [FormFieldState] is smaller than [min].
  ///
  /// Does not return an error when the value of the [FormFieldState] is null.
  static FormFieldValidator<num> min(
      num min, ErrorTextBuilderWithConstraint<num, num> errorTextBuilder) {
    return (num? value) {
      return value is num && value < min ? errorTextBuilder(value, min) : null;
    };
  }

  /// Returns a [FormFieldValidator] that merges a list of [FormFieldValidator].
  static FormFieldValidator<T> compose<T>(
      List<FormFieldValidator<T>> validators) {
    return (T? value) {
      for (var index = 0; index < validators.length; index++) {
        final result = validators[index](value);
        if (result is String) return result;
      }
      return null;
    };
  }
}
