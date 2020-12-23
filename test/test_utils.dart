import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:provider/provider.dart';

typedef FastTestWidgetBuilder = MaterialApp Function(Widget testWidget);
typedef GenricTypeExtracter = Type Function<T>();

final GenricTypeExtracter typeOf = <T>() => T;

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
