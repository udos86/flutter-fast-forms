import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastSwitchTitleBuilder = Widget Function(FastSwitchState state);

@immutable
class FastSwitch extends FastFormField<bool> {
  const FastSwitch({
    bool? adaptive,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<bool>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    bool initialValue = false,
    Key? key,
    String? label,
    required String name,
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
          builder: builder ?? adaptiveSwitchBuilder,
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

  final FastErrorBuilder<bool>? errorBuilder;
  final FastHelperBuilder<bool>? helperBuilder;
  final String? title;
  final FastSwitchTitleBuilder? titleBuilder;

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

  final titleBuilder = widget.titleBuilder ?? switchTitleBuilder;

  return InputDecorator(
    decoration: state.decoration.copyWith(errorText: state.errorText),
    child: SwitchListTile.adaptive(
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      onChanged: widget.enabled ? state.didChange : null,
      selected: state.value!,
      title: widget.title is String ? titleBuilder(state) : null,
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
    helper: (widget.helperBuilder ?? helperBuilder)(state),
    error: (widget.errorBuilder ?? errorBuilder)(state),
    child: CupertinoSwitch(
      onChanged: widget.enabled ? state.didChange : null,
      value: state.value!,
    ),
  );
}

Widget adaptiveSwitchBuilder(FormFieldState<bool> field) {
  final state = field as FastSwitchState;
  FormFieldBuilder<bool> builder = switchBuilder;

  if (state.adaptive) {
    final platform = Theme.of(state.context).platform;
    if (platform == TargetPlatform.iOS) builder = cupertinoSwitchBuilder;
  }

  return builder(field);
}
