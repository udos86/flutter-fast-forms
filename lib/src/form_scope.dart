import 'package:flutter/material.dart';

import 'form.dart';
import 'form_field.dart';

typedef BoxDecorator = BoxDecoration Function(
    BuildContext context, FastFormField field);

typedef FastInputDecorator = InputDecoration Function(
    BuildContext context, FastFormField field);

class FastFormScope extends InheritedWidget {
  const FastFormScope({
    Key? key,
    this.adaptive = false,
    required this.builders,
    required Widget child,
    required this.formState,
    required this.inputDecorator,
    this.padding,
  }) : super(key: key, child: child);

  final bool adaptive;
  final Map<Type, dynamic> builders;
  final FastFormState formState;
  final FastInputDecorator inputDecorator;
  final EdgeInsetsGeometry? padding;

  static FastFormScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FastFormScope>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
