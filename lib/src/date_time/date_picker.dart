import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';
import '../form_theme.dart';

typedef DatePickerTextBuilder = Text Function(FastDatePickerState state);

typedef ShowDatePicker = void Function(DatePickerEntryMode entryMode);

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
    ValueChanged<DateTime> onChanged,
    VoidCallback onReset,
    FormFieldSetter<DateTime> onSaved,
    this.textBuilder,
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
  final DatePickerTextBuilder textBuilder;

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
  final widget = state.widget;
  final theme = Theme.of(state.context);
  final formTheme = FastFormTheme.of(state.context);
  final _decoration = widget.decoration ??
      formTheme.getInputDecoration(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);
  final _textBuilder = widget.textBuilder ?? datePickerTextBuilder;
  final _iconButtonBuilder =
      widget.iconButtonBuilder ?? datePickerIconButtonBuilder;
  final _showDatePicker = (DatePickerEntryMode entryMode) {
    showDatePicker(
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: state.context,
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
    ).then((value) {
      if (value != null) state.didChange(value);
    });
  };

  return InkWell(
    onTap: widget.enabled
        ? () => _showDatePicker(DatePickerEntryMode.input)
        : null,
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
          _iconButtonBuilder(state, _showDatePicker),
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
