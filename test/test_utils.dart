import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:provider/provider.dart';

typedef FastTestWidgetBuilder = MaterialApp Function(Widget testWidget);
typedef GenericTypeExtracter = Type Function<T>();

final GenericTypeExtracter typeOf = <T>() => T;

final FastTestWidgetBuilder getFastTestWidget = (Widget testWidget) {
  return MaterialApp(
    home: Scaffold(
      body: ChangeNotifierProvider.value(
        value: FastFormStore(),
        child: FastFormTheme(
          child: testWidget,
        ),
      ),
    ),
  );
};
