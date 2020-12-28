import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef DateRangePickerTextBuilder = Text Function(
    FastDateRangePickerState state);

typedef ShowDateRangePicker = Future<DateTimeRange> Function(
    DatePickerEntryMode entryMode);

typedef DateRangePickerIconButtonBuilder = IconButton Function(
    FastDateRangePickerState state, ShowDateRangePicker show);

@immutable
class FastDateRangePicker extends FastFormField<DateTimeRange> {
  FastDateRangePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTimeRange> builder,
    String cancelText,
    String confirmText,
    DateTime currentDate,
    InputDecoration decoration,
    bool enabled = true,
    String errorFormatText,
    String errorInvalidRangeText,
    String errorInvalidText,
    String fieldEndHintText,
    String fieldEndLabelText,
    String fieldStartHintText,
    String fieldStartLabelText,
    @required DateTime firstDate,
    DateFormat format,
    String helper,
    String helpText,
    this.icon,
    DateRangePickerIconButtonBuilder iconButtonBuilder,
    @required String id,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    DateTimeRange initialValue,
    Key key,
    String label,
    Locale locale,
    @required DateTime lastDate,
    ValueChanged<DateTimeRange> onChanged,
    VoidCallback onReset,
    FormFieldSetter<DateTimeRange> onSaved,
    RouteSettings routeSettings,
    String saveText,
    DateRangePickerTextBuilder textBuilder,
    bool useRootNavigator = true,
    FormFieldValidator<DateTimeRange> validator,
  })  : this.dateFormat = format ?? DateFormat.yMd(),
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastDateRangePickerState;
                final theme = Theme.of(state.context);
                final decorator =
                    FastFormScope.of(state.context).inputDecorator;

                final _decoration = decoration ??
                    decorator(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
                final _textBuilder = textBuilder ?? dateRangPickerTextBuilder;
                final _iconButtonBuilder =
                    iconButtonBuilder ?? dateRangePickerIconButtonBuilder;

                final ShowDateRangePicker show =
                    (DatePickerEntryMode entryMode) {
                  return showDateRangePicker(
                    cancelText: cancelText,
                    confirmText: confirmText,
                    context: state.context,
                    currentDate: currentDate,
                    errorFormatText: errorFormatText,
                    errorInvalidRangeText: errorInvalidRangeText,
                    errorInvalidText: errorInvalidText,
                    fieldEndHintText: fieldEndHintText,
                    fieldEndLabelText: fieldEndLabelText,
                    fieldStartHintText: fieldStartHintText,
                    fieldStartLabelText: fieldStartLabelText,
                    helpText: helpText,
                    initialEntryMode: entryMode,
                    initialDateRange: state.value,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    locale: locale,
                    routeSettings: routeSettings,
                    saveText: saveText,
                    useRootNavigator: useRootNavigator,
                  ).then((value) {
                    if (value != null) state.didChange(value);
                    return value;
                  });
                };

                return InkWell(
                  onTap: enabled ? () => show(DatePickerEntryMode.input) : null,
                  child: InputDecorator(
                    decoration: effectiveDecoration.copyWith(
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
              },
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

  final Icon icon;
  final DatePickerEntryMode initialEntryMode;
  final DateFormat dateFormat;

  @override
  FastDateRangePickerState createState() => FastDateRangePickerState();
}

class FastDateRangePickerState extends FastFormFieldState<DateTimeRange> {
  @override
  FastDateRangePicker get widget => super.widget;
}

final DateRangePickerTextBuilder dateRangPickerTextBuilder =
    (FastDateRangePickerState state) {
  final theme = Theme.of(state.context);
  final format = state.widget.dateFormat.format;
  final value = state.value;

  return Text(
    value != null ? '${format(value.start)} - ${format(value.end)}' : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
};

final DateRangePickerIconButtonBuilder dateRangePickerIconButtonBuilder =
    (FastDateRangePickerState state, ShowDateRangePicker show) {
  final widget = state.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: Icon(Icons.today),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
};
