import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../form.dart';

typedef FastDatePickerTextBuilder = Text Function(FastDatePickerState field);

typedef FastDatePickerModalPopupBuilder = Widget Function(
    BuildContext context, FastDatePickerState field);

typedef ShowFastDatePicker = Future<DateTime?> Function(
    DatePickerEntryMode entryMode);

typedef FastDatePickerIconButtonBuilder = IconButton Function(
    FastDatePickerState field, ShowFastDatePicker show);

/// A [FastFormField] that shows either a Material Design date picker via
/// [showDatePicker] or a [CupertinoDatePicker] via [showCupertinoModalPopup].
@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    DateTime? initialValue,
    super.adaptive,
    super.autovalidateMode,
    super.builder = datePickerBuilder,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.anchorPoint,
    this.backgroundColor,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.cancelText,
    this.confirmText,
    this.currentDate,
    this.dateFormat,
    this.dateOrder,
    this.dialogBuilder,
    this.errorBuilder,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    required this.firstDate,
    this.helperBuilder,
    this.height = 216.0,
    this.helpText,
    this.icon,
    this.iconButtonBuilder = datePickerIconButtonBuilder,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.keyboardType,
    required this.lastDate,
    this.locale,
    this.maximumYear,
    this.minimumYear = 1,
    this.minuteInterval = 1,
    this.modalCancelButtonText = 'Cancel',
    this.modalDoneButtonText = 'Done',
    this.mode = CupertinoDatePickerMode.date,
    this.onDatePickerModeChange,
    this.routeSettings,
    this.selectableDayPredicate,
    this.showDayOfWeek = false,
    this.showModalPopup = false,
    this.switchToCalendarEntryModeIcon,
    this.switchToInputEntryModeIcon,
    this.textBuilder = datePickerTextBuilder,
    this.textDirection,
    this.textStyle,
    this.use24hFormat = false,
    this.useRootNavigator = true,
  }) : super(initialValue: initialValue ?? DateTime.now());

  final Offset? anchorPoint;
  final Color? backgroundColor;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final String? cancelText;
  final String? confirmText;
  final DateTime? currentDate;
  final intl.DateFormat? dateFormat;
  final DatePickerDateOrder? dateOrder;
  final TransitionBuilder? dialogBuilder;
  final FastErrorBuilder<DateTime>? errorBuilder;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final DateTime firstDate;
  final double height;
  final FastHelperBuilder<DateTime>? helperBuilder;
  final String? helpText;
  final Icon? icon;
  final FastDatePickerIconButtonBuilder iconButtonBuilder;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final TextInputType? keyboardType;
  final DateTime lastDate;
  final Locale? locale;
  final int? maximumYear;
  final int minimumYear;
  final int minuteInterval;
  final String modalCancelButtonText;
  final String modalDoneButtonText;
  final CupertinoDatePickerMode mode;
  final void Function(DatePickerEntryMode)? onDatePickerModeChange;
  final RouteSettings? routeSettings;
  final SelectableDayPredicate? selectableDayPredicate;
  final bool showDayOfWeek;
  final bool showModalPopup;
  final Icon? switchToCalendarEntryModeIcon;
  final Icon? switchToInputEntryModeIcon;
  final FastDatePickerTextBuilder textBuilder;
  final TextDirection? textDirection;
  final TextStyle? textStyle;
  final bool use24hFormat;
  final bool useRootNavigator;

  @override
  FastDatePickerState createState() => FastDatePickerState();
}

/// State associated with a [FastDatePicker] widget.
class FastDatePickerState extends FastFormFieldState<DateTime> {
  @override
  FastDatePicker get widget => super.widget as FastDatePicker;
}

/// Returns the default [intl.DateFormat] to be used in [datePickerTextBuilder]
/// depending on [FastDatePicker.mode] and [FastDatePicker.use24hFormat].
intl.DateFormat _datePickerFormat(FastDatePickerState field) {
  final FastDatePicker(:locale, :mode, :use24hFormat) = field.widget;

  switch (mode) {
    case CupertinoDatePickerMode.dateAndTime:
      final format = intl.DateFormat.yMMMMEEEEd(locale);
      return use24hFormat ? format.add_Hm() : format.add_jm();
    case CupertinoDatePickerMode.time:
      final format = use24hFormat ? intl.DateFormat.Hm : intl.DateFormat.jm;
      return format(locale);
    case CupertinoDatePickerMode.date:
    default:
      return intl.DateFormat.yMMMMEEEEd(locale);
  }
}

/// A [FastDatePickerTextBuilder] that is the default
/// [FastDatePicker.textBuilder].
///
/// Returns a [Text] widget that shows the current [FastDatePickerState.value]
/// formatted according either to [FastDatePicker.dateFormat] or
/// [_datePickerFormat].
Text datePickerTextBuilder(FastDatePickerState field) {
  final FastDatePickerState(:context, :enabled, :value, :widget) = field;
  final theme = Theme.of(context);
  final format = widget.dateFormat?.format ?? _datePickerFormat(field).format;
  final style = widget.textStyle ?? theme.textTheme.titleMedium;

  return Text(
    value != null ? format(value) : '',
    style: enabled ? style : style?.copyWith(color: theme.disabledColor),
    textAlign: TextAlign.left,
  );
}

/// A [FastDatePickerIconButtonBuilder] that is the default
/// [FastDatePicker.iconButtonBuilder].
///
/// Returns an [IconButton] that triggers the [show] function when pressed.
IconButton datePickerIconButtonBuilder(
    FastDatePickerState field, ShowFastDatePicker show) {
  final FastDatePickerState(:widget) = field;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? const Icon(Icons.today),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

/// A [FastDatePickerModalPopupBuilder] that returns a modal popup that contains
/// a [CupertinoDatePicker];
///
/// Used when [FastDatePicker.showModalPopup] is true to show a
/// [CupertinoDatePicker] in a modal popup via [showCupertinoModalPopup] .
Container cupertinoDatePickerModalPopupBuilder(
    BuildContext context, FastDatePickerState field) {
  final FastDatePickerState(:value, :widget) = field;
  DateTime? modalValue = value;

  return Container(
    color: CupertinoColors.systemBackground,
    height: widget.height + 90.0,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 16.0, 16.0),
              child: Text(widget.modalCancelButtonText),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            CupertinoButton(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 24.0, 16.0),
              child: Text(
                widget.modalDoneButtonText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(modalValue),
            ),
          ],
        ),
        const Divider(
          height: 1.0,
          thickness: 1.0,
        ),
        Container(
          padding: const EdgeInsets.only(top: 6.0),
          height: widget.height,
          child: CupertinoDatePicker(
            backgroundColor: widget.backgroundColor,
            dateOrder: widget.dateOrder,
            initialDateTime: value,
            maximumDate: widget.lastDate,
            maximumYear: widget.maximumYear,
            minimumDate: widget.firstDate,
            minimumYear: widget.minimumYear,
            minuteInterval: widget.minuteInterval,
            mode: widget.mode,
            onDateTimeChanged: (DateTime value) => modalValue = value,
            showDayOfWeek: widget.showDayOfWeek,
            use24hFormat: widget.use24hFormat,
          ),
        ),
      ],
    ),
  );
}

/// The default [FastDatePicker] Material [FormFieldBuilder].
///
/// Returns an [InkWell] that shows a Material Design date picker when tapped.
/// Also contains a [Text] widget that presents the current
/// [FastDatePickerState.value] and an [IconButton] that shows the date picker
/// as well when pressed.
Widget materialDatePickerBuilder(FormFieldState<DateTime> field) {
  final FastDatePickerState(:context, :didChange, :widget) =
      field as FastDatePickerState;

  Future<DateTime?> show(DatePickerEntryMode entryMode) {
    return showDatePicker(
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
      errorInvalidText: widget.errorInvalidText,
      fieldHintText: widget.fieldHintText,
      fieldLabelText: widget.fieldLabelText,
      firstDate: widget.firstDate,
      helpText: widget.helpText,
      initialDatePickerMode: widget.initialDatePickerMode,
      initialEntryMode: entryMode,
      initialDate: widget.initialValue ?? DateTime.now(),
      keyboardType: widget.keyboardType,
      lastDate: widget.lastDate,
      locale: widget.locale,
      onDatePickerModeChange: widget.onDatePickerModeChange,
      routeSettings: widget.routeSettings,
      selectableDayPredicate: widget.selectableDayPredicate,
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
    onTap: widget.enabled ? () => show(DatePickerEntryMode.input) : null,
    child: InputDecorator(
      decoration: field.decoration,
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

/// The default [FastDatePicker] Cupertino [FormFieldBuilder].
///
/// Returns a [CupertinoFormRow] that contains either a [CupertinoDatePicker]
/// or a [CupertinoButton] that shows a [CupertinoDatePicker] inside a modal
/// popup when pressed.
Widget cupertinoDatePickerBuilder(FormFieldState<DateTime> field) {
  final FastDatePickerState(:context, :didChange, :widget) =
      field as FastDatePickerState;
  final CupertinoThemeData themeData = CupertinoTheme.of(field.context);
  final TextStyle textStyle = themeData.textTheme.textStyle;

  final text = Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: widget.textBuilder(field),
    ),
  );

  return CupertinoFormRow(
    padding: widget.contentPadding,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.labelText != null)
              DefaultTextStyle(
                style: textStyle,
                child: Text(widget.labelText!),
              ),
            Flexible(
              child: widget.showModalPopup
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: text,
                      onPressed: () {
                        showCupertinoModalPopup<DateTime>(
                          context: context,
                          builder: (BuildContext context) =>
                              cupertinoDatePickerModalPopupBuilder(
                                  context, field),
                        ).then((DateTime? value) {
                          if (value != null) didChange(value);
                        });
                      },
                    )
                  : text,
            ),
          ],
        ),
        if (!widget.showModalPopup)
          SizedBox(
            height: widget.height,
            child: CupertinoDatePicker(
              backgroundColor: widget.backgroundColor,
              dateOrder: widget.dateOrder,
              initialDateTime: widget.initialValue,
              maximumDate: widget.lastDate,
              maximumYear: widget.maximumYear,
              minimumDate: widget.firstDate,
              minimumYear: widget.minimumYear,
              minuteInterval: widget.minuteInterval,
              mode: widget.mode,
              onDateTimeChanged: didChange,
              showDayOfWeek: widget.showDayOfWeek,
              use24hFormat: widget.use24hFormat,
            ),
          ),
      ],
    ),
  );
}

/// A [FormFieldBuilder] that is the default [FastDatePicker.builder].
///
/// Uses [materialDatePickerBuilder] by default on any [TargetPlatform].
///
/// Uses [cupertinoDatePickerBuilder] on [TargetPlatform.iOS] when
/// [FastSwitchState.adaptive] is true.
Widget datePickerBuilder(FormFieldState<DateTime> field) {
  field as FastDatePickerState;

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS when field.adaptive:
      return cupertinoDatePickerBuilder(field);
    default:
      return materialDatePickerBuilder(field);
  }
}
