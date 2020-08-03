import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form_builder.dart';
import 'form_field_model.dart';

@immutable
class TextFieldModel extends FormFieldModel<String> {
  TextFieldModel({
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
              (context, _state, model) {
                final state = _state as TextFieldModelState;
                return TextFormField(
                  decoration: decoration ??
                      FormBuilder.buildInputDecoration(context, model),
                  autovalidate: state.autovalidate,
                  keyboardType: keyboardType ?? TextInputType.text,
                  inputFormatters: [...inputFormatters],
                  validator: validator,
                  controller: state.textController,
                  focusNode: state.focusNode,
                );
              },
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;

  @override
  State<StatefulWidget> createState() => TextFieldModelState();
}

class TextFieldModelState extends FormFieldModelState<String> {
  bool focused = false;
  bool touched = false;

  TextEditingController textController;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(text: value ?? '');
    textController.addListener(_onTextChanged);
    save(textController.text);

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
    save(textController.text);
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
