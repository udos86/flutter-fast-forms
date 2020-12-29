import 'package:flutter/material.dart';

import 'form.dart';
import 'form_field.dart';

typedef BoxDecorator = BoxDecoration Function(
    BuildContext context, FastFormField field);

typedef FastInputDecorator = InputDecoration Function(
    BuildContext context, FastFormField field);

class FastFormScope extends InheritedWidget {
  FastFormScope({
    required Widget child,
    required this.formState,
    required this.inputDecorator,
    Key? key,
    this.padding = const EdgeInsets.all(12.0),
  }) : super(key: key, child: child);

  final FastFormState formState;
  final FastInputDecorator inputDecorator;
  final EdgeInsets padding;

  static FastFormScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FastFormScope>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
