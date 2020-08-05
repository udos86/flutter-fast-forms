import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePickerFormField extends FormField<DateTimeRange> {
  DateRangePickerFormField({
    String cancelText,
    String confirmText,
    DateTime currentDate,
    InputDecoration decoration = const InputDecoration(),
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
    Widget hint,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    Key key,
    String label,
    DateTime lastDate,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    DateTimeRange value,
    this.onChanged,
  })  : assert(decoration != null),
        this.dateFormat = format ?? DateFormat.yMMMMEEEEd(),
        super(
            key: key,
            onSaved: onSaved,
            initialValue: value,
            validator: validator,
            builder: (_field) {
              final field = _field as _DatePickerFormFieldState;
              final theme = Theme.of(field.context);
              final InputDecoration effectiveDecoration =
                  decoration.applyDefaults(theme.inputDecorationTheme);
              final _showDateRangePicker = (DatePickerEntryMode entryMode) {
                showDateRangePicker(
                  cancelText: cancelText,
                  confirmText: confirmText,
                  context: field.context,
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
                  initialDateRange: field.value,
                  firstDate: firstDate,
                  lastDate: lastDate,
                ).then(field.didChange);
              };

              return InputDecorator(
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: field.controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        focusNode: field.focusNode,
                        readOnly: true,
                        textAlign: TextAlign.left,
                        onTap: () =>
                            _showDateRangePicker(DatePickerEntryMode.input),
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(Icons.today),
                      onPressed: () => _showDateRangePicker(initialEntryMode),
                    ),
                  ],
                ),
              );
            });

  final DateFormat dateFormat;
  final ValueChanged<DateTimeRange> onChanged;

  @override
  FormFieldState<DateTimeRange> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends FormFieldState<DateTimeRange> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = formatValue(value.start);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    focusNode.dispose();
  }

  @override
  DateRangePickerFormField get widget => super.widget;

  @override
  void didChange(DateTimeRange value) {
    super.didChange(value);
    controller.text = formatValue(value.start);
    if (widget.onChanged != null) widget.onChanged(value);
  }

  String formatValue(DateTime value) {
    return value != null ? widget.dateFormat.format(value) : null;
  }
}
