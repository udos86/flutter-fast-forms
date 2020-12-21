import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:provider/provider.dart';

abstract class Utils {
  static Type typeOf<T>() => T;

  static wrapMaterial(Widget testWidget) {
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
  }
}
