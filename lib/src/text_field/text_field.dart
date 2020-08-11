import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form_field.dart';
import '../form_style.dart';

@immutable
class FastTextField extends FastFormField<String> {
  FastTextField({
    this.autocorrect = true,
    bool autofocus = false,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    bool enabled = true,
    String helper,
    this.hint,
    @required String id,
    String initialValue,
    this.inputFormatters,
    this.keyboardType,
    String label,
    this.maxLength,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          builder: builder ?? _builder,
          decoration: decoration,
          enabled: enabled,
          helper: helper,
          id: id,
          initialValue: initialValue ?? '',
          label: label,
          validator: validator,
        );

  final bool autocorrect;
  final String hint;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final int maxLength;

  @override
  State<StatefulWidget> createState() => FastTextFieldState();
}

class FastTextFieldState extends FastFormFieldState<String> {
  TextEditingController textController;

  @override
  void initState() {
    super.initState();
    //textController = TextEditingController(text: value);
    //textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    super.dispose();
    //textController.dispose();
  }

  @override
  void onChanged(String value) {
    this.value = value;
    store.updateField(this);
  }

  @override
  void onReset() {
    super.onReset();
  }

  void _onTextChanged() {
    onChanged(textController.text);
  }
}

final FastFormFieldBuilder _builder = (context, _state) {
  final state = _state as FastTextFieldState;
  final style = FormStyle.of(context);
  final widget = state.widget as FastTextField;

  return TextFormField(
    autocorrect: widget.autocorrect,
    autofocus: widget.autofocus,
    autovalidate: state.autovalidate,
    initialValue: widget.initialValue,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    enabled: widget.enabled,
    focusNode: state.focusNode,
    keyboardType: widget.keyboardType ?? TextInputType.text,
    inputFormatters: widget.inputFormatters,
    maxLength: widget.maxLength,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
    validator: widget.validator,
  );
};
