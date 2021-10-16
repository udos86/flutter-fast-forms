import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef DateRangePickerTextBuilder = Text Function(
    FastDateRangePickerState state);

typedef ShowDateRangePicker = Future<DateTimeRange?> Function(
    DatePickerEntryMode entryMode);

typedef DateRangePickerIconButtonBuilder = IconButton Function(
    FastDateRangePickerState state, ShowDateRangePicker show);

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
    required String id,
    DateTimeRange? initialValue,
    Key? key,
    String? label,
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
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder = scope?.builders[FastDateRangePicker] ??
                    dateRangePickerBuilder;
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
  final DateRangePickerIconButtonBuilder? iconButtonBuilder;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;
  final Locale? locale;
  final RouteSettings? routeSettings;
  final String? saveText;
  final DateRangePickerTextBuilder? textBuilder;
  final bool useRootNavigator;

  @override
  FastDateRangePickerState createState() => FastDateRangePickerState();
}

class FastDateRangePickerState extends FastFormFieldState<DateTimeRange> {
  @override
  FastDateRangePicker get widget => super.widget as FastDateRangePicker;
}

Text dateRangPickerTextBuilder(FastDateRangePickerState state) {
  final theme = Theme.of(state.context);
  final format = state.widget.dateFormat.format;
  final value = state.value;

  return Text(
    value != null ? '${format(value.start)} - ${format(value.end)}' : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
}

IconButton dateRangePickerIconButtonBuilder(
    FastDateRangePickerState state, ShowDateRangePicker show) {
  final widget = state.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: const Icon(Icons.today),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

InkWell dateRangePickerBuilder(FormFieldState<DateTimeRange> field) {
  final state = field as FastDateRangePickerState;
  final widget = state.widget;

  final theme = Theme.of(state.context);
  final decorator = FastFormScope.of(state.context)?.inputDecorator;
  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);

  final _textBuilder = widget.textBuilder ?? dateRangPickerTextBuilder;
  final _iconButtonBuilder =
      widget.iconButtonBuilder ?? dateRangePickerIconButtonBuilder;

  Future<DateTimeRange?> show(DatePickerEntryMode entryMode) {
    return showDateRangePicker(
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: state.context,
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
      initialDateRange: state.value,
      lastDate: widget.lastDate,
      locale: widget.locale,
      routeSettings: widget.routeSettings,
      saveText: widget.saveText,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) state.didChange(value);
      return value;
    });
  }

  return InkWell(
    onTap: widget.enabled ? () => show(DatePickerEntryMode.input) : null,
    child: InputDecorator(
      decoration: effectiveDecoration.copyWith(
        contentPadding: state.widget.contentPadding,
        errorText: state.errorText,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: _textBuilder(state),
          ),
          _iconButtonBuilder(state, show),
        ],
      ),
    ),
  );
}
