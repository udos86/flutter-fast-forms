import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../form.dart';

/// A [FastFormField] that contains either a [CheckboxListTile.adaptive] or a
/// [CupertinoCheckbox].
@immutable
class FastCheckbox extends FastFormField<bool> {
  const FastCheckbox({
    super.adaptive,
    super.autovalidateMode,
    super.builder = checkboxBuilder,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue = false,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.activeColor,
    this.autofocus = false,
    this.checkboxSemanticLabel,
    this.checkboxShape,
    this.checkColor,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.dense,
    this.enableFeedback,
    this.errorBuilder,
    this.fillColor,
    this.focusColor,
    this.focusNode,
    this.helperBuilder,
    this.hoverColor,
    this.inactiveColor,
    this.isError = false,
    this.isThreeLine = false,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.onFocusChange,
    this.overlayColor,
    this.secondary,
    this.selectedTileColor,
    this.shape,
    this.shapeBorder,
    this.side,
    this.splashRadius,
    this.subtitle,
    this.tileColor,
    this.titleText,
    this.titleBuilder,
    this.tristate = false,
    this.visualDensity,
  });

  final bool autofocus;
  final Color? activeColor;
  final String? checkboxSemanticLabel;
  final OutlinedBorder? checkboxShape;
  final Color? checkColor;
  final ListTileControlAffinity controlAffinity;
  final bool? dense;
  final bool? enableFeedback;
  final FastErrorBuilder<bool>? errorBuilder;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? focusColor;
  final FocusNode? focusNode;
  final FastHelperBuilder<bool>? helperBuilder;
  final Color? hoverColor;
  final Color? inactiveColor;
  final bool isError;
  final bool isThreeLine;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final void Function(bool)? onFocusChange;
  final MaterialStateProperty<Color?>? overlayColor;
  final Widget? secondary;
  final Color? selectedTileColor;
  final OutlinedBorder? shape;
  final ShapeBorder? shapeBorder;
  final BorderSide? side;
  final double? splashRadius;
  final Widget? subtitle;
  final Color? tileColor;
  final String? titleText;
  final Widget? Function(FastCheckboxState field)? titleBuilder;
  final bool tristate;
  final VisualDensity? visualDensity;

  @override
  FastCheckboxState createState() => FastCheckboxState();
}

/// State associated with a [FastCheckbox] widget.
class FastCheckboxState extends FastFormFieldState<bool> {
  @override
  FastCheckbox get widget => super.widget as FastCheckbox;
}

/// The default [FastCheckbox.titleBuilder].
///
/// Returns a [Text] widget when [FastCheckbox.titleText] is a [String]
/// otherwise null.
Widget? checkboxTitleBuilder(FastCheckboxState field) {
  final FastCheckboxState(:value!, :widget) = field;
  final text = widget.titleText;

  return text is String
      ? Text(
          text,
          style: TextStyle(
            fontSize: 14.0,
            color: value ? Colors.black : Colors.grey,
          ),
        )
      : null;
}

/// The default [FastCheckbox] Material [FormFieldBuilder].
///
/// Returns an [InputDecorator] that contains a [CheckboxListTile.adaptive].
Widget materialCheckboxBuilder(FormFieldState<bool> field) {
  field as FastCheckboxState;
  final FastCheckboxState(:decoration, :didChange, :value, :widget) = field;
  final titleBuilder = widget.titleBuilder ?? checkboxTitleBuilder;

  return InputDecorator(
    decoration: decoration,
    child: CheckboxListTile.adaptive(
      activeColor: widget.activeColor,
      autofocus: widget.autofocus,
      checkColor: widget.checkColor,
      checkboxSemanticLabel: widget.checkboxSemanticLabel,
      checkboxShape: widget.checkboxShape,
      contentPadding: widget.contentPadding,
      controlAffinity: widget.controlAffinity,
      dense: widget.dense,
      enabled: widget.enabled,
      enableFeedback: widget.enableFeedback,
      fillColor: widget.fillColor,
      focusNode: widget.focusNode,
      hoverColor: widget.hoverColor,
      isError: widget.isError,
      isThreeLine: widget.isThreeLine,
      materialTapTargetSize: widget.materialTapTargetSize,
      mouseCursor: widget.mouseCursor,
      onChanged: widget.enabled ? didChange : null,
      onFocusChange: widget.onFocusChange,
      overlayColor: widget.overlayColor,
      secondary: widget.secondary,
      selected: value ?? false,
      selectedTileColor: widget.selectedTileColor,
      shape: widget.shapeBorder,
      side: widget.side,
      splashRadius: widget.splashRadius,
      subtitle: widget.subtitle,
      tileColor: widget.tileColor,
      title: titleBuilder(field),
      tristate: widget.tristate,
      value: value,
      visualDensity: widget.visualDensity,
    ),
  );
}

/// The default [FastCheckbox] Cupertino [FormFieldBuilder].
///
/// Returns a [CupertinoFormRow] that contains a [CupertinoCheckbox].
Widget cupertinoCheckboxBuilder(FormFieldState<bool> field) {
  field as FastCheckboxState;
  final FastCheckboxState(:didChange, :value, :widget) = field;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.labelText is String ? Text(widget.labelText!) : null,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: CupertinoCheckbox(
      activeColor: widget.activeColor,
      autofocus: widget.autofocus,
      checkColor: widget.checkColor,
      focusColor: widget.focusColor,
      focusNode: widget.focusNode,
      inactiveColor: widget.inactiveColor,
      onChanged: widget.enabled ? didChange : null,
      shape: widget.shape,
      side: widget.side,
      tristate: widget.tristate,
      value: value,
    ),
  );
}

/// The default [FastCheckbox.builder].
///
/// Uses [materialCheckboxBuilder] by default on any [TargetPlatform].
///
/// Uses [cupertinoCheckboxBuilder] on [TargetPlatform.iOS] when
/// [FastCheckboxState.adaptive] is true.
Widget checkboxBuilder(FormFieldState<bool> field) {
  field as FastCheckboxState;

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS when field.adaptive:
      return cupertinoCheckboxBuilder(field);
    default:
      return materialCheckboxBuilder(field);
  }
}
