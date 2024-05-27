import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../form.dart';

typedef FastSwitchWidgetBuilder = FastWidgetBuilder<FastSwitchState>;

/// A [FastFormField] that contains either a [SwitchListTile.adaptive] or a
/// [CupertinoSwitch].
@immutable
class FastSwitch extends FastFormField<bool> {
  const FastSwitch({
    super.adaptive,
    super.autovalidateMode,
    super.builder = switchBuilder,
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
    this.activeThumbImage,
    this.activeTrackColor,
    this.applyTheme,
    this.autofocus = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.cupertinoErrorBuilder = switchErrorBuilder,
    this.cupertinoHelperBuilder = switchHelperBuilder,
    this.cupertinoPrefixBuilder = switchPrefixBuilder,
    this.dragStartBehavior = DragStartBehavior.start,
    this.dense,
    this.enableFeedback,
    this.focusColor,
    this.focusNode,
    this.hoverColor,
    this.inactiveThumbColor,
    this.inactiveThumbImage,
    this.inactiveTrackColor,
    this.isThreeLine = false,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.offLabelColor,
    this.onActiveThumbImageError,
    this.onFocusChange,
    this.onInactiveThumbImageError,
    this.onLabelColor,
    this.overlayColor,
    this.secondary,
    this.selectedTileColor,
    this.shapeBorder,
    this.showInputDecoration = true,
    this.splashRadius,
    this.subtitle,
    this.thumbColor,
    this.thumbIcon,
    this.tileColor,
    this.titleText,
    this.titleBuilder = switchTitleBuilder,
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
  final FastSwitchWidgetBuilder cupertinoErrorBuilder;
  final FastSwitchWidgetBuilder cupertinoHelperBuilder;
  final FastSwitchWidgetBuilder cupertinoPrefixBuilder;
  final bool? dense;
  final DragStartBehavior dragStartBehavior;
  final bool? enableFeedback;
  final Color? focusColor;
  final FocusNode? focusNode;
  final Color? hoverColor;
  final Color? inactiveThumbColor;
  final ImageProvider<Object>? inactiveThumbImage;
  final Color? inactiveTrackColor;
  final bool isThreeLine;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final Color? offLabelColor;
  final void Function(Object, StackTrace?)? onActiveThumbImageError;
  final void Function(bool)? onFocusChange;
  final void Function(Object, StackTrace?)? onInactiveThumbImageError;
  final Color? onLabelColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final Widget? secondary;
  final Color? selectedTileColor;
  final ShapeBorder? shapeBorder;
  final bool showInputDecoration;
  final double? splashRadius;
  final Widget? subtitle;
  final dynamic thumbColor;
  final WidgetStateProperty<Icon?>? thumbIcon;
  final Color? tileColor;
  final String? titleText;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Color?>? trackOutlineColor;
  final FastSwitchWidgetBuilder titleBuilder;
  final VisualDensity? visualDensity;

  @override
  FastSwitchState createState() => FastSwitchState();
}

/// State associated with a [FastSwitch] widget.
class FastSwitchState extends FastFormFieldState<bool> {
  @override
  FastSwitch get widget => super.widget as FastSwitch;
}

/// A function that is the default [FastSwitch.cupertinoErrorBuilder].
///
/// Uses [cupertinoErrorBuilder].
Widget? switchErrorBuilder(FastSwitchState field) {
  return cupertinoErrorBuilder(field);
}

/// A function that is the default [FastSwitch.cupertinoHelperBuilder].
///
/// Uses [cupertinoHelperBuilder].
Widget? switchHelperBuilder(FastSwitchState field) {
  return cupertinoHelperBuilder(field);
}

/// A function that is the default [FastSwitch.cupertinoPrefixBuilder].
///
/// Uses [cupertinoPrefixBuilder].
Widget? switchPrefixBuilder(FastSwitchState field) {
  return cupertinoPrefixBuilder(field);
}

/// A [FastSwitchTitleBuilder] that is the default [FastSwitch.titleBuilder].
///
/// Returns a [Text] widget when [FastSwitch.titleText] is a [String]
/// otherwise null.
Widget? switchTitleBuilder(FastSwitchState field) {
  final FastSwitchState(:value!, :widget) = field;
  final FastSwitch(:titleText) = widget;
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

/// The default [FastSwitch] Material [FormFieldBuilder].
///
/// Returns an [InputDecorator] that contains a [SwitchListTile.adaptive].
Widget materialSwitchBuilder(FormFieldState<bool> field) {
  field as FastSwitchState;
  final FastSwitchState(:decoration, :didChange, :enabled, :value!, :widget) =
      field;
  assert(widget.thumbColor == null ||
      widget.thumbColor is WidgetStateProperty<Color?>);

  final switchListTile = SwitchListTile.adaptive(
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
    onChanged: enabled ? didChange : null,
    onFocusChange: widget.onFocusChange,
    onInactiveThumbImageError: widget.onInactiveThumbImageError,
    overlayColor: widget.overlayColor,
    secondary: widget.secondary,
    selected: value,
    selectedTileColor: widget.selectedTileColor,
    shape: widget.shapeBorder,
    splashRadius: widget.splashRadius,
    subtitle: widget.subtitle,
    thumbColor: widget.thumbColor,
    thumbIcon: widget.thumbIcon,
    tileColor: widget.tileColor,
    title: widget.titleBuilder(field),
    trackColor: widget.trackColor,
    trackOutlineColor: widget.trackOutlineColor,
    value: value,
    visualDensity: widget.visualDensity,
  );

  if (widget.showInputDecoration) {
    return InputDecorator(
      decoration: decoration,
      child: switchListTile,
    );
  }

  return switchListTile;
}

/// The default [FastSwitch] Cupertino [FormFieldBuilder].
///
/// Returns a [CupertinoFormRow] that contains a [CupertinoSwitch].
Widget cupertinoSwitchBuilder(FormFieldState<bool> field) {
  field as FastSwitchState;
  final FastSwitchState(:didChange, :enabled, :value!, :widget) = field;
  assert(widget.thumbColor == null || widget.thumbColor is Color);

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.cupertinoPrefixBuilder(field),
    helper: widget.cupertinoHelperBuilder(field),
    error: widget.cupertinoErrorBuilder(field),
    child: CupertinoSwitch(
      offLabelColor: widget.offLabelColor,
      onLabelColor: widget.onLabelColor,
      activeColor: widget.activeColor,
      applyTheme: widget.applyTheme,
      autofocus: widget.autofocus,
      dragStartBehavior: widget.dragStartBehavior,
      focusColor: widget.focusColor,
      focusNode: widget.focusNode,
      onChanged: enabled ? didChange : null,
      onFocusChange: widget.onFocusChange,
      thumbColor: widget.thumbColor,
      trackColor: widget.activeTrackColor,
      value: value,
    ),
  );
}

/// A [FormFieldBuilder] that is the default [FastSwitch.builder].
///
/// Uses [materialSwitchBuilder] by default on any [TargetPlatform].
///
/// Uses [cupertinoSwitchBuilder] on [TargetPlatform.iOS] when
/// [FastSwitchState.adaptive] is true.
Widget switchBuilder(FormFieldState<bool> field) {
  field as FastSwitchState;

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS when field.adaptive:
      return cupertinoSwitchBuilder(field);
    default:
      return materialSwitchBuilder(field);
  }
}
