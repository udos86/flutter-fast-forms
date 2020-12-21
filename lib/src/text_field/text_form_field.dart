import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form_field.dart';
import '../form_theme.dart';
import '../utils/form_formatters.dart';

class FastTextField extends FastFormField<String> {
  FastTextField({
    bool autocorrect = true,
    Iterable<String> autofillHints,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    InputCounterWidgetBuilder buildCounter,
    FormFieldBuilder<String> builder,
    InputDecoration decoration,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = true,
    bool expands = false,
    FocusNode focusNode,
    String helper,
    this.hint,
    @required String id,
    String initialValue,
    List<TextInputFormatter> inputFormatters,
    Key key,
    TextInputType keyboardType,
    String label,
    int maxLength,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int minLines,
    bool obscureText = false,
    String obscuringCharacter = '•',
    ValueChanged<String> onChanged,
    VoidCallback onReset,
    FormFieldSetter<String> onSaved,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    FormFieldValidator<String> validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastTextFieldState;
                final formTheme = FastFormTheme.of(state.context);
                final _decoration = decoration ??
                    formTheme.getInputDecoration(state.context, state.widget) ??
                    const InputDecoration();

                return TextFormField(
                  autocorrect: autocorrect,
                  autofillHints: autofillHints,
                  autofocus: autofocus,
                  autovalidateMode: state.autovalidateMode,
                  buildCounter: buildCounter,
                  decoration: _decoration,
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
          helper: helper,
          id: id,
          initialValue: initialValue ?? '',
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String hint;

  @override
  FormFieldState<String> createState() => FastTextFieldState();
}

class FastTextFieldState extends FastFormFieldState<String> {
  @override
  FastTextField get widget => super.widget as FastTextField;

  AutovalidateMode get autovalidateMode =>
      touched ? AutovalidateMode.always : AutovalidateMode.disabled;
}
