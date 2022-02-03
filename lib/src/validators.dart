import 'package:flutter/material.dart';

typedef ErrorTextBuilder<T> = String? Function(T? value);

typedef ErrorTextBuilderWithConstraint<T, C> = String? Function(
    T? value, C constraint);

abstract class Validators {
  static FormFieldValidator<T> required<T>(
      ErrorTextBuilder<T> errorTextBuilder) {
    return (T? value) {
      final invalid = value == null ||
          (value is Iterable && value.isEmpty) ||
          (value is Map && value.isEmpty) ||
          (value is String && value.isEmpty);

      return invalid ? errorTextBuilder(value) : null;
    };
  }

  static FormFieldValidator<bool> requiredTrue(
      ErrorTextBuilder<bool> errorTextBuilder) {
    return (bool? value) => value != true ? errorTextBuilder(value) : null;
  }

  static FormFieldValidator<String?> pattern(Pattern pattern,
      ErrorTextBuilderWithConstraint<String, Pattern> errorTextBuilder) {
    return (String? value) {
      if (value != null && value.isNotEmpty) {
        final regex = pattern is String ? RegExp(pattern) : pattern as RegExp;
        if (!regex.hasMatch(value)) return errorTextBuilder(value, pattern);
      }
      return null;
    };
  }

  static FormFieldValidator<T> maxLength<T>(
      int maxLength, ErrorTextBuilderWithConstraint<T, int> errorTextBuilder) {
    return (T? value) {
      final invalid = (value is Iterable && value.length > maxLength) ||
          (value is Map && value.length > maxLength) ||
          (value is String && value.length > maxLength);

      return invalid ? errorTextBuilder(value, maxLength) : null;
    };
  }

  static FormFieldValidator<T> minLength<T>(
      int minLength, ErrorTextBuilderWithConstraint<T, int> errorTextBuilder) {
    return (T? value) {
      final invalid = (value is Iterable && value.length < minLength) ||
          (value is Map && value.length < minLength) ||
          (value is String && value.length < minLength);

      return invalid ? errorTextBuilder(value, minLength) : null;
    };
  }

  static FormFieldValidator<num> max(
      num max, ErrorTextBuilderWithConstraint<num, num> errorTextBuilder) {
    return (num? value) {
      return value != null && value > max ? errorTextBuilder(value, max) : null;
    };
  }

  static FormFieldValidator<num> min(
      num min, ErrorTextBuilderWithConstraint<num, num> errorTextBuilder) {
    return (num? value) {
      return value != null && value < min ? errorTextBuilder(value, min) : null;
    };
  }

  static FormFieldValidator<T> compose<T>(
      List<FormFieldValidator<T>> validators) {
    return (T? value) {
      for (var index = 0; index < validators.length; index++) {
        final result = validators[index](value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
