import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

typedef ErrorTextFn = String Function(dynamic value);
typedef ErrorTextWithArgumentFn = String Function(
    dynamic value, dynamic argument);

abstract class Validators {
  static FormFieldValidator required(ErrorTextFn errorTextFn) {
    return (value) {
      final hasLength = value is Iterable || value is String || value is Map;
      if (value == null || (hasLength && value.length == 0)) {
        return errorTextFn(value);
      }
      return null;
    };
  }

  static FormFieldValidator requiredTrue(ErrorTextFn errorTextFn) {
    return (value) => value != true ? errorTextFn(value) : null;
  }

  static FormFieldValidator pattern(
      Pattern pattern, ErrorTextWithArgumentFn errorTextFn) {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (!RegExp(pattern).hasMatch(value))
          return errorTextFn(value, pattern);
      }
      return null;
    };
  }

  static FormFieldValidator maxLength(
      num maxLength, ErrorTextWithArgumentFn errorTextFn) {
    return (value) {
      if (value != null && value.length > maxLength) {
        return errorTextFn(value, maxLength);
      }
      return null;
    };
  }

  static FormFieldValidator minLength(
      int minLength, ErrorTextWithArgumentFn errorTextFn) {
    return (value) {
      if ((value?.length ?? 0) < minLength) {
        return errorTextFn(value, minLength);
      }
      return null;
    };
  }

  static FormFieldValidator max(num max, ErrorTextWithArgumentFn errorTextFn) {
    return (value) {
      final _value = value is num ? value : num.tryParse(value);
      if (_value != null && _value > max) {
        return errorTextFn(value, max);
      }
      return null;
    };
  }

  static FormFieldValidator min(num min, ErrorTextWithArgumentFn errorTextFn) {
    return (value) {
      final _value = value is num ? value : num.tryParse(value);
      if (_value != null && _value < min) {
        return errorTextFn(value, min);
      }
      return null;
    };
  }

  static FormFieldValidator email(ErrorTextFn errorTextFn) {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (!isEmail(value.trim())) return errorTextFn(value);
      }
      return null;
    };
  }

  static FormFieldValidator compose(List<FormFieldValidator> validators) {
    return (value) {
      for (var index = 0; index < validators.length; index++) {
        final result = validators[index](value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
