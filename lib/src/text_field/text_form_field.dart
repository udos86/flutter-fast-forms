import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FastTextFormField extends FormField<String> {
  FastTextFormField({
    bool autocorrect,
    Iterable<String> autofillHints,
    bool autofocus,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    InputCounterWidgetBuilder buildCounter,
    InputDecoration decoration = const InputDecoration(),
    bool enabled = true,
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
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final state = field as TextFormFieldState;
            return TextFormField(
              autocorrect: autocorrect,
              autofillHints: autofillHints,
              autofocus: autofocus,
              autovalidateMode: autovalidateMode,
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
              onChanged: enabled ? state.didChange : null,
              onSaved: onSaved,
              readOnly: readOnly,
              textCapitalization: textCapitalization,
              validator: validator,
            );
          },
          enabled: enabled,
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
