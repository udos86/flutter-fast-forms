import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastTimePickerTextBuilder = Text Function(FastTimePickerState state);

typedef ShowFastTimePicker = Future<TimeOfDay?> Function(
    TimePickerEntryMode entryMode);

typedef FastTimePickerIconButtonBuilder = IconButton Function(
    FastTimePickerState state, ShowFastTimePicker show);

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
    ValueChanged<TimeOfDay>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<TimeOfDay>? onSaved,
    FormFieldValidator<TimeOfDay>? validator,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.icon,
    this.iconButtonBuilder,
    required String id,
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

Text timePickerTextBuilder(FastTimePickerState state) {
  final theme = Theme.of(state.context);

  return Text(
    state.value?.format(state.context) ?? '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
}

IconButton timePickerIconButtonBuilder(
    FastTimePickerState state, ShowFastTimePicker show) {
  final widget = state.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? const Icon(Icons.schedule),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

InkWell timePickerBuilder(FormFieldState<TimeOfDay> field) {
  final state = field as FastTimePickerState;
  final widget = state.widget;

  final textBuilder = widget.textBuilder ?? timePickerTextBuilder;
  final iconButtonBuilder =
      widget.iconButtonBuilder ?? timePickerIconButtonBuilder;

  Future<TimeOfDay?> show(TimePickerEntryMode entryMode) {
    return showTimePicker(
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: state.context,
      helpText: widget.helpText,
      initialEntryMode: widget.initialEntryMode,
      initialTime: state.value ?? TimeOfDay.now(),
      routeSettings: widget.routeSettings,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) state.didChange(value);
      return value;
    });
  }

  return InkWell(
    onTap: widget.enabled ? () => show(widget.initialEntryMode) : null,
    child: InputDecorator(
      decoration: state.decoration.copyWith(
        contentPadding: state.widget.contentPadding,
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
}
