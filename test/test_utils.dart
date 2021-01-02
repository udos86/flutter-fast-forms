import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

typedef FastTestWidgetBuilder = Widget Function(Widget testWidget,
    [bool adaptive]);
typedef GenericTypeOf = Type Function<T>();

final GenericTypeOf typeOf = <T>() => T;

final FastTestWidgetBuilder getFastTestWidget =
    (Widget testWidget, [bool adaptive = false]) {
  return MaterialApp(
    home: Scaffold(
      body: FastForm(
        adaptive: adaptive,
        formKey: GlobalKey<FormState>(),
        children: <Widget>[testWidget],
      ),
    ),
  );
};
