import 'dart:collection';

import 'package:flutter/material.dart';

import 'form_field.dart';
import 'form_scope.dart';

import 'options/autocomplete.dart';
import 'options/dropdown.dart';
import 'text/text_field.dart';

typedef FastFormChanged = void Function(
    UnmodifiableMapView<String, dynamic> values);

@immutable
class FastForm extends StatefulWidget {
  const FastForm({
    Key? key,
    this.adaptive = false,
    required this.children,
    required this.formKey,
    this.inputDecorator,
    this.onChanged,
  }) : super(key: key);

  final bool adaptive;
  final List<Widget> children;
  final GlobalKey<FormState> formKey;
  final FastInputDecorator? inputDecorator;
  final FastFormChanged? onChanged;

  @override
  FastFormState createState() => FastFormState();
}

class FastFormState extends State<FastForm> {
  final Set<FastFormFieldState<dynamic>> _fields = {};

  UnmodifiableMapView<String, dynamic> get values {
    return UnmodifiableMapView(
        {for (final fieldState in _fields) fieldState.name: fieldState.value});
  }

  void register(FastFormFieldState field) => _fields.add(field);

  void unregister(FastFormFieldState field) => _fields.remove(field);

  void updateValues() {
    if (widget.onChanged != null) widget.onChanged!(values);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // Current store cannot be retrieved here due to the framework calling this before widget.onChanged
      // onChanged: () =>,
      key: widget.formKey,
      child: FastFormScope(
        adaptive: widget.adaptive,
        formState: this,
        inputDecorator: widget.inputDecorator ?? _inputDecorationCreator,
        child: Column(
          children: widget.children,
        ),
      ),
    );
  }
}

InputDecoration _inputDecorationCreator(
    BuildContext context, FastFormField field) {
  final theme = Theme.of(context);
  final enabled = field.enabled;
  return InputDecoration(
    contentPadding: (field is FastDropdown ||
            field is FastTextField ||
            field is FastAutocomplete)
        ? const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0)
        : const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
    labelText: field.label,
    helperText: field.helperText,
    hintText: field is FastTextField ? field.placeholder : null,
    labelStyle: TextStyle(
      color: enabled ? theme.textTheme.bodyText1!.color : theme.disabledColor,
    ),
    enabled: enabled,
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: theme.disabledColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: theme.primaryColor, width: 2),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[500]!, width: 2),
    ),
    filled: false,
    fillColor: Colors.white,
  );
}
