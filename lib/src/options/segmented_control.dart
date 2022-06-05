import 'package:flutter/cupertino.dart';

import '../form.dart';

@immutable
class FastSegmentedControl<T> extends FastFormField<T> {
  FastSegmentedControl({
    FormFieldBuilder<T>? builder,
    T? initialValue,
    super.autovalidateMode,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.backgroundColor = CupertinoColors.tertiarySystemFill,
    required this.children,
    this.errorBuilder,
    this.helperBuilder,
    this.padding = const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
    this.thumbColor,
  })  : assert(children.length >= 2),
        super(
          builder: builder ?? segmentedControlBuilder<T>,
          initialValue: initialValue ?? children.keys.first,
        );

  final Color backgroundColor;
  final Map<T, Widget> children;
  final FastErrorBuilder<T>? errorBuilder;
  final FastHelperBuilder<T>? helperBuilder;
  final EdgeInsetsGeometry padding;
  final Color? thumbColor;

  @override
  FastSegmentedControlState<T> createState() => FastSegmentedControlState<T>();
}

class FastSegmentedControlState<T> extends FastFormFieldState<T> {
  @override
  FastSegmentedControl<T> get widget => super.widget as FastSegmentedControl<T>;
}

Widget segmentedControlBuilder<T>(FormFieldState<T> field) {
  final widget = (field as FastSegmentedControlState<T>).widget;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.labelText is String ? Text(widget.labelText!) : null,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: CupertinoSlidingSegmentedControl<T>(
      backgroundColor: widget.backgroundColor,
      children: widget.children,
      groupValue: field.value,
      onValueChanged: field.didChange,
      padding: widget.padding,
      thumbColor: widget.thumbColor ??
          const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFFFFFFF),
            darkColor: Color(0xFF636366),
          ),
    ),
  );
}
