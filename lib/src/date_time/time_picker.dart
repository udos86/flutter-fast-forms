import 'package:flutter/material.dart';

import '../form.dart';

typedef FastTimePickerTextBuilder = Text Function(FastTimePickerState field);

typedef ShowFastTimePicker = Future<TimeOfDay?> Function(
    TimePickerEntryMode entryMode);

typedef FastTimePickerIconButtonBuilder = IconButton Function(
    FastTimePickerState field, ShowFastTimePicker show);

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
    this.routeSettings,
    this.textBuilder,
    this.useRootNavigator = true,
  });

  final Offset? anchorPoint;
  final String? cancelText;
  final String? confirmText;
  final TransitionBuilder? dialogBuilder;
  final String? errorInvalidText;
  final String? helpText;
  final String? hourLabelText;
  final Icon? icon;
  final FastTimePickerIconButtonBuilder? iconButtonBuilder;
  final TimePickerEntryMode initialEntryMode;
  final String? minuteLabelText;
  final EntryModeChangeCallback? onEntryModeChanged;
  final RouteSettings? routeSettings;
  final FastTimePickerTextBuilder? textBuilder;
  final bool useRootNavigator;

  @override
  FastTimePickerState createState() => FastTimePickerState();
}

class FastTimePickerState extends FastFormFieldState<TimeOfDay> {
  @override
  FastTimePicker get widget => super.widget as FastTimePicker;
}

Text timePickerTextBuilder(FastTimePickerState field) {
  final theme = Theme.of(field.context);

  return Text(
    field.value?.format(field.context) ?? '',
    style: theme.textTheme.titleMedium,
    textAlign: TextAlign.left,
  );
}

IconButton timePickerIconButtonBuilder(
    FastTimePickerState field, ShowFastTimePicker show) {
  final widget = field.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? const Icon(Icons.schedule),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

Widget timePickerBuilder(FormFieldState<TimeOfDay> field) {
  final widget = (field as FastTimePickerState).widget;
  final textBuilder = widget.textBuilder ?? timePickerTextBuilder;
  final iconButtonBuilder =
      widget.iconButtonBuilder ?? timePickerIconButtonBuilder;

  Future<TimeOfDay?> show(TimePickerEntryMode entryMode) {
    return showTimePicker(
      anchorPoint: widget.anchorPoint,
      builder: widget.dialogBuilder,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: field.context,
      errorInvalidText: widget.errorInvalidText,
      helpText: widget.helpText,
      hourLabelText: widget.hourLabelText,
      initialEntryMode: widget.initialEntryMode,
      initialTime: field.value ?? TimeOfDay.now(),
      minuteLabelText: widget.minuteLabelText,
      onEntryModeChanged: widget.onEntryModeChanged,
      routeSettings: widget.routeSettings,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) field.didChange(value);
      return value;
    });
  }

  return InkWell(
    onTap: widget.enabled ? () => show(widget.initialEntryMode) : null,
    child: InputDecorator(
      decoration: field.decoration,
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
