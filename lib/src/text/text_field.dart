import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form.dart';

@immutable
class FastTextField extends FastFormField<String> {
  const FastTextField({
    bool? adaptive,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<String>? builder,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0),
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    String initialValue = '',
    Key? key,
    String? labelText,
    required String name,
    ValueChanged<String>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    this.autocorrect = true,
    this.autofillHints,
    this.buildCounter,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorWidth = 2.0,
    this.enableIMEPersonalizedLearning = true,
    this.enableInteractiveSelection = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.focusNode,
    this.inputFormatters,
    this.keyboardAppearance,
    this.keyboardType,
    this.leading,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.padding,
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.readOnly = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.scrollPhysics,
    this.selectionControls,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.strutStyle,
    this.style,
    this.suffix,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textInputAction,
    this.toolbarOptions,
    this.trailing,
  }) : super(
          adaptive: adaptive,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? textFieldBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          labelText: labelText,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final InputCounterWidgetBuilder? buildCounter;
  final Color? cursorColor;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final double cursorWidth;
  final bool enableIMEPersonalizedLearning;
  final bool enableInteractiveSelection;
  final bool enableSuggestions;
  final bool expands;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Brightness? keyboardAppearance;
  final TextInputType? keyboardType;
  final Widget? leading;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final String obscuringCharacter;
  final EdgeInsetsGeometry? padding;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final Widget? prefix;
  final bool readOnly;
  final EdgeInsets scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final TextSelectionControls? selectionControls;
  final bool? showCursor;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final Widget? suffix;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;
  final ToolbarOptions? toolbarOptions;
  final Widget? trailing;

  @override
  FastTextFieldState createState() => FastTextFieldState();
}

class FastTextFieldState extends FastFormFieldState<String> {
  @override
  FastTextField get widget => super.widget as FastTextField;

  @override
  void onChanged(String? value) {
    setValue(value);
    form?.onChanged();
  }

  AutovalidateMode get autovalidateMode {
    return touched ? AutovalidateMode.always : AutovalidateMode.disabled;
  }
}

Text inputCounterWidgetBuilder(
  BuildContext context, {
  required int currentLength,
  required int? maxLength,
  required bool isFocused,
}) {
  return Text(
    '$currentLength / $maxLength',
    semanticsLabel: 'character input count',
  );
}

TextFormField materialTextFieldBuilder(FormFieldState<String> field) {
  final widget = (field as FastTextFieldState).widget;
  final InputDecoration decoration = field.decoration.copyWith(
    hintText: widget.placeholder,
    prefix:
        widget.prefix != null && widget.prefix is! Icon ? widget.prefix : null,
    prefixIcon: widget.prefix is Icon ? widget.prefix : null,
    suffix:
        widget.suffix != null && widget.suffix is! Icon ? widget.suffix : null,
    suffixIcon: widget.suffix is Icon ? widget.suffix : null,
  );

  return TextFormField(
    autocorrect: widget.autocorrect,
    autofillHints: widget.autofillHints,
    autofocus: widget.autofocus,
    autovalidateMode: field.autovalidateMode,
    buildCounter: widget.buildCounter,
    cursorColor: widget.cursorColor,
    cursorHeight: widget.cursorHeight,
    cursorRadius: widget.cursorRadius,
    cursorWidth: widget.cursorWidth,
    decoration: decoration,
    initialValue: widget.initialValue,
    enabled: widget.enabled,
    enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    enableSuggestions: widget.enableSuggestions,
    expands: widget.expands,
    focusNode: widget.focusNode ?? field.focusNode,
    keyboardAppearance: widget.keyboardAppearance,
    keyboardType: widget.keyboardType,
    inputFormatters: widget.inputFormatters,
    maxLength: widget.maxLength,
    maxLengthEnforcement: widget.maxLengthEnforcement,
    maxLines: widget.maxLines,
    minLines: widget.minLines,
    obscureText: widget.obscureText,
    obscuringCharacter: widget.obscuringCharacter,
    onChanged: widget.enabled ? field.didChange : null,
    onSaved: widget.onSaved,
    readOnly: widget.readOnly,
    scrollPadding: widget.scrollPadding,
    scrollPhysics: widget.scrollPhysics,
    selectionControls: widget.selectionControls,
    showCursor: widget.showCursor,
    smartDashesType: widget.smartDashesType,
    smartQuotesType: widget.smartQuotesType,
    strutStyle: widget.strutStyle,
    style: widget.style,
    textAlign: widget.textAlign,
    textAlignVertical: widget.textAlignVertical,
    textCapitalization: widget.textCapitalization,
    textDirection: widget.textDirection,
    textInputAction: widget.textInputAction,
    toolbarOptions: widget.toolbarOptions,
    validator: widget.validator,
  );
}

CupertinoTextFormFieldRow cupertinoTextFieldBuilder(
    FormFieldState<String> field) {
  final widget = (field as FastTextFieldState).widget;
  final prefix = widget.prefix ??
      (widget.labelText is String ? Text(widget.labelText!) : null);

  return CupertinoTextFormFieldRow(
    autocorrect: widget.autocorrect,
    autofillHints: widget.autofillHints,
    autofocus: widget.autofocus,
    autovalidateMode: field.autovalidateMode,
    cursorColor: widget.cursorColor,
    cursorHeight: widget.cursorHeight,
    cursorWidth: widget.cursorWidth,
    enabled: widget.enabled,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    enableSuggestions: widget.enableSuggestions,
    expands: widget.expands,
    focusNode: widget.focusNode ?? field.focusNode,
    keyboardAppearance: widget.keyboardAppearance,
    keyboardType: widget.keyboardType,
    initialValue: widget.initialValue,
    inputFormatters: widget.inputFormatters,
    maxLength: widget.maxLength,
    maxLines: widget.maxLines,
    minLines: widget.minLines,
    obscureText: widget.obscureText,
    obscuringCharacter: widget.obscuringCharacter,
    onChanged: widget.enabled ? field.didChange : null,
    padding: widget.padding,
    placeholder: widget.placeholder,
    placeholderStyle: widget.placeholderStyle,
    prefix: prefix,
    readOnly: widget.readOnly,
    scrollPadding: widget.scrollPadding,
    scrollPhysics: widget.scrollPhysics,
    selectionControls: widget.selectionControls,
    showCursor: widget.showCursor,
    smartDashesType: widget.smartDashesType,
    smartQuotesType: widget.smartQuotesType,
    strutStyle: widget.strutStyle,
    style: widget.style,
    textAlign: widget.textAlign,
    textAlignVertical: widget.textAlignVertical,
    textCapitalization: widget.textCapitalization,
    textDirection: widget.textDirection,
    textInputAction: widget.textInputAction,
    toolbarOptions: widget.toolbarOptions,
    validator: widget.validator,
  );
}

Widget textFieldBuilder(FormFieldState<String> field) {
  FormFieldBuilder<String> builder = materialTextFieldBuilder;

  if ((field as FastTextFieldState).adaptive) {
    final platform = Theme.of(field.context).platform;
    if (platform == TargetPlatform.iOS) builder = cupertinoTextFieldBuilder;
  }

  return builder(field);
}
