import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

@immutable
class FastSegmentedControl extends FastFormField<String> {
  FastSegmentedControl({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<String>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    String? initialValue,
    Key? key,
    String? label,
    ValueChanged<String>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    this.backgroundColor = CupertinoColors.tertiarySystemFill,
    required this.children,
    this.errorBuilder,
    this.helperBuilder,
    this.padding = const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
    this.thumbColor,
  })  : assert(children.length >= 2),
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder = scope?.builders[FastSegmentedControl] ??
                    cupertinoSegmentedControlBuilder;
                return builder(field);
              },
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue ?? children.keys.first,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final Color backgroundColor;
  final Map<String, Widget> children;
  final ErrorBuilder<String>? errorBuilder;
  final HelperBuilder<String>? helperBuilder;
  final EdgeInsetsGeometry padding;
  final Color? thumbColor;

  @override
  FastSegmentedControlState createState() => FastSegmentedControlState();
}

class FastSegmentedControlState extends FastFormFieldState<String> {
  @override
  FastSegmentedControl get widget => super.widget as FastSegmentedControl;
}

CupertinoFormRow cupertinoSegmentedControlBuilder(
    FormFieldState<String> field) {
  final state = field as FastSegmentedControlState;
  final widget = state.widget;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.label is String ? Text(widget.label!) : null,
    helper: widget.helperBuilder?.call(state) ?? helperBuilder(state),
    error: widget.errorBuilder?.call(state) ?? errorBuilder(state),
    child: CupertinoSlidingSegmentedControl<String>(
      backgroundColor: widget.backgroundColor,
      children: widget.children,
      groupValue: state.value,
      onValueChanged: state.didChange,
      padding: widget.padding,
      thumbColor: widget.thumbColor ??
          const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFFFFFFF),
            darkColor: Color(0xFF636366),
          ),
    ),
  );
}
