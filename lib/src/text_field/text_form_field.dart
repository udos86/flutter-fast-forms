import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FastTextFormField extends FormField<String> {
  FastTextFormField({
    bool autocorrect,
    Iterable<String> autofillHints,
    bool autofocus,
    bool autovalidate,
    InputCounterWidgetBuilder buildCounter,
    InputDecoration decoration = const InputDecoration(),
    bool enabled,
    bool enableInteractiveSelection,
    bool enableSuggestions,
    bool expands,
    FocusNode focusNode,
    String initialValue,
    List<TextInputFormatter> inputFormatters,
    Key key,
    TextInputType keyboardType,
    int maxLength,
    bool maxLengthEnforced,
    int maxLines,
    int minLines,
    bool obscureText,
    String obscuringCharacter,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    bool readOnly,
    TextCapitalization textCapitalization,
    FormFieldValidator validator,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final state = field as TextFormFieldState;
            return TextFormField(
              autocorrect: autocorrect,
              autofillHints: autofillHints,
              autofocus: autofocus,
              autovalidate: autovalidate,
              buildCounter: buildCounter,
              decoration: decoration,
              initialValue: initialValue,
              enabled: enabled,
              enableInteractiveSelection: enableInteractiveSelection,
              enableSuggestions: enableSuggestions,
              expands: expands,
              focusNode: focusNode,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              maxLengthEnforced: maxLengthEnforced,
              maxLines: maxLines,
              minLines: minLines,
              obscureText: obscureText,
              obscuringCharacter: obscuringCharacter,
              onChanged: state.didChange,
              onSaved: onSaved,
              readOnly: readOnly,
              textCapitalization: textCapitalization,
              validator: validator,
            );
          },
          initialValue: initialValue ?? '',
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged<String> onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<String> createState() => TextFormFieldState();
}

class TextFormFieldState extends FormFieldState<String> {
  @override
  FastTextFormField get widget => super.widget as FastTextFormField;

  @override
  void didChange(String value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
  }
}
