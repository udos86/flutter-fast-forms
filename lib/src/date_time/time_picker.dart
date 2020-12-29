import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef TimePickerTextBuilder = Text Function(FastTimePickerState state);

typedef ShowTimePicker = Future<TimeOfDay?> Function(
    TimePickerEntryMode entryMode);

typedef TimePickerIconButtonBuilder = IconButton Function(
    FastTimePickerState state, ShowTimePicker show);

@immutable
class FastTimePicker extends FastFormField<TimeOfDay> {
  FastTimePicker({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<TimeOfDay>? builder,
    String? cancelText,
    String? confirmText,
    InputDecoration? decoration,
    bool enabled = true,
    String? helper,
    String? helpText,
    this.icon,
    TimePickerIconButtonBuilder? iconButtonBuilder,
    required String id,
    this.initialEntryMode = TimePickerEntryMode.dial,
    TimeOfDay? initialValue,
    Key? key,
    String? label,
    ValueChanged<TimeOfDay>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<TimeOfDay>? onSaved,
    RouteSettings? routeSettings,
    TimePickerTextBuilder? textBuilder,
    bool useRootNavigator = true,
    FormFieldValidator<TimeOfDay>? validator,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastTimePickerState;
                final theme = Theme.of(state.context);
                final decorator =
                    FastFormScope.of(state.context)?.inputDecorator;

                final _decoration = decoration ??
                    decorator?.call(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
                final _textBuilder = textBuilder ?? timePickerTextBuilder;
                final _iconButtonBuilder =
                    iconButtonBuilder ?? timePickerIconButtonBuilder;

                final ShowTimePicker show = (TimePickerEntryMode entryMode) {
                  return showTimePicker(
                    cancelText: cancelText,
                    confirmText: confirmText,
                    context: state.context,
                    helpText: helpText,
                    initialEntryMode: initialEntryMode,
                    initialTime: state.value ?? TimeOfDay.now(),
                    routeSettings: routeSettings,
                    useRootNavigator: useRootNavigator,
                  ).then((value) {
                    if (value != null) state.didChange(value);
                    return value;
                  });
                };

                return InkWell(
                  onTap: enabled ? () => show(initialEntryMode) : null,
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

  final Icon? icon;
  final TimePickerEntryMode initialEntryMode;

  @override
  FastTimePickerState createState() => FastTimePickerState();
}

class FastTimePickerState extends FastFormFieldState<TimeOfDay> {
  @override
  FastTimePicker get widget => super.widget as FastTimePicker;
}

final TimePickerTextBuilder timePickerTextBuilder =
    (FastTimePickerState state) {
  final theme = Theme.of(state.context);

  return Text(
    state.value?.format(state.context) ?? '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
};

final TimePickerIconButtonBuilder timePickerIconButtonBuilder =
    (FastTimePickerState state, ShowTimePicker show) {
  final widget = state.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? Icon(Icons.schedule),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
};
