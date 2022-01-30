import 'package:flutter/material.dart';

import '../form.dart';

typedef FastCheckboxTitleBuilder = Widget Function(FastCheckboxState field);

@immutable
class FastCheckbox extends FastFormField<bool> {
  const FastCheckbox({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<bool>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    bool initialValue = false,
    Key? key,
    String? labelText,
    required String name,
    ValueChanged<bool>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    this.activeColor,
    this.checkColor,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.dense,
    this.enableFeedback,
    this.focusNode,
    this.isThreeLine = false,
    this.secondary,
    this.selectedTileColor,
    this.shapeBorder,
    this.subtitle,
    this.tileColor,
    required this.titleText,
    this.titleBuilder,
    this.tristate = false,
    this.visualDensity,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? checkboxBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          labelText: labelText,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final Color? activeColor;
  final Color? checkColor;
  final ListTileControlAffinity controlAffinity;
  final bool? dense;
  final bool? enableFeedback;
  final FocusNode? focusNode;
  final bool isThreeLine;
  final Widget? secondary;
  final Color? selectedTileColor;
  final ShapeBorder? shapeBorder;
  final Widget? subtitle;
  final Color? tileColor;
  final String titleText;
  final FastCheckboxTitleBuilder? titleBuilder;
  final bool tristate;
  final VisualDensity? visualDensity;

  @override
  FastCheckboxState createState() => FastCheckboxState();
}

class FastCheckboxState extends FastFormFieldState<bool> {
  @override
  FastCheckbox get widget => super.widget as FastCheckbox;
}

Text checkboxTitleBuilder(FastCheckboxState field) {
  return Text(
    field.widget.titleText,
    style: TextStyle(
      fontSize: 14.0,
      color: field.value! ? Colors.black : Colors.grey,
    ),
  );
}

InputDecorator checkboxBuilder(FormFieldState<bool> field) {
  final widget = (field as FastCheckboxState).widget;
  final titleBuilder = widget.titleBuilder ?? checkboxTitleBuilder;

  return InputDecorator(
    decoration: field.decoration,
    child: CheckboxListTile(
      activeColor: widget.activeColor,
      autofocus: widget.autofocus,
      checkColor: widget.checkColor,
      contentPadding: widget.contentPadding,
      controlAffinity: widget.controlAffinity,
      dense: widget.dense,
      enableFeedback: widget.enableFeedback,
      focusNode: widget.focusNode,
      isThreeLine: widget.isThreeLine,
      onChanged: widget.enabled ? field.didChange : null,
      secondary: widget.secondary,
      selected: field.value ?? false,
      selectedTileColor: widget.selectedTileColor,
      shape: widget.shapeBorder,
      subtitle: widget.subtitle,
      tileColor: widget.tileColor,
      title: titleBuilder(field),
      tristate: widget.tristate,
      value: field.value,
      visualDensity: widget.visualDensity,
    ),
  );
}
