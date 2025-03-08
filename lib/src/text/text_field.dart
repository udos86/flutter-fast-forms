import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form.dart';

/// A [FastFormField] that contains either a [TextFormField] or a
/// [CupertinoTextFormFieldRow].
@immutable
class FastTextField extends FastFormField<String> {
  const FastTextField({
    super.adaptive = true,
    super.autovalidateMode,
    super.builder = textFieldBuilder,
    super.conditions,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.forceErrorText,
    super.helperText,
    super.initialValue = '',
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.onTouched,
    super.restorationId,
    super.validator,
    this.autocorrect = true,
    this.autofillHints,
    this.autofocus = false,
    this.autovalidateOnTouched = true,
    this.buildCounter,
    this.canRequestFocus = true,
    this.clipBehavior = Clip.hardEdge,
    this.contentInsertionConfiguration,
    this.contextMenuBuilder,
    this.cursorColor,
    this.cursorErrorColor,
    this.cursorHeight,
    this.cursorOpacityAnimates,
    this.cursorRadius,
    this.cursorWidth = 2.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableIMEPersonalizedLearning = true,
    this.enableInteractiveSelection = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.focusNode,
    this.ignorePointers,
    this.inputFormatters,
    this.keyboardAppearance,
    this.keyboardType,
    this.leading,
    this.magnifierConfiguration,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.mouseCursor,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.onAppPrivateCommand,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.padding,
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.readOnly = false,
    @Deprecated('use stylusHandwritingEnabled instead')
    this.scribbleEnabled = true,
    this.scrollController,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.scrollPhysics,
    this.selectionControls,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.spellCheckConfiguration,
    this.strutStyle,
    this.style,
    this.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    this.suffix,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textInputAction,
    this.trailing,
    this.undoController,
  });

  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final bool autofocus;

  /// Whether validation should take place when the field is
  /// marked as touched, even though the [initialValue] did not change.
  ///
  /// Used in [FastTextFieldState.autovalidateMode] getter.
  ///
  /// When `false` [FastTextField.autovalidateMode] is applied.
  final bool autovalidateOnTouched;
  final InputCounterWidgetBuilder? buildCounter;
  final bool canRequestFocus;
  final Clip clipBehavior;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final double cursorWidth;
  final DragStartBehavior dragStartBehavior;
  final bool enableIMEPersonalizedLearning;
  final bool enableInteractiveSelection;
  final bool enableSuggestions;
  final bool expands;
  final FocusNode? focusNode;
  final bool? ignorePointers;
  final List<TextInputFormatter>? inputFormatters;
  final Brightness? keyboardAppearance;
  final TextInputType? keyboardType;
  final Widget? leading;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final int? maxLines;
  final int? minLines;
  final MouseCursor? mouseCursor;
  final bool obscureText;
  final String obscuringCharacter;
  final void Function(String, Map<String, dynamic>)? onAppPrivateCommand;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final void Function(PointerDownEvent)? onTapOutside;
  final EdgeInsetsGeometry? padding;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final Widget? prefix;
  final bool readOnly;
  final bool scribbleEnabled;
  final ScrollController? scrollController;
  final EdgeInsets scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final TextSelectionControls? selectionControls;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final bool? showCursor;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final bool stylusHandwritingEnabled;
  final Widget? suffix;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;
  final Widget? trailing;
  final UndoHistoryController? undoController;

  @override
  FastTextFieldState createState() => FastTextFieldState();
}

/// State associated with a [FastTextField] widget.
class FastTextFieldState extends FastFormFieldState<String> {
  @override
  FastTextField get widget => super.widget as FastTextField;

  @override
  void onChanged(String? value) {
    setValue(value);
    widget.onChanged?.call(value);
    form?.onChanged();
  }

  /// Returns [AutovalidateMode.always] when
  /// [FastTextField.autovalidateOnTouched] is true and the [FastTextField] is
  /// [touched].
  ///
  /// Returns [AutovalidateMode.disabled] when
  /// [FastTextField.autovalidateOnTouched] is true and the [FastTextField] is
  /// has not been [touched] yet.
  ///
  /// Returns [FastTextField.autovalidateMode] when
  /// [FastTextField.autovalidateOnTouched] is false.
  AutovalidateMode get autovalidateMode {
    if (widget.autovalidateOnTouched) {
      return touched ? AutovalidateMode.always : AutovalidateMode.disabled;
    }
    return widget.autovalidateMode;
  }
}

/// A basic [InputCounterWidgetBuilder].
///
/// Returns a [Text] widget that displays the current character count in
/// relation to the [FastTextField.maxLength].
///
/// Typically used as [FastTextField.buildCounter].
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

/// The default [FastTextField] Material [FormFieldBuilder].
///
/// Returns a [TextFormField].
Widget materialTextFieldBuilder(FormFieldState<String> field) {
  final FastTextFieldState(
    :autovalidateMode,
    :didChange,
    :enabled,
    :focusNode,
    :widget
  ) = field as FastTextFieldState;
  final FastTextField(:prefix, :suffix) = widget;
  final InputDecoration decoration = field.decoration.copyWith(
    hintText: widget.placeholder,
    prefix: prefix != null && prefix is! Icon ? prefix : null,
    prefixIcon: prefix is Icon ? prefix : null,
    suffix: suffix != null && suffix is! Icon ? suffix : null,
    suffixIcon: suffix is Icon ? suffix : null,
  );

  return TextFormField(
    autocorrect: widget.autocorrect,
    autofillHints: widget.autofillHints,
    autofocus: widget.autofocus,
    autovalidateMode: autovalidateMode,
    buildCounter: widget.buildCounter,
    canRequestFocus: widget.canRequestFocus,
    clipBehavior: widget.clipBehavior,
    contentInsertionConfiguration: widget.contentInsertionConfiguration,
    contextMenuBuilder: widget.contextMenuBuilder,
    cursorColor: widget.cursorColor,
    cursorErrorColor: widget.cursorErrorColor,
    cursorHeight: widget.cursorHeight,
    cursorOpacityAnimates: widget.cursorOpacityAnimates,
    cursorRadius: widget.cursorRadius,
    cursorWidth: widget.cursorWidth,
    decoration: decoration,
    enabled: enabled,
    dragStartBehavior: widget.dragStartBehavior,
    enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    enableSuggestions: widget.enableSuggestions,
    expands: widget.expands,
    focusNode: widget.focusNode ?? focusNode,
    forceErrorText: widget.forceErrorText,
    ignorePointers: widget.ignorePointers,
    keyboardAppearance: widget.keyboardAppearance,
    keyboardType: widget.keyboardType,
    initialValue: widget.initialValue,
    inputFormatters: widget.inputFormatters,
    maxLength: widget.maxLength,
    maxLengthEnforcement: widget.maxLengthEnforcement,
    maxLines: widget.maxLines,
    minLines: widget.minLines,
    magnifierConfiguration: widget.magnifierConfiguration,
    mouseCursor: widget.mouseCursor,
    obscureText: widget.obscureText,
    obscuringCharacter: widget.obscuringCharacter,
    onAppPrivateCommand: widget.onAppPrivateCommand,
    onChanged: enabled ? didChange : null,
    onEditingComplete: widget.onEditingComplete,
    onFieldSubmitted: widget.onFieldSubmitted,
    onSaved: widget.onSaved,
    onTap: widget.onTap,
    onTapAlwaysCalled: widget.onTapAlwaysCalled,
    onTapOutside: widget.onTapOutside,
    readOnly: widget.readOnly,
    // ignore: deprecated_member_use
    scribbleEnabled: widget.scribbleEnabled,
    scrollController: widget.scrollController,
    scrollPadding: widget.scrollPadding,
    scrollPhysics: widget.scrollPhysics,
    selectionControls: widget.selectionControls,
    selectionHeightStyle: widget.selectionHeightStyle,
    selectionWidthStyle: widget.selectionWidthStyle,
    showCursor: widget.showCursor,
    smartDashesType: widget.smartDashesType,
    smartQuotesType: widget.smartQuotesType,
    spellCheckConfiguration: widget.spellCheckConfiguration,
    strutStyle: widget.strutStyle,
    style: widget.style,
    stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
    textAlign: widget.textAlign,
    textAlignVertical: widget.textAlignVertical,
    textCapitalization: widget.textCapitalization,
    textDirection: widget.textDirection,
    textInputAction: widget.textInputAction,
    undoController: widget.undoController,
    validator: widget.validator,
  );
}

/// The default [FastTextField] Cupertino [FormFieldBuilder].
///
/// Returns a [CupertinoTextFormFieldRow].
Widget cupertinoTextFieldBuilder(FormFieldState<String> field) {
  final FastTextFieldState(
    :autovalidateMode,
    :didChange,
    :enabled,
    :focusNode,
    :widget
  ) = field as FastTextFieldState;
  final prefix = widget.prefix ??
      (widget.labelText is String ? Text(widget.labelText!) : null);

  return CupertinoTextFormFieldRow(
    autocorrect: widget.autocorrect,
    autofillHints: widget.autofillHints,
    autofocus: widget.autofocus,
    autovalidateMode: autovalidateMode,
    contextMenuBuilder: widget.contextMenuBuilder,
    cursorColor: widget.cursorColor,
    cursorHeight: widget.cursorHeight,
    cursorWidth: widget.cursorWidth,
    enabled: enabled,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    enableSuggestions: widget.enableSuggestions,
    expands: widget.expands,
    focusNode: widget.focusNode ?? focusNode,
    keyboardAppearance: widget.keyboardAppearance,
    keyboardType: widget.keyboardType,
    initialValue: widget.initialValue,
    inputFormatters: widget.inputFormatters,
    maxLength: widget.maxLength,
    maxLines: widget.maxLines,
    minLines: widget.minLines,
    obscureText: widget.obscureText,
    obscuringCharacter: widget.obscuringCharacter,
    onChanged: enabled ? didChange : null,
    onFieldSubmitted: widget.onFieldSubmitted,
    onEditingComplete: widget.onEditingComplete,
    onSaved: widget.onSaved,
    onTap: widget.onTap,
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
    validator: widget.validator,
  );
}

/// A [FormFieldBuilder] that is the default [FastTextField.builder].
///
/// Uses [materialTextFieldBuilder] by default on any [TargetPlatform].
///
/// Uses [cupertinoTextFieldBuilder] on [TargetPlatform.iOS] when
/// [FastTextFieldState.adaptive] is true.
Widget textFieldBuilder(FormFieldState<String> field) {
  field as FastTextFieldState;

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS when field.adaptive:
      return cupertinoTextFieldBuilder(field);
    default:
      return materialTextFieldBuilder(field);
  }
}
