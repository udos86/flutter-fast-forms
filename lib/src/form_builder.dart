import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

abstract class FormBuilder {
  static InputDecoration buildInputDecoration(
      BuildContext context, FormFieldModel model) {
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
  }

  static List<DropdownMenuItem> buildDropdownMenuItems(List<String> items) {
    return items.map(
      (value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      },
    ).toList();
  }
}
