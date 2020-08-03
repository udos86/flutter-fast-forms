import 'package:flutter/material.dart';

abstract class Validators {
  static FormFieldValidator required([errorText = 'Field is required']) {
    return (value) {
      final hasLength = value is Iterable || value is String || value is Map;
      if (value == null || (hasLength && value.length == 0)) {
        return errorText;
      }
      return null;
    };
  }

  static FormFieldValidator minLength(int minLength, [String errorText]) {
    return (value) {
      final length = value?.length ?? 0;
      if (length < minLength) {
        return errorText ?? 'Field length must be at least $minLength';
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
