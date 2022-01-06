import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastTimePickerTextBuilder = Text Function(FastTimePickerState field);

typedef ShowFastTimePicker = Future<TimeOfDay?> Function(
    TimePickerEntryMode entryMode);

typedef FastTimePickerIconButtonBuilder = IconButton Function(
    FastTimePickerState field, ShowFastTimePicker show);

@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  const FastTimePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<TimeOfDay>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    TimeOfDay? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<TimeOfDay>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<TimeOfDay>? onSaved,
    FormFieldValidator<TimeOfDay>? validator,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.icon,
    this.iconButtonBuilder,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.routeSettings,
    this.textBuilder,
    this.useRootNavigator = true,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: builder ?? timePickerBuilder,
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
  final String? helpText;
  final Icon? icon;
  final FastTimePickerIconButtonBuilder? iconButtonBuilder;
  final TimePickerEntryMode initialEntryMode;
  final RouteSettings? routeSettings;
  final FastTimePickerTextBuilder? textBuilder;
  final bool useRootNavigator;

  @override
  FastTimePickerState createState() => FastTimePickerState();
}

class FastTimePickerState extends FastFormFieldState<TimeOfDay> {
  @override
  FastTimePicker get widget => super.widget as FastTimePicker;
}

Text timePickerTextBuilder(FastTimePickerState field) {
  final theme = Theme.of(field.context);

  return Text(
    field.value?.format(field.context) ?? '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
}

IconButton timePickerIconButtonBuilder(
    FastTimePickerState field, ShowFastTimePicker show) {
  final widget = field.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? const Icon(Icons.schedule),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

InkWell timePickerBuilder(FormFieldState<TimeOfDay> field) {
  final widget = (field as FastTimePickerState).widget;
  final textBuilder = widget.textBuilder ?? timePickerTextBuilder;
  final iconButtonBuilder =
      widget.iconButtonBuilder ?? timePickerIconButtonBuilder;

  Future<TimeOfDay?> show(TimePickerEntryMode entryMode) {
    return showTimePicker(
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: field.context,
      helpText: widget.helpText,
      initialEntryMode: widget.initialEntryMode,
      initialTime: field.value ?? TimeOfDay.now(),
      routeSettings: widget.routeSettings,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) field.didChange(value);
      return value;
    });
  }

  return InkWell(
    onTap: widget.enabled ? () => show(widget.initialEntryMode) : null,
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
