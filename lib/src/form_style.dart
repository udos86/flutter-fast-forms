import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

typedef InputDecorationCreator = InputDecoration Function(
    BuildContext context, FormFieldModel model);

final InputDecorationCreator _defaultInputDecorationCreator =
    (BuildContext context, FormFieldModel model) {
  return InputDecoration(
    labelText: model.label,
    helperText: model.helper,
    hintText: model.hint,
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[900], width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[900], width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber[500], width: 3),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[600], width: 3),
    ),
    filled: false,
    fillColor: Colors.white,
  );
};

class FormStyle extends InheritedWidget {
  FormStyle({
    @required Widget child,
    InputDecorator inputDecorator,
    Key key,
    EdgeInsets padding,
  })  : assert(child != null),
        this.createInputDecoration =
            inputDecorator ?? _defaultInputDecorationCreator,
        super(key: key, child: child);

  final InputDecorationCreator createInputDecoration;

  static FormStyle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormStyle>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
