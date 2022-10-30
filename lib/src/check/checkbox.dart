import 'package:flutter/material.dart';

import '../form.dart';

typedef FastCheckboxTitleBuilder = Widget Function(FastCheckboxState field);

@immutable
class FastCheckbox extends FastFormField<bool> {
  const FastCheckbox({
    super.autovalidateMode,
    super.builder = checkboxBuilder,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue = false,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.activeColor,
    this.autofocus = false,
    this.checkboxShape,
    this.checkColor,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.dense,
    this.enableFeedback,
    this.focusNode,
    this.isThreeLine = false,
    this.secondary,
    this.selectedTileColor,
    this.shapeBorder,
    this.side,
    this.subtitle,
    this.tileColor,
    required this.titleText,
    this.titleBuilder,
    this.tristate = false,
    this.visualDensity,
  });

  final bool autofocus;
  final Color? activeColor;
  final OutlinedBorder? checkboxShape;
  final Color? checkColor;
  final ListTileControlAffinity controlAffinity;
  final bool? dense;
  final bool? enableFeedback;
  final FocusNode? focusNode;
  final bool isThreeLine;
  final Widget? secondary;
  final Color? selectedTileColor;
  final ShapeBorder? shapeBorder;
  final BorderSide? side;
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

Widget checkboxTitleBuilder(FastCheckboxState field) {
  return Text(
    field.widget.titleText,
    style: TextStyle(
      fontSize: 14.0,
      color: field.value! ? Colors.black : Colors.grey,
    ),
  );
}

Widget checkboxBuilder(FormFieldState<bool> field) {
  final widget = (field as FastCheckboxState).widget;
  final titleBuilder = widget.titleBuilder ?? checkboxTitleBuilder;

  return InputDecorator(
    decoration: field.decoration,
    child: CheckboxListTile(
      activeColor: widget.activeColor,
      autofocus: widget.autofocus,
      checkColor: widget.checkColor,
      checkboxShape: widget.checkboxShape,
      contentPadding: widget.contentPadding,
      controlAffinity: widget.controlAffinity,
      dense: widget.dense,
      enabled: widget.enabled,
      enableFeedback: widget.enableFeedback,
      focusNode: widget.focusNode,
      isThreeLine: widget.isThreeLine,
      onChanged: widget.enabled ? field.didChange : null,
      secondary: widget.secondary,
      selected: field.value ?? false,
      selectedTileColor: widget.selectedTileColor,
      shape: widget.shapeBorder,
      side: widget.side,
      subtitle: widget.subtitle,
      tileColor: widget.tileColor,
      title: titleBuilder(field),
      tristate: widget.tristate,
      value: field.value,
      visualDensity: widget.visualDensity,
    ),
  );
}
