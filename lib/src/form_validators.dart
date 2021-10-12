import 'package:flutter/material.dart';

typedef ErrorTexter = String Function(dynamic value);
typedef ErrorTexterWithConstraint = String Function(
    dynamic value, dynamic constraint);

abstract class Validators {
  static FormFieldValidator<dynamic> required(ErrorTexter errorTexter) {
    return (dynamic value) {
      final hasLength = value is Iterable || value is String || value is Map;
      if (value == null || (hasLength && value.length == 0)) {
        return errorTexter(value);
      }
      return null;
    };
  }

  static FormFieldValidator<bool> requiredTrue(ErrorTexter errorTexter) {
    return (bool? value) => value != true ? errorTexter(value) : null;
  }

  static FormFieldValidator<String?> pattern(
      Pattern pattern, ErrorTexterWithConstraint errorTexter) {
    return (String? value) {
      if (value != null && value.isNotEmpty) {
        final regex = pattern is String ? RegExp(pattern) : pattern as RegExp;
        if (!regex.hasMatch(value)) return errorTexter(value, pattern);
      }
      return null;
    };
  }

  static FormFieldValidator<dynamic> maxLength(
      num maxLength, ErrorTexterWithConstraint errorTexter) {
    return (dynamic value) {
      final hasLength = value is String || value is Map || value is Iterable;
      if (value != null && hasLength && value.length > maxLength) {
        return errorTexter(value, maxLength);
      }
      return null;
    };
  }

  static FormFieldValidator<dynamic> minLength(
      int minLength, ErrorTexterWithConstraint errorTexter) {
    return (dynamic value) {
      final hasLength = value is String || value is Map || value is Iterable;
      if (value != null && hasLength && value.length < minLength) {
        return errorTexter(value, minLength);
      }
      return null;
    };
  }

  static FormFieldValidator<num> max(
      num max, ErrorTexterWithConstraint errorTexter) {
    return (num? value) {
      if (value != null && value > max) {
        return errorTexter(value, max);
      }
      return null;
    };
  }

  static FormFieldValidator<num> min(
      num min, ErrorTexterWithConstraint errorTexter) {
    return (num? value) {
      if (value != null && value < min) {
        return errorTexter(value, min);
      }
      return null;
    };
  }

  static FormFieldValidator<dynamic> compose(
      List<FormFieldValidator> validators) {
    return (dynamic value) {
      for (var index = 0; index < validators.length; index++) {
        final result = validators[index](value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
