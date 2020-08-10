import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePickerFormField extends FormField<DateTimeRange> {
  DateRangePickerFormField({
    bool autovalidate,
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
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    Key key,
    String label,
    DateTime lastDate,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    FormFieldValidator validator,
    DateTimeRange value,
  })  : assert(decoration != null),
        this.dateFormat = format ?? DateFormat.yMd(),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final state = field as DateRangePickerFormFieldState;
            final theme = Theme.of(state.context);
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(theme.inputDecorationTheme);
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
                    child: TextFormField(
                      controller: state.controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      focusNode: state.focusNode,
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
          },
          initialValue: value,
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
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = writeValue(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
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
    controller.text = writeValue(value);
    widget.onChanged?.call(value);
  }

  String writeValue(DateTimeRange value) {
    final format = widget.dateFormat.format;
    return value != null ? '${format(value.start)} - ${format(value.end)}' : '';
  }
}
