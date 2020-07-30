import 'package:flutter/material.dart';

@immutable
class FormFieldOption<T> {
  FormFieldOption({
    @required this.title,
    @required this.value,
  });

  final T value;
  final String title;

  static List<FormFieldOption> map(List<String> items) {
    return items.map((item) {
      return FormFieldOption(
        title: item,
        value: item.toLowerCase(),
      );
    }).toList();
  }
}
