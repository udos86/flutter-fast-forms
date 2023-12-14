import 'package:flutter/material.dart';

import '../form.dart';

typedef ShowFastTimePicker = Future<TimeOfDay?> Function(
    TimePickerEntryMode entryMode);

@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  const FastTimePicker({
    super.autovalidateMode,
    super.builder = timePickerBuilder,
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
    this.iconButtonBuilder,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.minuteLabelText,
    this.onEntryModeChanged,
    this.orientation,
    this.routeSettings,
    this.textBuilder,
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
  final IconButton Function(FastTimePickerState field, ShowFastTimePicker show)?
      iconButtonBuilder;
  final TimePickerEntryMode initialEntryMode;
  final String? minuteLabelText;
  final EntryModeChangeCallback? onEntryModeChanged;
  final Orientation? orientation;
  final RouteSettings? routeSettings;
  final Text Function(FastTimePickerState field)? textBuilder;
  final TextStyle? textStyle;
  final bool useRootNavigator;

  @override
  FastTimePickerState createState() => FastTimePickerState();
}

class FastTimePickerState extends FastFormFieldState<TimeOfDay> {
  @override
  FastTimePicker get widget => super.widget as FastTimePicker;
}

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

IconButton timePickerIconButtonBuilder(
    FastTimePickerState field, ShowFastTimePicker show) {
  final FastTimePickerState(:widget) = field;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? const Icon(Icons.schedule),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

Widget timePickerBuilder(FormFieldState<TimeOfDay> field) {
  field as FastTimePickerState;
  final FastTimePickerState(
    :context,
    :decoration,
    :didChange,
    :value,
    :widget
  ) = field;
  final textBuilder = widget.textBuilder ?? timePickerTextBuilder;
  final iconButtonBuilder =
      widget.iconButtonBuilder ?? timePickerIconButtonBuilder;

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
    onTap: widget.enabled ? () => show(widget.initialEntryMode) : null,
    child: InputDecorator(
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: textBuilder(field),
          ),
          iconButtonBuilder(field, show),
        ],
      ),
    ),
  );
}
