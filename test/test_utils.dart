import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

typedef FastTestWidgetBuilder = Widget Function(Widget testWidget,
    {GlobalKey<FormState>? formKey});
typedef GenericTypeOf = Type Function<T>();

final GenericTypeOf typeOf = <T>() => T;

final FastTestWidgetBuilder getFastTestWidget =
    (Widget testWidget, {GlobalKey<FormState>? formKey}) {
  return MaterialApp(
    home: Scaffold(
      body: FastForm(
        formKey: formKey ?? GlobalKey<FormState>(),
        children: <Widget>[testWidget],
      ),
    ),
  );
};
