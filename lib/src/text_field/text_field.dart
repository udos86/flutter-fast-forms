import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form_field.dart';
import '../form_style.dart';
import '../utils/form_formatters.dart';

import 'text_form_field.dart';

@immutable
class FastTextField extends FastFormField<String> {
  FastTextField({
    this.autocorrect = true,
    this.autofillHints,
    bool autofocus,
    AutovalidateMode autovalidateMode,
    this.buildCounter,
    FastFormFieldBuilder builder,
    InputDecoration decoration,
    bool enabled,
    this.enableInteractiveSelection = true,
    this.enableSuggestions = true,
    this.expands = false,
    String helper,
    this.hint,
    @required String id,
    String initialValue,
    this.inputFormatters,
    this.keyboardType,
    String label,
    this.mask,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.maxLines = 1,
    this.minLines,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus ?? false,
          autovalidateMode: autovalidateMode,
          //?? AutovalidateMode.onUserInteraction,
          builder: builder ?? _builder,
          decoration: decoration,
          enabled: enabled ?? true,
          helper: helper,
          id: id,
          initialValue: initialValue ?? '',
          label: label,
          validator: validator,
        );

  final bool autocorrect;
  final Iterable<String> autofillHints;
  final InputCounterWidgetBuilder buildCounter;
  final bool enableInteractiveSelection;
  final bool enableSuggestions;
  final bool expands;
  final String hint;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final String mask;
  final int maxLength;
  final bool maxLengthEnforced;
  final int maxLines;
  final int minLines;
  final String obscuringCharacter;
  final bool obscureText;
  final bool readOnly;
  final TextCapitalization textCapitalization;

  @override
  State<StatefulWidget> createState() => FastTextFieldState();
}

class FastTextFieldState extends FastFormFieldState<String> {
  AutovalidateMode get autovalidateMode =>
      touched ? AutovalidateMode.always : AutovalidateMode.disabled;

  @override
  void onChanged(String value) {
    this.value = value;
    store.update(this);
  }
}

final FastFormFieldBuilder _builder = (context, _state) {
  final state = _state as FastTextFieldState;
  final style = FormStyle.of(context);
  final widget = state.widget as FastTextField;
  final decoration = widget.decoration ??
      style?.getInputDecoration(context, widget) ??
      const InputDecoration();

  return FastTextFormField(
    autocorrect: widget.autocorrect,
    autofillHints: widget.autofillHints,
    autofocus: widget.autofocus,
    autovalidateMode: widget.autovalidateMode ?? state.autovalidateMode,
    buildCounter: widget.buildCounter,
    decoration: decoration,
    enabled: widget.enabled,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    enableSuggestions: widget.enableSuggestions,
    expands: widget.expands,
    focusNode: state.focusNode,
    initialValue: widget.initialValue,
    inputFormatters: [
      // workaround to avoid appearance of memoized value on re-entering text field after reset
      if (widget.mask != null) InputFormatters.maskText(widget.mask),
      if (widget.inputFormatters is List) ...widget.inputFormatters,
    ],
    keyboardType: widget.keyboardType ?? TextInputType.text,
    maxLength: widget.maxLength,
    maxLengthEnforced: widget.maxLengthEnforced,
    maxLines: widget.maxLines,
    minLines: widget.minLines,
    obscureText: widget.obscureText,
    obscuringCharacter: widget.obscuringCharacter,
    onChanged: state.onChanged,
    onReset: state.onReset,
    onSaved: state.onSaved,
    readOnly: widget.readOnly,
    textCapitalization: widget.textCapitalization,
    validator: widget.validator,
  );
};
