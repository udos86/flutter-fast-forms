import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateRangePickerTextBuilder = Text Function(
    BuildContext context, DateTimeRange value, DateFormat format);

class DateRangePickerFormField extends FormField<DateTimeRange> {
  DateRangePickerFormField({
    bool autovalidate,
    String cancelText,
    String confirmText,
    DateTime currentDate,
    InputDecoration decoration = const InputDecoration(),
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
    String helpText,
    Icon icon,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DateTimeRange initialValue,
    Key key,
    String label,
    DateTime lastDate,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    DateRangePickerTextBuilder textBuilder,
    FormFieldValidator validator,
  })  : assert(decoration != null),
        this.dateFormat = format ?? DateFormat.yMd(),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final state = field as DateRangePickerFormFieldState;
            final theme = Theme.of(state.context);
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(theme.inputDecorationTheme);
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
                          ? () =>
                              _showDateRangePicker(DatePickerEntryMode.input)
                          : null,
                      child: _textBuilder(
                          state.context, state.value, state.widget.dateFormat),
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
          initialValue: initialValue,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final DateFormat dateFormat;
  final ValueChanged<DateTimeRange> onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<DateTimeRange> createState() =>
      DateRangePickerFormFieldState();
}

class DateRangePickerFormFieldState extends FormFieldState<DateTimeRange> {
  @override
  DateRangePickerFormField get widget => super.widget;

  @override
  void didChange(DateTimeRange value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
  }
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
