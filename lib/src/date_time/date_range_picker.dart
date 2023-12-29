import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../form.dart';

typedef FastDateRangePickerTextBuilder = Text Function(
    FastDateRangePickerState field);

typedef ShowFastDateRangePicker = Future<DateTimeRange?> Function(
    DatePickerEntryMode entryMode);

typedef FastDateRangePickerIconButtonBuilder = IconButton Function(
    FastDateRangePickerState field, ShowFastDateRangePicker show);

/// A [FastFormField] that shows a Material Design date range picker.
@immutable
class FastDateRangePicker extends FastFormField<DateTimeRange> {
  FastDateRangePicker({
    intl.DateFormat? format,
    super.autovalidateMode,
    super.builder = dateRangePickerBuilder,
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
    this.currentDate,
    this.dialogBuilder,
    this.errorFormatText,
    this.errorInvalidRangeText,
    this.errorInvalidText,
    this.fieldEndHintText,
    this.fieldEndLabelText,
    this.fieldStartHintText,
    this.fieldStartLabelText,
    required this.firstDate,
    this.helpText,
    this.icon,
    this.iconButtonBuilder = dateRangePickerIconButtonBuilder,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.keyboardType = TextInputType.datetime,
    this.locale,
    required this.lastDate,
    this.routeSettings,
    this.saveText,
    this.switchToCalendarEntryModeIcon,
    this.switchToInputEntryModeIcon,
    this.textBuilder = dateRangPickerTextBuilder,
    this.textDirection,
    this.textStyle,
    this.useRootNavigator = true,
  }) : dateFormat = format ?? intl.DateFormat.yMd();

  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final String? cancelText;
  final String? confirmText;
  final DateTime? currentDate;
  final intl.DateFormat dateFormat;
  final TransitionBuilder? dialogBuilder;
  final String? errorFormatText;
  final String? errorInvalidRangeText;
  final String? errorInvalidText;
  final String? fieldEndHintText;
  final String? fieldEndLabelText;
  final String? fieldStartHintText;
  final String? fieldStartLabelText;
  final DateTime firstDate;
  final String? helpText;
  final Icon? icon;
  final FastDateRangePickerIconButtonBuilder iconButtonBuilder;
  final DatePickerEntryMode initialEntryMode;
  final TextInputType keyboardType;
  final DateTime lastDate;
  final Locale? locale;
  final RouteSettings? routeSettings;
  final String? saveText;
  final Icon? switchToCalendarEntryModeIcon;
  final Icon? switchToInputEntryModeIcon;
  final FastDateRangePickerTextBuilder textBuilder;
  final TextDirection? textDirection;
  final TextStyle? textStyle;
  final bool useRootNavigator;

  @override
  FastDateRangePickerState createState() => FastDateRangePickerState();
}

/// State associated with a [FastDateRangePicker] widget.
class FastDateRangePickerState extends FastFormFieldState<DateTimeRange> {
  @override
  FastDateRangePicker get widget => super.widget as FastDateRangePicker;
}

/// Á [FastDateRangePickerTextBuilder] that is the default
/// [FastDateRangePicker.textBuilder].
///
/// Returns a [Text] widget that shows the current
/// [FastDateRangePickerState.value] formatted according to
/// [FastDateRangePicker.dateFormat]
Text dateRangPickerTextBuilder(FastDateRangePickerState field) {
  final FastDateRangePickerState(:context, :enabled, :value, :widget) = field;
  final theme = Theme.of(context);
  final format = widget.dateFormat.format;
  final style = widget.textStyle ?? theme.textTheme.titleMedium;

  return Text(
    value != null ? '${format(value.start)} - ${format(value.end)}' : '',
    style: enabled ? style : style?.copyWith(color: theme.disabledColor),
    textAlign: TextAlign.left,
  );
}

/// A [FastDateRangePickerIconButtonBuilder] that is the default
/// [FastDateRangePicker.iconButtonBuilder].
///
/// Returns an [IconButton] that triggers the [show] function when pressed.
IconButton dateRangePickerIconButtonBuilder(
    FastDateRangePickerState field, ShowFastDateRangePicker show) {
  final FastDateRangePickerState(:enabled, :widget) = field;

  return IconButton(
    alignment: Alignment.center,
    icon: const Icon(Icons.today),
    onPressed: enabled ? () => show(widget.initialEntryMode) : null,
  );
}

/// A [FormFieldBuilder] that is the default [FastDateRangePicker.builder].
///
/// Returns an [InkWell] that shows a Material Design date range picker when
/// tapped.
/// Also contains a [Text] widget that presents the current
/// [FastDateRangePickerState.value] and an [IconButton] that shows the date
/// range picker as well when pressed.
Widget dateRangePickerBuilder(FormFieldState<DateTimeRange> field) {
  final FastDateRangePickerState(
    :context,
    :decoration,
    :didChange,
    :enabled,
    :value,
    :widget
  ) = field as FastDateRangePickerState;

  Future<DateTimeRange?> show(DatePickerEntryMode entryMode) {
    return showDateRangePicker(
      anchorPoint: widget.anchorPoint,
      barrierColor: widget.barrierColor,
      barrierDismissible: widget.barrierDismissible,
      barrierLabel: widget.barrierLabel,
      builder: widget.dialogBuilder,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: context,
      currentDate: widget.currentDate,
      errorFormatText: widget.errorFormatText,
      errorInvalidRangeText: widget.errorInvalidRangeText,
      errorInvalidText: widget.errorInvalidText,
      fieldEndHintText: widget.fieldEndHintText,
      fieldEndLabelText: widget.fieldEndLabelText,
      fieldStartHintText: widget.fieldStartHintText,
      fieldStartLabelText: widget.fieldStartLabelText,
      firstDate: widget.firstDate,
      helpText: widget.helpText,
      initialEntryMode: entryMode,
      initialDateRange: value,
      keyboardType: widget.keyboardType,
      lastDate: widget.lastDate,
      locale: widget.locale,
      routeSettings: widget.routeSettings,
      saveText: widget.saveText,
      switchToCalendarEntryModeIcon: widget.switchToCalendarEntryModeIcon,
      switchToInputEntryModeIcon: widget.switchToInputEntryModeIcon,
      textDirection: widget.textDirection,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) didChange(value);
      return value;
    });
  }

  return InkWell(
    onTap: enabled ? () => show(DatePickerEntryMode.input) : null,
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
