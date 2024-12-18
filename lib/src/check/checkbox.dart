import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form.dart';

typedef FastCheckboxWidgetBuilder = FastWidgetBuilder<FastCheckboxState>;

/// A [FastFormField] that contains either a [CheckboxListTile.adaptive] or a
/// [CupertinoCheckbox].
@immutable
class FastCheckbox extends FastFormField<bool> {
  const FastCheckbox({
    super.adaptive,
    super.autovalidateMode,
    super.builder = checkboxBuilder,
    super.conditions,
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
    super.onTouched,
    super.restorationId,
    super.validator,
    this.activeColor,
    this.autofocus = false,
    this.checkboxScaleFactor = 1.0,
    this.checkboxSemanticLabel,
    this.checkboxShape,
    this.checkColor,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.cupertinoErrorBuilder = checkboxErrorBuilder,
    this.cupertinoHelperBuilder = checkboxHelperBuilder,
    this.cupertinoPrefixBuilder = checkboxPrefixBuilder,
    this.dense,
    this.enableFeedback,
    this.fillColor,
    this.focusColor,
    this.focusNode,
    this.hoverColor,
    @Deprecated('Use fillColor instead.') this.inactiveColor,
    this.internalAddSemanticForOnTap = false,
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
    this.showInputDecoration = true,
    this.splashRadius,
    this.subtitle,
    this.tileColor,
    this.titleText,
    this.titleBuilder = checkboxTitleBuilder,
    this.tristate = false,
    this.visualDensity,
  });

  final bool autofocus;
  final Color? activeColor;
  final double checkboxScaleFactor;
  final String? checkboxSemanticLabel;
  final OutlinedBorder? checkboxShape;
  final Color? checkColor;
  final ListTileControlAffinity controlAffinity;
  final FastCheckboxWidgetBuilder cupertinoErrorBuilder;
  final FastCheckboxWidgetBuilder cupertinoHelperBuilder;
  final FastCheckboxWidgetBuilder cupertinoPrefixBuilder;
  final bool? dense;
  final bool? enableFeedback;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? focusColor;
  final FocusNode? focusNode;
  final Color? hoverColor;
  final Color? inactiveColor;
  final bool internalAddSemanticForOnTap;
  final bool isError;
  final bool isThreeLine;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final void Function(bool)? onFocusChange;
  final WidgetStateProperty<Color?>? overlayColor;
  final Widget? secondary;
  final Color? selectedTileColor;
  final OutlinedBorder? shape;
  final ShapeBorder? shapeBorder;
  final bool showInputDecoration;
  final BorderSide? side;
  final double? splashRadius;
  final Widget? subtitle;
  final Color? tileColor;
  final String? titleText;
  final FastCheckboxWidgetBuilder titleBuilder;
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

/// A function that is the default [FastCheckbox.cupertinoErrorBuilder].
///
/// Uses [cupertinoErrorBuilder].
Widget? checkboxErrorBuilder(FastCheckboxState field) {
  return cupertinoErrorBuilder(field);
}

/// A function that is the default [FastCheckbox.cupertinoHelperBuilder].
///
/// Uses [cupertinoHelperBuilder].
Widget? checkboxHelperBuilder(FastCheckboxState field) {
  return cupertinoHelperBuilder(field);
}

/// A function that is the default [FastCheckbox.cupertinoPrefixBuilder].
///
/// Uses [cupertinoPrefixBuilder].
Widget? checkboxPrefixBuilder(FastCheckboxState field) {
  return cupertinoPrefixBuilder(field);
}

/// A [FastCheckboxWidgetBuilder] that is the default
/// [FastCheckbox.titleBuilder].
///
/// Returns a [Text] widget when [FastCheckbox.titleText] is a [String]
/// otherwise `null`.
Widget? checkboxTitleBuilder(FastCheckboxState field) {
  final FastCheckboxState(:value!) = field;
  final FastCheckbox(:titleText) = field.widget;
  final theme = Theme.of(field.context);
  final color = theme.textTheme.titleMedium?.color ?? Colors.black;

  if (titleText is String) {
    return Text(
      titleText,
      style: TextStyle(
        color: value ? color : theme.disabledColor,
      ),
    );
  }

  return null;
}

/// The default [FastCheckbox] Material [FormFieldBuilder].
///
/// Returns an [InputDecorator] that contains a [CheckboxListTile.adaptive].
Widget materialCheckboxBuilder(FormFieldState<bool> field) {
  field as FastCheckboxState;
  final FastCheckboxState(:decoration, :didChange, :enabled, :value, :widget) =
      field;

  final checkboxListTile = CheckboxListTile.adaptive(
    activeColor: widget.activeColor,
    autofocus: widget.autofocus,
    checkColor: widget.checkColor,
    checkboxScaleFactor: widget.checkboxScaleFactor,
    checkboxSemanticLabel: widget.checkboxSemanticLabel,
    checkboxShape: widget.checkboxShape,
    contentPadding: widget.contentPadding,
    controlAffinity: widget.controlAffinity,
    dense: widget.dense,
    enabled: enabled,
    enableFeedback: widget.enableFeedback,
    fillColor: widget.fillColor,
    focusNode: widget.focusNode,
    hoverColor: widget.hoverColor,
    internalAddSemanticForOnTap: widget.internalAddSemanticForOnTap,
    isError: widget.isError,
    isThreeLine: widget.isThreeLine,
    materialTapTargetSize: widget.materialTapTargetSize,
    mouseCursor: widget.mouseCursor,
    onChanged: enabled ? didChange : null,
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
    title: widget.titleBuilder(field),
    tristate: widget.tristate,
    value: value,
    visualDensity: widget.visualDensity,
  );

  if (widget.showInputDecoration) {
    return InputDecorator(
      decoration: decoration,
      child: checkboxListTile,
    );
  }

  return checkboxListTile;
}

/// The default [FastCheckbox] Cupertino [FormFieldBuilder].
///
/// Returns a [CupertinoFormRow] that contains a [CupertinoCheckbox].
Widget cupertinoCheckboxBuilder(FormFieldState<bool> field) {
  field as FastCheckboxState;
  final FastCheckboxState(:didChange, :enabled, :value, :widget) = field;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.cupertinoPrefixBuilder(field),
    helper: widget.cupertinoHelperBuilder(field),
    error: widget.cupertinoErrorBuilder(field),
    child: CupertinoCheckbox(
      activeColor: widget.activeColor,
      autofocus: widget.autofocus,
      checkColor: widget.checkColor,
      fillColor: widget.fillColor,
      focusColor: widget.focusColor,
      focusNode: widget.focusNode,
      // ignore: deprecated_member_use
      inactiveColor: widget.inactiveColor,
      mouseCursor: widget.mouseCursor,
      onChanged: enabled ? didChange : null,
      semanticLabel: widget.checkboxSemanticLabel,
      shape: widget.shape,
      side: widget.side,
      tristate: widget.tristate,
      value: value,
    ),
  );
}

/// A [FormFieldBuilder] that is the default [FastCheckbox.builder].
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
