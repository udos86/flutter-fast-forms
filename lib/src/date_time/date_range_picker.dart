import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';

typedef FastDateRangePickerTextBuilder = Text Function(
    FastDateRangePickerState field);

typedef ShowFastDateRangePicker = Future<DateTimeRange?> Function(
    DatePickerEntryMode entryMode);

typedef FastDateRangePickerIconButtonBuilder = IconButton Function(
    FastDateRangePickerState field, ShowFastDateRangePicker show);

@immutable
class FastDateRangePicker extends FastFormField<DateTimeRange> {
  FastDateRangePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTimeRange>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    DateFormat? format,
    String? helperText,
    DateTimeRange? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<DateTimeRange>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<DateTimeRange>? onSaved,
    FormFieldValidator<DateTimeRange>? validator,
    this.cancelText,
    this.confirmText,
    this.currentDate,
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
    this.iconButtonBuilder,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.locale,
    required this.lastDate,
    this.routeSettings,
    this.saveText,
    this.textBuilder,
    this.useRootNavigator = true,
  })  : dateFormat = format ?? DateFormat.yMd(),
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? dateRangePickerBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String? cancelText;
  final String? confirmText;
  final DateTime? currentDate;
  final DateFormat dateFormat;
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
  final FastDateRangePickerIconButtonBuilder? iconButtonBuilder;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;
  final Locale? locale;
  final RouteSettings? routeSettings;
  final String? saveText;
  final FastDateRangePickerTextBuilder? textBuilder;
  final bool useRootNavigator;

  @override
  FastDateRangePickerState createState() => FastDateRangePickerState();
}

class FastDateRangePickerState extends FastFormFieldState<DateTimeRange> {
  @override
  FastDateRangePicker get widget => super.widget as FastDateRangePicker;
}

Text dateRangPickerTextBuilder(FastDateRangePickerState field) {
  final theme = Theme.of(field.context);
  final format = field.widget.dateFormat.format;
  final value = field.value;

  return Text(
    value != null ? '${format(value.start)} - ${format(value.end)}' : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
}

IconButton dateRangePickerIconButtonBuilder(
    FastDateRangePickerState field, ShowFastDateRangePicker show) {
  final widget = field.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: const Icon(Icons.today),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

InkWell dateRangePickerBuilder(FormFieldState<DateTimeRange> field) {
  final widget = (field as FastDateRangePickerState).widget;

  Future<DateTimeRange?> show(DatePickerEntryMode entryMode) {
    return showDateRangePicker(
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: field.context,
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
      initialDateRange: field.value,
      lastDate: widget.lastDate,
      locale: widget.locale,
      routeSettings: widget.routeSettings,
      saveText: widget.saveText,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) field.didChange(value);
      return value;
    });
  }

  final textBuilder = widget.textBuilder ?? dateRangPickerTextBuilder;
  final iconButtonBuilder =
      widget.iconButtonBuilder ?? dateRangePickerIconButtonBuilder;

  return InkWell(
    onTap: widget.enabled ? () => show(DatePickerEntryMode.input) : null,
    child: InputDecorator(
      decoration: field.decoration.copyWith(
        contentPadding: field.widget.contentPadding,
        errorText: field.errorText,
      ),
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
