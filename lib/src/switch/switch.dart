import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef SwitchTitleBuilder = Widget Function(FastSwitchState state);

@immutable
class FastSwitch extends FastFormField<bool> {
  FastSwitch({
    bool? adaptive,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<bool>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    bool initialValue = false,
    Key? key,
    String? label,
    ValueChanged<bool>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    this.errorBuilder,
    this.helperBuilder,
    this.title,
    this.titleBuilder,
  }) : super(
          adaptive: adaptive,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder =
                    scope?.builders[FastSwitch] ?? adaptiveSwitchBuilder;
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

  final ErrorBuilder<bool>? errorBuilder;
  final HelperBuilder<bool>? helperBuilder;
  final String? title;
  final SwitchTitleBuilder? titleBuilder;

  @override
  FastSwitchState createState() => FastSwitchState();
}

class FastSwitchState extends FastFormFieldState<bool> {
  @override
  FastSwitch get widget => super.widget as FastSwitch;
}

Text switchTitleBuilder(FastSwitchState state) {
  return Text(
    state.widget.title!,
    style: TextStyle(
      fontSize: 14.0,
      color: state.value! ? Colors.black : Colors.grey,
    ),
  );
}

InputDecorator switchBuilder(FormFieldState<bool> field) {
  final state = field as FastSwitchState;
  final widget = state.widget;
  final theme = Theme.of(state.context);

  final decorator = FastFormScope.of(state.context)?.inputDecorator;
  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);
  final _titleBuilder = widget.titleBuilder ?? switchTitleBuilder;

  return InputDecorator(
    decoration: effectiveDecoration.copyWith(
      errorText: state.errorText,
    ),
    child: SwitchListTile.adaptive(
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      onChanged: widget.enabled ? state.didChange : null,
      selected: state.value!,
      title: widget.title is String ? _titleBuilder(state) : null,
      value: state.value!,
    ),
  );
}

CupertinoFormRow cupertinoSwitchBuilder(FormFieldState<bool> field) {
  final state = field as FastSwitchState;
  final widget = state.widget;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.label is String ? Text(widget.label!) : null,
    helper: widget.helperBuilder?.call(state) ?? helperBuilder(state),
    error: widget.errorBuilder?.call(state) ?? errorBuilder(state),
    child: CupertinoSwitch(
      onChanged: widget.enabled ? state.didChange : null,
      value: state.value!,
    ),
  );
}

Widget adaptiveSwitchBuilder(FormFieldState<bool> field) {
  final state = field as FastSwitchState;

  if (state.adaptive) {
    switch (Theme.of(state.context).platform) {
      case TargetPlatform.iOS:
        return cupertinoSwitchBuilder(field);
      case TargetPlatform.android:
      default:
        return switchBuilder(field);
    }
  }
  return switchBuilder(field);
}
