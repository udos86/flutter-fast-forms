import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

typedef FastTestWidgetBuilder = Widget Function(Widget testWidget,
    {GlobalKey<FormState>? formKey});
typedef GenericTypeOf = Type Function<T>();

Type typeOf<T>() => T;

MaterialApp getFastTestWidget(Widget testWidget,
    {GlobalKey<FormState>? formKey}) {
  return MaterialApp(
    home: Scaffold(
      body: FastForm(
        formKey: formKey ?? GlobalKey<FormState>(),
        children: <Widget>[testWidget],
      ),
    ),
  );
}
