import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastSwitchTitleBuilder = Widget Function(FastSwitchState field);

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
          builder: builder ?? switchBuilder,
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

Text switchTitleBuilder(FastSwitchState field) {
  return Text(
    field.widget.title!,
    style: TextStyle(
      fontSize: 14.0,
      color: field.value! ? Colors.black : Colors.grey,
    ),
  );
}

InputDecorator materialSwitchBuilder(FormFieldState<bool> field) {
  final widget = (field as FastSwitchState).widget;
  final titleBuilder = widget.titleBuilder ?? switchTitleBuilder;

  return InputDecorator(
    decoration: field.decoration.copyWith(errorText: field.errorText),
    child: SwitchListTile.adaptive(
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      onChanged: widget.enabled ? field.didChange : null,
      selected: field.value!,
      title: widget.title is String ? titleBuilder(field) : null,
      value: field.value!,
    ),
  );
}

CupertinoFormRow cupertinoSwitchBuilder(FormFieldState<bool> field) {
  final widget = (field as FastSwitchState).widget;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.label is String ? Text(widget.label!) : null,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: CupertinoSwitch(
      onChanged: widget.enabled ? field.didChange : null,
      value: field.value!,
    ),
  );
}

Widget switchBuilder(FormFieldState<bool> field) {
  FormFieldBuilder<bool> builder = materialSwitchBuilder;

  if ((field as FastSwitchState).adaptive) {
    final platform = Theme.of(field.context).platform;
    if (platform == TargetPlatform.iOS) builder = cupertinoSwitchBuilder;
  }

  return builder(field);
}
