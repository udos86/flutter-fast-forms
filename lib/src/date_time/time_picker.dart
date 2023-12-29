import 'package:flutter/material.dart';

import '../form.dart';

typedef FastTimePickerTextBuilder = Text Function(FastTimePickerState field);

typedef ShowFastTimePicker = Future<TimeOfDay?> Function(
    TimePickerEntryMode entryMode);

typedef FastTimePickerIconButtonBuilder = IconButton Function(
    FastTimePickerState field, ShowFastTimePicker show);

/// A [FastFormField] that shows a Material Design date picker via
/// [showTimePicker].
@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  const FastTimePicker({
    super.autovalidateMode,
    super.builder = timePickerBuilder,
    super.conditions,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.cancelText,
    this.confirmText,
    this.dialogBuilder,
    this.errorInvalidText,
    this.helpText,
    this.hourLabelText,
    this.icon,
    this.iconButtonBuilder = timePickerIconButtonBuilder,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.minuteLabelText,
    this.onEntryModeChanged,
    this.orientation,
    this.routeSettings,
    this.textBuilder = timePickerTextBuilder,
    this.textStyle,
    this.useRootNavigator = true,
  });

  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final String? cancelText;
  final String? confirmText;
  final TransitionBuilder? dialogBuilder;
  final String? errorInvalidText;
  final String? helpText;
  final String? hourLabelText;
  final Icon? icon;
  final FastTimePickerIconButtonBuilder iconButtonBuilder;
  final TimePickerEntryMode initialEntryMode;
  final String? minuteLabelText;
  final EntryModeChangeCallback? onEntryModeChanged;
  final Orientation? orientation;
  final RouteSettings? routeSettings;
  final FastTimePickerTextBuilder textBuilder;
  final TextStyle? textStyle;
  final bool useRootNavigator;

  @override
  FastTimePickerState createState() => FastTimePickerState();
}

/// State associated with a [FastTimePicker] widget.
class FastTimePickerState extends FastFormFieldState<TimeOfDay> {
  @override
  FastTimePicker get widget => super.widget as FastTimePicker;
}

/// A [FastTimePickerIconButtonBuilder] that is the default
/// [FastTimePicker.iconButtonBuilder].
///
/// Returns an [IconButton] that triggers the [show] function when pressed.
IconButton timePickerIconButtonBuilder(
    FastTimePickerState field, ShowFastTimePicker show) {
  final FastTimePickerState(:enabled, :widget) = field;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? const Icon(Icons.schedule),
    onPressed: enabled ? () => show(widget.initialEntryMode) : null,
  );
}

/// A [FastTimePickerTextBuilder] that is the default
/// [FastTimePicker.textBuilder].
///
/// Returns a [Text] widget that shows the localized representation of the
/// current [FastTimePickerState.value].
Text timePickerTextBuilder(FastTimePickerState field) {
  final FastTimePickerState(:context, :enabled, :value, :widget) = field;
  final theme = Theme.of(context);
  final style = widget.textStyle ?? theme.textTheme.titleMedium;

  return Text(
    value?.format(context) ?? '',
    style: enabled ? style : style?.copyWith(color: theme.disabledColor),
    textAlign: TextAlign.left,
  );
}

/// A [FormFieldBuilder] that is the default [FastTimePicker.builder].
///
/// Returns an [InputDecorator] inside an [InkWell] that contains an
/// [IconButton] to trigger the Material Design time picker on any
/// [TargetPlatform].
Widget timePickerBuilder(FormFieldState<TimeOfDay> field) {
  final FastTimePickerState(
    :context,
    :decoration,
    :didChange,
    :enabled,
    :value,
    :widget
  ) = field as FastTimePickerState;

  Future<TimeOfDay?> show(TimePickerEntryMode entryMode) {
    return showTimePicker(
      anchorPoint: widget.anchorPoint,
      barrierColor: widget.barrierColor,
      barrierDismissible: widget.barrierDismissible,
      barrierLabel: widget.barrierLabel,
      builder: widget.dialogBuilder,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: context,
      errorInvalidText: widget.errorInvalidText,
      helpText: widget.helpText,
      hourLabelText: widget.hourLabelText,
      initialEntryMode: widget.initialEntryMode,
      initialTime: value ?? TimeOfDay.now(),
      minuteLabelText: widget.minuteLabelText,
      onEntryModeChanged: widget.onEntryModeChanged,
      orientation: widget.orientation,
      routeSettings: widget.routeSettings,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) didChange(value);
      return value;
    });
  }

  return InkWell(
    onTap: enabled ? () => show(widget.initialEntryMode) : null,
    child: InputDecorator(
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: widget.textBuilder(field),
          ),
          widget.iconButtonBuilder(field, show),
        ],
      ),
    ),
  );
}
