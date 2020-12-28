import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form_field.dart';
import '../form_scope.dart';

@immutable
class FastTextField extends FastFormField<String> {
  FastTextField({
    this.autocorrect = true,
    this.autofillHints,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    this.buildCounter,
    FormFieldBuilder<String> builder,
    InputDecoration decoration,
    bool enabled = true,
    this.enableInteractiveSelection = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.focusNode,
    String helper,
    this.hint,
    @required String id,
    String initialValue,
    this.inputFormatters,
    Key key,
    this.keyboardType,
    String label,
    this.leading,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    ValueChanged<String> onChanged,
    VoidCallback onReset,
    FormFieldSetter<String> onSaved,
    this.padding,
    this.prefix,
    this.readOnly = false,
    this.suffix,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textCapitalization = TextCapitalization.none,
    this.trailing,
    FormFieldValidator<String> validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? textFieldBuilder,
          decoration: decoration,
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

  final bool autocorrect;
  final Iterable<String> autofillHints;
  final InputCounterWidgetBuilder buildCounter;
  final bool enableInteractiveSelection;
  final bool enableSuggestions;
  final bool expands;
  final FocusNode focusNode;
  final String hint;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final Widget leading;
  final int maxLength;
  final bool maxLengthEnforced;
  final int maxLines;
  final int minLines;
  final bool obscureText;
  final String obscuringCharacter;
  final EdgeInsetsGeometry padding;
  final Widget prefix;
  final bool readOnly;
  final Widget suffix;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextCapitalization textCapitalization;
  final Widget trailing;

  @override
  FastTextFieldState createState() => FastTextFieldState();
}

class FastTextFieldState extends FastFormFieldState<String> {
  @override
  FastTextField get widget => super.widget as FastTextField;

  @override
  void onChanged(String value) {
    setValue(value);
    formState.update(this);
  }

  AutovalidateMode get autovalidateMode =>
      touched ? AutovalidateMode.always : AutovalidateMode.disabled;
}

final InputCounterWidgetBuilder inputCounterWidgetBuilder = (
  BuildContext context, {
  int currentLength,
  int maxLength,
  bool isFocused,
}) {
  return Text(
    '$currentLength / $maxLength',
    semanticsLabel: 'character input count',
  );
};

final FormFieldBuilder<String> materialTextFieldBuilder =
    (FormFieldState<String> field) {
  final state = field as FastTextFieldState;
  final widget = state.widget;
  final theme = Theme.of(state.context);
  final decorator = FastFormScope.of(state.context).inputDecorator;
  final _decoration = widget.decoration ??
      decorator(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme).copyWith(
            prefix: widget.prefix != null && !(widget.prefix is Icon)
                ? widget.prefix
                : null,
            prefixIcon: widget.prefix is Icon ? widget.prefix : null,
            suffix: widget.suffix != null && !(widget.suffix is Icon)
                ? widget.suffix
                : null,
            suffixIcon: widget.suffix is Icon ? widget.suffix : null,
          );

  return TextFormField(
    autocorrect: widget.autocorrect,
    autofillHints: widget.autofillHints,
    autofocus: widget.autofocus,
    autovalidateMode: state.autovalidateMode,
    buildCounter: widget.buildCounter,
    decoration: effectiveDecoration,
    initialValue: widget.initialValue,
    enabled: widget.enabled,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    enableSuggestions: widget.enableSuggestions,
    expands: widget.expands,
    focusNode: widget.focusNode ?? state.focusNode,
    keyboardType: widget.keyboardType,
    inputFormatters: widget.inputFormatters,
    maxLength: widget.maxLength,
    maxLengthEnforced: widget.maxLengthEnforced,
    maxLines: widget.maxLines,
    minLines: widget.minLines,
    obscureText: widget.obscureText,
    obscuringCharacter: widget.obscuringCharacter,
    onChanged: widget.enabled ? state.didChange : null,
    onSaved: widget.onSaved,
    readOnly: widget.readOnly,
    textAlign: widget.textAlign,
    textAlignVertical: widget.textAlignVertical,
    textCapitalization: widget.textCapitalization,
    validator: widget.validator,
  );
};

final FormFieldBuilder<String> cupertinoTextFieldBuilder =
    (FormFieldState<String> field) {
  final state = field as FastTextFieldState;
  final widget = state.widget;

  return CupertinoTextField(
    autocorrect: widget.autocorrect,
    autofillHints: widget.autofillHints,
    autofocus: widget.autofocus,
    enabled: widget.enabled,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    enableSuggestions: widget.enableSuggestions,
    expands: widget.expands,
    focusNode: widget.focusNode ?? state.focusNode,
    keyboardType: widget.keyboardType,
    inputFormatters: widget.inputFormatters,
    maxLength: widget.maxLength,
    maxLengthEnforced: widget.maxLengthEnforced,
    maxLines: widget.maxLines,
    minLines: widget.minLines,
    obscureText: widget.obscureText,
    obscuringCharacter: widget.obscuringCharacter,
    onChanged: widget.enabled ? state.didChange : null,
    padding: widget.padding ?? const EdgeInsets.all(6.0),
    placeholder: widget.hint,
    prefix: widget.prefix,
    readOnly: widget.readOnly,
    suffix: widget.suffix,
    textAlign: widget.textAlign,
    textAlignVertical: widget.textAlignVertical,
    textCapitalization: widget.textCapitalization,
  );
};

final FormFieldBuilder<String> textFieldBuilder =
    (FormFieldState<String> field) {
  if ((field as FastTextFieldState).widget.adaptive) {
    switch (Theme.of(field.context).platform) {
      case TargetPlatform.iOS:
        return cupertinoTextFieldBuilder(field);
      case TargetPlatform.android:
      default:
        return materialTextFieldBuilder(field);
    }
  }
  return materialTextFieldBuilder(field);
};
