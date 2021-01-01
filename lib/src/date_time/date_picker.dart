import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef DatePickerTextBuilder = Text Function(FastDatePickerState state);

typedef ShowDatePicker = Future<DateTime?> Function(
    DatePickerEntryMode entryMode);

typedef DatePickerIconButtonBuilder = IconButton Function(
    FastDatePickerState state, ShowDatePicker show);

@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTime>? builder,
    this.cancelText,
    this.confirmText,
    this.contentPadding,
    this.currentDate,
    this.dateFormat,
    InputDecoration? decoration,
    bool enabled = true,
    this.errorBuilder,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    required this.firstDate,
    this.helperBuilder,
    this.height = 216.0,
    String? helperText,
    this.helpText,
    this.icon,
    this.iconButtonBuilder,
    required String id,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    DateTime? initialValue,
    Key? key,
    String? label,
    required this.lastDate,
    this.locale,
    this.maximumYear,
    this.minimumYear = 1,
    this.minuteInterval = 1,
    this.mode = CupertinoDatePickerMode.date,
    ValueChanged<DateTime>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<DateTime>? onSaved,
    this.routeSettings,
    this.selectableDayPredicate,
    this.textBuilder,
    this.use24hFormat = false,
    this.useRootNavigator = true,
    FormFieldValidator<DateTime>? validator,
  })  : initialValue = initialValue ?? DateTime.now(),
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder = scope?.builders[FastDatePicker] ??
                    adaptiveDatePickerBuilder;
                return builder(field);
              },
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String? cancelText;
  final String? confirmText;
  final EdgeInsetsGeometry? contentPadding;
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
  final DateTime initialValue;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;
  final Locale? locale;
  final int? maximumYear;
  final int minimumYear;
  final int minuteInterval;
  final CupertinoDatePickerMode mode;
  final RouteSettings? routeSettings;
  final SelectableDayPredicate? selectableDayPredicate;
  final DatePickerTextBuilder? textBuilder;
  final bool use24hFormat;
  final bool useRootNavigator;

  @override
  FastDatePickerState createState() => FastDatePickerState();
}

DateFormat _format(CupertinoDatePickerMode mode) {
  switch (mode) {
    case CupertinoDatePickerMode.dateAndTime:
      return DateFormat('EEEE, MMMM d, y HH:mm');
    case CupertinoDatePickerMode.time:
      return DateFormat.Hm();
    case CupertinoDatePickerMode.date:
    default:
      return DateFormat.yMMMMEEEEd();
  }
}

class FastDatePickerState extends FastFormFieldState<DateTime> {
  @override
  FastDatePicker get widget => super.widget as FastDatePicker;
}

final DatePickerTextBuilder datePickerTextBuilder =
    (FastDatePickerState state) {
  final widget = state.widget;
  final theme = Theme.of(state.context);
  final format = state.widget.dateFormat?.format ?? _format(widget.mode).format;
  final value = state.value;

  return Text(
    value != null ? format(state.value!) : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
};

final DatePickerIconButtonBuilder datePickerIconButtonBuilder =
    (FastDatePickerState state, ShowDatePicker show) {
  final widget = state.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? Icon(Icons.today),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
};

final FormFieldBuilder<DateTime> cupertinoDatePickerBuilder =
    (FormFieldState<DateTime> field) {
  final state = field as FastDatePickerState;
  final widget = state.widget;

  final CupertinoThemeData themeData = CupertinoTheme.of(state.context);
  final TextStyle textStyle = themeData.textTheme.textStyle;
  final textBuilder = widget.textBuilder ?? datePickerTextBuilder;

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
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: textBuilder(state),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: widget.height,
          child: CupertinoDatePicker(
            initialDateTime: widget.initialValue,
            maximumDate: widget.lastDate,
            minimumDate: widget.firstDate,
            maximumYear: widget.maximumYear,
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
};

final FormFieldBuilder<DateTime> datePickerBuilder =
    (FormFieldState<DateTime> field) {
  final state = field as FastDatePickerState;
  final context = state.context;
  final widget = state.widget;

  final decoration = widget.decoration ??
      FastFormScope.of(context)?.inputDecorator(context, widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      decoration.applyDefaults(Theme.of(context).inputDecorationTheme);
  final textBuilder = widget.textBuilder ?? datePickerTextBuilder;
  final iconButtonBuilder =
      widget.iconButtonBuilder ?? datePickerIconButtonBuilder;

  final ShowDatePicker show = (DatePickerEntryMode entryMode) {
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
      initialDate: widget.initialValue,
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
  };

  return InkWell(
    onTap: widget.enabled ? () => show(DatePickerEntryMode.input) : null,
    child: InputDecorator(
      decoration: effectiveDecoration.copyWith(
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
};

final FormFieldBuilder<DateTime> adaptiveDatePickerBuilder =
    (FormFieldState<DateTime> field) {
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
};
