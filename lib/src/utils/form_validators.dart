import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

abstract class Validators {
  static FormFieldValidator required(
      [errorText = 'Field is required']) {
    return (value) {
      final hasLength = value is Iterable || value is String || value is Map;
      if (value == null || (hasLength && value.length == 0)) {
        return errorText;
      }
      return null;
    };
  }

  static FormFieldValidator requiredTrue(
      [String errorText = 'Field is required']) {
    return (value) => value != true ? errorText : null;
  }

  static FormFieldValidator pattern(Pattern pattern,
      [String errorText = 'Field does not match pattern']) {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (!RegExp(pattern).hasMatch(value)) return errorText;
      }
      return null;
    };
  }

  static FormFieldValidator maxLength(num maxLength,
      [String errorText]) {
    return (value) {
      if (value != null && value.length > maxLength) {
        return errorText ??
            'Value must have a length less than or equal to $maxLength';
      }
      return null;
    };
  }

  static FormFieldValidator minLength(int minLength,
      [String errorText]) {
    return (value) {
      if ((value?.length ?? 0) < minLength) {
        return errorText ?? 'Field must be at least $minLength';
      }
      return null;
    };
  }

  static FormFieldValidator max(num max, [String errorText]) {
    return (value) {
      final _value = value is num ? value : num.tryParse(value);
      if (_value != null && _value > max) {
        return errorText ?? 'Value must be less than or equal to $max';
      }
      return null;
    };
  }

  static FormFieldValidator min(num min, [String errorText]) {
    return (value) {
      final _value = value is num ? value : num.tryParse(value);
      if (value != null && _value < min) {
        return errorText ?? 'Field must be at least $min';
      }
      return null;
    };
  }

  static FormFieldValidator email(
      [String errorText = 'Field must contain a valid email address']) {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (!isEmail(value.trim())) return errorText;
      }
      return null;
    };
  }

  static FormFieldValidator compose(
      List<FormFieldValidator> validators) {
    return (value) {
      for (var index = 0; index < validators.length; index++) {
        final result = validators[index](value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
