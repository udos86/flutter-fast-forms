import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_theme.dart';

typedef DateRangePickerTextBuilder = Text Function(
    BuildContext context, DateTimeRange value, DateFormat format);

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
    DateTime firstDate,
    DateFormat format,
    String helper,
    String helpText,
    @required String id,
    Icon icon,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DateTimeRange initialValue,
    Key key,
    String label,
    DateTime lastDate,
    ValueChanged<DateTimeRange> onChanged,
    VoidCallback onReset,
    FormFieldSetter<DateTimeRange> onSaved,
    DateRangePickerTextBuilder textBuilder,
    FormFieldValidator<DateTimeRange> validator,
  })  : this.dateFormat = format ?? DateFormat.yMd(),
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastDateRangePickerState;
                final theme = Theme.of(state.context);
                final formTheme = FastFormTheme.of(state.context);
                final _decoration = decoration ??
                    formTheme.getInputDecoration(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
                final _textBuilder = textBuilder ?? dateRangPickerTextBuilder;
                final _showDateRangePicker = (DatePickerEntryMode entryMode) {
                  showDateRangePicker(
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
                  ).then((value) {
                    if (value != null) state.didChange(value);
                  });
                };
                return InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: state.errorText,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: enabled
                              ? () => _showDateRangePicker(
                                  DatePickerEntryMode.input)
                              : null,
                          child: _textBuilder(state.context, state.value,
                              state.widget.dateFormat),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.centerRight,
                        icon: icon ?? Icon(Icons.today),
                        onPressed: enabled
                            ? () => _showDateRangePicker(initialEntryMode)
                            : null,
                      ),
                    ],
                  ),
                );
              },
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

  final DateFormat dateFormat;

  @override
  FormFieldState<DateTimeRange> createState() => FastDateRangePickerState();
}

class FastDateRangePickerState extends FastFormFieldState<DateTimeRange> {
  @override
  FastDateRangePicker get widget => super.widget;
}

final DateRangePickerTextBuilder dateRangPickerTextBuilder =
    (BuildContext context, DateTimeRange value, DateFormat dateFormat) {
  final theme = Theme.of(context);
  final format = dateFormat.format;
  return Text(
    value != null ? '${format(value.start)} - ${format(value.end)}' : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
};
