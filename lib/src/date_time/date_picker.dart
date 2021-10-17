import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';

typedef DatePickerTextBuilder = Text Function(FastDatePickerState state);

typedef DatePickerModalPopupBuilder = Widget Function(
    BuildContext context, FastDatePickerState state);

typedef ShowDatePicker = Future<DateTime?> Function(
    DatePickerEntryMode entryMode);

typedef DatePickerIconButtonBuilder = IconButton Function(
    FastDatePickerState state, ShowDatePicker show);

@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    bool? adaptive,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTime>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    DateTime? initialValue,
    Key? key,
    String? label,
    ValueChanged<DateTime>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    this.cancelText,
    this.confirmText,
    this.currentDate,
    this.dateFormat,
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
    this.iconButtonBuilder,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    required this.lastDate,
    this.locale,
    this.maximumYear,
    this.minimumYear = 1,
    this.minuteInterval = 1,
    this.modalCancelButtonText = 'Cancel',
    this.modalDoneButtonText = 'Done',
    this.mode = CupertinoDatePickerMode.date,
    this.routeSettings,
    this.selectableDayPredicate,
    this.showModalPopup = false,
    this.textBuilder,
    this.use24hFormat = false,
    this.useRootNavigator = true,
  }) : super(
          adaptive: adaptive,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? adaptiveDatePickerBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue ?? DateTime.now(),
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String? cancelText;
  final String? confirmText;
  final DateTime? currentDate;
  final DateFormat? dateFormat;
  final ErrorBuilder<DateTime>? errorBuilder;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final DateTime firstDate;
  final double height;
  final HelperBuilder<DateTime>? helperBuilder;
  final String? helpText;
  final Icon? icon;
  final DatePickerIconButtonBuilder? iconButtonBuilder;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;
  final Locale? locale;
  final int? maximumYear;
  final int minimumYear;
  final int minuteInterval;
  final String modalCancelButtonText;
  final String modalDoneButtonText;
  final CupertinoDatePickerMode mode;
  final RouteSettings? routeSettings;
  final SelectableDayPredicate? selectableDayPredicate;
  final bool showModalPopup;
  final DatePickerTextBuilder? textBuilder;
  final bool use24hFormat;
  final bool useRootNavigator;

  @override
  FastDatePickerState createState() => FastDatePickerState();
}

DateFormat _datePickerFormat(FastDatePickerState state) {
  final widget = state.widget;
  final locale = widget.locale;

  switch (widget.mode) {
    case CupertinoDatePickerMode.dateAndTime:
      return widget.use24hFormat
          ? DateFormat.yMMMMEEEEd(locale).add_Hm()
          : DateFormat.yMMMMEEEEd(locale).add_jm();
    case CupertinoDatePickerMode.time:
      return widget.use24hFormat
          ? DateFormat.Hm(locale)
          : DateFormat.jm(locale);
    case CupertinoDatePickerMode.date:
    default:
      return DateFormat.yMMMMEEEEd(locale);
  }
}

class FastDatePickerState extends FastFormFieldState<DateTime> {
  @override
  FastDatePicker get widget => super.widget as FastDatePicker;
}

Text datePickerTextBuilder(FastDatePickerState state) {
  final theme = Theme.of(state.context);
  final format =
      state.widget.dateFormat?.format ?? _datePickerFormat(state).format;
  final value = state.value;

  return Text(
    value != null ? format(state.value!) : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
}

IconButton datePickerIconButtonBuilder(
    FastDatePickerState state, ShowDatePicker show) {
  final widget = state.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? const Icon(Icons.today),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

Container cupertinoDatePickerModalPopupBuilder(
    BuildContext context, FastDatePickerState state) {
  final widget = state.widget;
  DateTime? modalValue = state.value;

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
            initialDateTime: state.value,
            maximumDate: widget.lastDate,
            maximumYear: widget.maximumYear,
            minimumDate: widget.firstDate,
            minimumYear: widget.minimumYear,
            minuteInterval: widget.minuteInterval,
            mode: widget.mode,
            onDateTimeChanged: (DateTime value) => modalValue = value,
            use24hFormat: widget.use24hFormat,
          ),
        ),
      ],
    ),
  );
}

CupertinoFormRow cupertinoDatePickerBuilder(FormFieldState<DateTime> field) {
  final state = field as FastDatePickerState;
  final widget = state.widget;

  final CupertinoThemeData themeData = CupertinoTheme.of(state.context);
  final TextStyle textStyle = themeData.textTheme.textStyle;
  final textBuilder = widget.textBuilder ?? datePickerTextBuilder;

  final text = Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: textBuilder(state),
    ),
  );

  return CupertinoFormRow(
    padding: widget.contentPadding,
    helper: widget.helperBuilder?.call(state) ?? helperBuilder(state),
    error: widget.errorBuilder?.call(state) ?? errorBuilder(state),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.label != null)
              DefaultTextStyle(
                style: textStyle,
                child: Text(widget.label!),
              ),
            Flexible(
              child: widget.showModalPopup
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: text,
                      onPressed: () {
                        showCupertinoModalPopup<DateTime>(
                          context: state.context,
                          builder: (BuildContext context) =>
                              cupertinoDatePickerModalPopupBuilder(
                                  context, state),
                        ).then((DateTime? value) {
                          if (value != null) state.didChange(value);
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
              initialDateTime: widget.initialValue,
              maximumDate: widget.lastDate,
              maximumYear: widget.maximumYear,
              minimumDate: widget.firstDate,
              minimumYear: widget.minimumYear,
              minuteInterval: widget.minuteInterval,
              mode: widget.mode,
              onDateTimeChanged: state.didChange,
              use24hFormat: widget.use24hFormat,
            ),
          ),
      ],
    ),
  );
}

InkWell datePickerBuilder(FormFieldState<DateTime> field) {
  final state = field as FastDatePickerState;
  final context = state.context;
  final widget = state.widget;

  final textBuilder = widget.textBuilder ?? datePickerTextBuilder;
  final iconButtonBuilder =
      widget.iconButtonBuilder ?? datePickerIconButtonBuilder;

  Future<DateTime?> show(DatePickerEntryMode entryMode) {
    return showDatePicker(
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: context,
      currentDate: widget.currentDate,
      errorFormatText: widget.errorFormatText,
      errorInvalidText: widget.errorInvalidText,
      fieldHintText: widget.fieldHintText,
      fieldLabelText: widget.fieldLabelText,
      helpText: widget.helpText,
      initialDatePickerMode: widget.initialDatePickerMode,
      initialEntryMode: entryMode,
      initialDate: widget.initialValue ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      locale: widget.locale,
      routeSettings: widget.routeSettings,
      selectableDayPredicate: widget.selectableDayPredicate,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) state.didChange(value);
      return value;
    });
  }

  return InkWell(
    onTap: widget.enabled ? () => show(DatePickerEntryMode.input) : null,
    child: InputDecorator(
      decoration: state.decoration.copyWith(
        contentPadding: widget.contentPadding,
        errorText: state.errorText,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: textBuilder(state),
          ),
          iconButtonBuilder(state, show),
        ],
      ),
    ),
  );
}

Widget adaptiveDatePickerBuilder(FormFieldState<DateTime> field) {
  final state = field as FastDatePickerState;

  if (state.adaptive) {
    switch (Theme.of(field.context).platform) {
      case TargetPlatform.iOS:
        return cupertinoDatePickerBuilder(field);
      case TargetPlatform.android:
      default:
        return datePickerBuilder(field);
    }
  }
  return datePickerBuilder(field);
}
