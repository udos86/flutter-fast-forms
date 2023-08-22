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
    this.applyTheme,
    this.autofocus = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.dragStartBehavior = DragStartBehavior.start,
    this.dense,
    this.enableFeedback,
    this.errorBuilder,
    this.focusColor,
    this.focusNode,
    this.helperBuilder,
    this.hoverColor,
    this.inactiveThumbColor,
    this.inactiveThumbImage,
    this.inactiveTrackColor,
    this.isThreeLine = false,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.onActiveThumbImageError,
    this.onFocusChange,
    this.onInactiveThumbImageError,
    this.overlayColor,
    this.secondary,
    this.selectedTileColor,
    this.shapeBorder,
    this.splashRadius,
    this.subtitle,
    this.thumbColor,
    this.thumbIcon,
    this.tileColor,
    this.titleText,
    this.titleBuilder,
    this.trackColor,
    this.trackOutlineColor,
    this.visualDensity,
  });

  final Color? activeColor;
  final ImageProvider<Object>? activeThumbImage;
  final Color? activeTrackColor;
  final bool? applyTheme;
  final bool autofocus;
  final ListTileControlAffinity controlAffinity;
  final bool? dense;
  final DragStartBehavior dragStartBehavior;
  final bool? enableFeedback;
  final FastErrorBuilder<bool>? errorBuilder;
  final Color? focusColor;
  final FocusNode? focusNode;
  final FastHelperBuilder<bool>? helperBuilder;
  final Color? hoverColor;
  final Color? inactiveThumbColor;
  final ImageProvider<Object>? inactiveThumbImage;
  final Color? inactiveTrackColor;
  final bool isThreeLine;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final void Function(Object, StackTrace?)? onActiveThumbImageError;
  final void Function(bool)? onFocusChange;
  final void Function(Object, StackTrace?)? onInactiveThumbImageError;
  final MaterialStateProperty<Color?>? overlayColor;
  final Widget? secondary;
  final Color? selectedTileColor;
  final ShapeBorder? shapeBorder;
  final double? splashRadius;
  final Widget? subtitle;
  final dynamic thumbColor;
  final MaterialStateProperty<Icon?>? thumbIcon;
  final Color? tileColor;
  final String? titleText;
  final MaterialStateProperty<Color?>? trackColor;
  final MaterialStateProperty<Color?>? trackOutlineColor;
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
  assert(widget.thumbColor == null ||
      widget.thumbColor is MaterialStateProperty<Color?>);

  final titleBuilder = widget.titleBuilder ?? switchTitleBuilder;

  return InputDecorator(
    decoration: field.decoration,
    child: SwitchListTile.adaptive(
      activeColor: widget.activeColor,
      activeThumbImage: widget.activeThumbImage,
      activeTrackColor: widget.activeTrackColor,
      applyCupertinoTheme: widget.applyTheme,
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      controlAffinity: widget.controlAffinity,
      dense: widget.dense,
      dragStartBehavior: widget.dragStartBehavior,
      enableFeedback: widget.enableFeedback,
      focusNode: widget.focusNode,
      hoverColor: widget.hoverColor,
      inactiveThumbColor: widget.inactiveThumbColor,
      inactiveThumbImage: widget.inactiveThumbImage,
      inactiveTrackColor: widget.inactiveTrackColor,
      isThreeLine: widget.isThreeLine,
      materialTapTargetSize: widget.materialTapTargetSize,
      mouseCursor: widget.mouseCursor,
      onActiveThumbImageError: widget.onActiveThumbImageError,
      onChanged: widget.enabled ? field.didChange : null,
      onFocusChange: widget.onFocusChange,
      onInactiveThumbImageError: widget.onInactiveThumbImageError,
      overlayColor: widget.overlayColor,
      secondary: widget.secondary,
      selected: field.value!,
      selectedTileColor: widget.selectedTileColor,
      shape: widget.shapeBorder,
      splashRadius: widget.splashRadius,
      subtitle: widget.subtitle,
      thumbColor: widget.thumbColor,
      thumbIcon: widget.thumbIcon,
      tileColor: widget.tileColor,
      title: widget.titleText is String ? titleBuilder(field) : null,
      trackColor: widget.trackColor,
      trackOutlineColor: widget.trackOutlineColor,
      value: field.value!,
      visualDensity: widget.visualDensity,
    ),
  );
}

Widget cupertinoSwitchBuilder(FormFieldState<bool> field) {
  final widget = (field as FastSwitchState).widget;
  assert(widget.thumbColor == null || widget.thumbColor is Color);

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.labelText is String ? Text(widget.labelText!) : null,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: CupertinoSwitch(
      activeColor: widget.activeColor,
      applyTheme: widget.applyTheme,
      autofocus: widget.autofocus,
      dragStartBehavior: widget.dragStartBehavior,
      focusColor: widget.focusColor,
      focusNode: widget.focusNode,
      onChanged: widget.enabled ? field.didChange : null,
      onFocusChange: widget.onFocusChange,
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
