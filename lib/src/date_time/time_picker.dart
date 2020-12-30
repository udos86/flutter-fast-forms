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
    this.cancelText,
    this.confirmText,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    this.helpText,
    this.icon,
    this.iconButtonBuilder,
    required String id,
    this.initialEntryMode = TimePickerEntryMode.dial,
    TimeOfDay? initialValue,
    Key? key,
    String? label,
    ValueChanged<TimeOfDay>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<TimeOfDay>? onSaved,
    this.routeSettings,
    this.textBuilder,
    this.useRootNavigator = true,
    FormFieldValidator<TimeOfDay>? validator,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder = scope?.builders[FastTimePicker] ??
                    adaptiveTimePickerBuilder;
                return builder(field);
              },
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
  final TimePickerIconButtonBuilder? iconButtonBuilder;
  final TimePickerEntryMode initialEntryMode;
  final RouteSettings? routeSettings;
  final TimePickerTextBuilder? textBuilder;
  final bool useRootNavigator;

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

final FormFieldBuilder<TimeOfDay> timePickerBuilder =
    (FormFieldState<TimeOfDay> field) {
  final state = field as FastTimePickerState;
  final widget = state.widget;
  final theme = Theme.of(state.context);
  final decorator = FastFormScope.of(state.context)?.inputDecorator;

  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);
  final _textBuilder = widget.textBuilder ?? timePickerTextBuilder;
  final _iconButtonBuilder =
      widget.iconButtonBuilder ?? timePickerIconButtonBuilder;

  final ShowTimePicker show = (TimePickerEntryMode entryMode) {
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
  };

  return InkWell(
    onTap: widget.enabled ? () => show(widget.initialEntryMode) : null,
    child: InputDecorator(
      decoration: effectiveDecoration.copyWith(
        contentPadding: state.widget.contentPadding,
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
};

final FormFieldBuilder<TimeOfDay> adaptiveTimePickerBuilder =
    (FormFieldState<TimeOfDay> field) {
  final state = field as FastTimePickerState;

  if (state.adaptive) {
    switch (Theme.of(field.context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      default:
        return timePickerBuilder(field);
    }
  }
  return timePickerBuilder(field);
};
