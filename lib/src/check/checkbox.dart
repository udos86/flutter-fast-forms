import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../form.dart';

typedef FastCheckboxTitleBuilder = Widget? Function(FastCheckboxState field);

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
  final FastCheckboxTitleBuilder? titleBuilder;
  final bool tristate;
  final VisualDensity? visualDensity;

  @override
  FastCheckboxState createState() => FastCheckboxState();
}

class FastCheckboxState extends FastFormFieldState<bool> {
  @override
  FastCheckbox get widget => super.widget as FastCheckbox;
}

Widget? checkboxTitleBuilder(FastCheckboxState field) {
  return field.widget.titleText is String
      ? Text(
          field.widget.titleText!,
          style: TextStyle(
            fontSize: 14.0,
            color: field.value! ? Colors.black : Colors.grey,
          ),
        )
      : null;
}

Widget materialCheckboxBuilder(FormFieldState<bool> field) {
  final widget = (field as FastCheckboxState).widget;
  final titleBuilder = widget.titleBuilder ?? checkboxTitleBuilder;

  return InputDecorator(
    decoration: field.decoration,
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
      onChanged: widget.enabled ? field.didChange : null,
      onFocusChange: widget.onFocusChange,
      overlayColor: widget.overlayColor,
      secondary: widget.secondary,
      selected: field.value ?? false,
      selectedTileColor: widget.selectedTileColor,
      shape: widget.shapeBorder,
      side: widget.side,
      splashRadius: widget.splashRadius,
      subtitle: widget.subtitle,
      tileColor: widget.tileColor,
      title: titleBuilder(field),
      tristate: widget.tristate,
      value: field.value,
      visualDensity: widget.visualDensity,
    ),
  );
}

Widget cupertinoCheckboxBuilder(FormFieldState<bool> field) {
  final widget = (field as FastCheckboxState).widget;

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
      onChanged: widget.enabled ? field.didChange : null,
      shape: widget.shape,
      side: widget.side,
      tristate: widget.tristate,
      value: field.value!,
    ),
  );
}

Widget checkboxBuilder(FormFieldState<bool> field) {
  var builder = materialCheckboxBuilder;

  if ((field as FastCheckboxState).adaptive) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        builder = cupertinoCheckboxBuilder;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
        builder = materialCheckboxBuilder;
        break;
    }
  }

  return builder(field);
}
