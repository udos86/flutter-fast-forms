import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../form.dart';

typedef FastSwitchTitleBuilder = Widget Function(FastSwitchState field);

@immutable
class FastSwitch extends FastFormField<bool> {
  const FastSwitch({
    super.adaptive,
    super.autovalidateMode,
    super.builder = switchBuilder,
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
    this.activeThumbImage,
    this.activeTrackColor,
    this.autofocus = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.dragStartBehavior = DragStartBehavior.start,
    this.dense,
    this.enableFeedback,
    this.errorBuilder,
    this.focusNode,
    this.helperBuilder,
    this.hoverColor,
    this.inactiveThumbColor,
    this.inactiveThumbImage,
    this.inactiveTrackColor,
    this.isThreeLine = false,
    this.secondary,
    this.selectedTileColor,
    this.shapeBorder,
    this.subtitle,
    this.thumbColor,
    this.tileColor,
    this.titleText,
    this.titleBuilder,
    this.visualDensity,
  });

  final Color? activeColor;
  final ImageProvider<Object>? activeThumbImage;
  final Color? activeTrackColor;
  final bool autofocus;
  final ListTileControlAffinity controlAffinity;
  final bool? dense;
  final DragStartBehavior dragStartBehavior;
  final bool? enableFeedback;
  final FastErrorBuilder<bool>? errorBuilder;
  final FocusNode? focusNode;
  final FastHelperBuilder<bool>? helperBuilder;
  final Color? hoverColor;
  final Color? inactiveThumbColor;
  final ImageProvider<Object>? inactiveThumbImage;
  final Color? inactiveTrackColor;
  final bool isThreeLine;
  final Widget? secondary;
  final Color? selectedTileColor;
  final ShapeBorder? shapeBorder;
  final Widget? subtitle;
  final Color? thumbColor;
  final Color? tileColor;
  final String? titleText;
  final FastSwitchTitleBuilder? titleBuilder;
  final VisualDensity? visualDensity;

  @override
  FastSwitchState createState() => FastSwitchState();
}

class FastSwitchState extends FastFormFieldState<bool> {
  @override
  FastSwitch get widget => super.widget as FastSwitch;
}

Widget switchTitleBuilder(FastSwitchState field) {
  return Text(
    field.widget.titleText!,
    style: TextStyle(
      fontSize: 14.0,
      color: field.value! ? Colors.black : Colors.grey,
    ),
  );
}

Widget materialSwitchBuilder(FormFieldState<bool> field) {
  final widget = (field as FastSwitchState).widget;
  final titleBuilder = widget.titleBuilder ?? switchTitleBuilder;

  return InputDecorator(
    decoration: field.decoration,
    child: SwitchListTile.adaptive(
      activeColor: widget.activeColor,
      activeThumbImage: widget.activeThumbImage,
      activeTrackColor: widget.activeTrackColor,
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      controlAffinity: widget.controlAffinity,
      dense: widget.dense,
      enableFeedback: widget.enableFeedback,
      focusNode: widget.focusNode,
      hoverColor: widget.hoverColor,
      inactiveThumbColor: widget.inactiveThumbColor,
      inactiveThumbImage: widget.inactiveThumbImage,
      inactiveTrackColor: widget.inactiveTrackColor,
      isThreeLine: widget.isThreeLine,
      onChanged: widget.enabled ? field.didChange : null,
      secondary: widget.secondary,
      selected: field.value!,
      selectedTileColor: widget.selectedTileColor,
      shape: widget.shapeBorder,
      subtitle: widget.subtitle,
      tileColor: widget.tileColor,
      title: widget.titleText is String ? titleBuilder(field) : null,
      value: field.value!,
      visualDensity: widget.visualDensity,
    ),
  );
}

Widget cupertinoSwitchBuilder(FormFieldState<bool> field) {
  final widget = (field as FastSwitchState).widget;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.labelText is String ? Text(widget.labelText!) : null,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: CupertinoSwitch(
      activeColor: widget.activeColor,
      dragStartBehavior: widget.dragStartBehavior,
      onChanged: widget.enabled ? field.didChange : null,
      thumbColor: widget.thumbColor,
      trackColor: widget.activeTrackColor,
      value: field.value!,
    ),
  );
}

Widget switchBuilder(FormFieldState<bool> field) {
  var builder = materialSwitchBuilder;

  if ((field as FastSwitchState).adaptive) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        builder = cupertinoSwitchBuilder;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      default:
        builder = materialSwitchBuilder;
        break;
    }
  }

  return builder(field);
}
