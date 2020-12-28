import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef DatePickerTextBuilder = Text Function(FastDatePickerState state);

typedef ShowDatePicker = Future<DateTime> Function(
    DatePickerEntryMode entryMode);

typedef DatePickerIconButtonBuilder = IconButton Function(
    FastDatePickerState state, ShowDatePicker show);

@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTime> builder,
    this.cancelText,
    this.confirmText,
    this.currentDate,
    InputDecoration decoration,
    bool enabled = true,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    @required this.firstDate,
    DateFormat format,
    String helper,
    this.helpText,
    this.icon,
    this.iconButtonBuilder,
    @required String id,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    DateTime initialValue,
    Key key,
    String label,
    @required this.lastDate,
    this.locale,
    ValueChanged<DateTime> onChanged,
    VoidCallback onReset,
    FormFieldSetter<DateTime> onSaved,
    this.routeSettings,
    this.selectableDayPredicate,
    this.textBuilder,
    this.useRootNavigator = true,
    FormFieldValidator<DateTime> validator,
  })  : this.dateFormat = format ?? DateFormat.yMMMMEEEEd(),
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? datePickerBuilder,
          decoration: decoration,
          enabled: enabled,
          helper: helper,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String cancelText;
  final String confirmText;
  final DateTime currentDate;
  final String errorFormatText;
  final String errorInvalidText;
  final DateFormat dateFormat;
  final String fieldHintText;
  final String fieldLabelText;
  final DateTime firstDate;
  final String helpText;
  final Icon icon;
  final DatePickerIconButtonBuilder iconButtonBuilder;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;
  final Locale locale;
  final RouteSettings routeSettings;
  final SelectableDayPredicate selectableDayPredicate;
  final DatePickerTextBuilder textBuilder;
  final bool useRootNavigator;

  @override
  FastDatePickerState createState() => FastDatePickerState();
}

class FastDatePickerState extends FastFormFieldState<DateTime> {
  @override
  FastDatePicker get widget => super.widget as FastDatePicker;
}

final DatePickerTextBuilder datePickerTextBuilder =
    (FastDatePickerState state) {
  final theme = Theme.of(state.context);
  final format = state.widget.dateFormat.format;
  final value = state.value;

  return Text(
    value != null ? format(state.value) : '',
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

final FormFieldBuilder<DateTime> materialDatePickerBuilder =
    (FormFieldState<DateTime> field) {
  final state = field as FastDatePickerState;
  final context = state.context;
  final widget = state.widget;

  final decoration = widget.decoration ??
      FastFormScope.of(context).inputDecorator(context, widget);
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
  };

  return InkWell(
    onTap: widget.enabled ? () => show(DatePickerEntryMode.input) : null,
    child: InputDecorator(
      decoration: effectiveDecoration.copyWith(
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

final FormFieldBuilder<DateTime> datePickerBuilder =
    (FormFieldState<DateTime> field) {
  switch (Theme.of(field.context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.android:
    default:
      return materialDatePickerBuilder(field);
  }
};
