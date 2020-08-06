import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form_field.dart';
import '../form_style.dart';

@immutable
class FastTextField extends FastFormField<String> {
  FastTextField({
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    bool enabled = true,
    String helper,
    @required String id,
    String initialValue,
    String label,
    FormFieldValidator validator,
    this.autofocus = false,
    this.autocorrect = true,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  }) : super(
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
  final bool autofocus;
  final String hint;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
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

final FastFormFieldBuilder _builder = (context, _state) {
  final state = _state as TextFieldModelState;
  final style = FormStyle.of(context);
  final widget = state.widget as FastTextField;

  return TextFormField(
    autocorrect: widget.autocorrect,
    autofocus: widget.autofocus,
    autovalidate: state.autovalidate,
    controller: state.textController,
    decoration: widget.decoration ?? style.getInputDecoration(context, widget),
    enabled: widget.enabled,
    focusNode: state.focusNode,
    keyboardType: widget.keyboardType ?? TextInputType.text,
    inputFormatters: [...widget.inputFormatters],
    maxLength: widget.maxLength,
    validator: widget.validator,
    onChanged: state.onChanged,
    onSaved: state.onSaved,
    onTap: () => print(context.size.height),
  );
};
