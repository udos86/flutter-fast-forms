import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form_field.dart';
import '../form_style.dart';

@immutable
class FastTextField extends FastFormField<String> {
  FastTextField({
    builder,
    decoration,
    helper,
    hint,
    id,
    String initialValue,
    label,
    validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  }) : super(
          builder: builder ??
              (context, _state) {
                final state = _state as TextFieldModelState;
                final style = FormStyle.of(context);
                return TextFormField(
                  decoration: decoration ??
                      style.createInputDecoration(context, state.widget),
                  autovalidate: state.autovalidate,
                  keyboardType: keyboardType ?? TextInputType.text,
                  inputFormatters: [...inputFormatters],
                  validator: validator,
                  controller: state.textController,
                  focusNode: state.focusNode,
                  onChanged: state.onChanged,
                  onSaved: state.onSaved,
                );
              },
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue ?? '',
          label: label,
          validator: validator,
        );

  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;

  @override
  State<StatefulWidget> createState() => TextFieldModelState();
}

class TextFieldModelState extends FastFormFieldState<String> {
  bool focused = false;
  bool touched = false;

  TextEditingController textController;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(text: value ?? '');
    textController.addListener(_onTextChanged);

    focusNode = FocusNode();
    focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    focusNode.dispose();
  }

  @override
  void reset() {
    super.reset();
    this.focused = false;
    this.touched = false;
    this.textController.text = widget.initialValue ?? '';
  }

  @override
  bool get autovalidate => touched;

  void markAsFocused([bool focused = true]) {
    if (this.focused != focused) {
      setState(() => this.focused = focused);
    }
  }

  void markAsTouched([bool touched = true]) {
    if (this.touched != touched) {
      setState(() => this.touched = touched);
    }
  }

  void _onTextChanged() {
    onChanged(textController.text);
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus) {
      markAsFocused();
    } else {
      markAsFocused(false);
      if (!touched) {
        markAsTouched();
      }
    }
  }
}
