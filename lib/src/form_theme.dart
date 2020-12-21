import 'package:flutter/material.dart';

import 'dropdown/dropdown.dart';
import 'text_field/text_field.dart';

import 'form_field.dart';

typedef InputDecorationCreator = InputDecoration Function(
    BuildContext context, FastFormField model);

final InputDecorationCreator defaultInputDecorationCreator =
    (BuildContext context, FastFormField model) {
  final theme = Theme.of(context);
  final enabled = model.enabled;
  return InputDecoration(
    contentPadding: (model is FastDropdown || model is FastTextField)
        ? EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0)
        : EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
    labelText: model.label,
    helperText: model.helper,
    hintText: model is FastTextField ? model.hint : null,
    labelStyle: TextStyle(
      color: enabled ? theme.textTheme.bodyText1.color : theme.disabledColor,
    ),
    enabled: enabled,
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: theme.disabledColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[700], width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: theme.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[500], width: 2),
    ),
    filled: false,
    fillColor: Colors.white,
  );
};

const defaultPadding =
    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0);

class FastFormTheme extends InheritedWidget {
  FastFormTheme({
    @required Widget child,
    InputDecorationCreator decorationCreator,
    Key key,
    EdgeInsets padding,
  })  : assert(child != null),
        this.getInputDecoration =
            decorationCreator ?? defaultInputDecorationCreator,
        this.padding = padding ?? defaultPadding,
        super(key: key, child: child);

  final InputDecorationCreator getInputDecoration;
  final EdgeInsets padding;

  static FastFormTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FastFormTheme>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
