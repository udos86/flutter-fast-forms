import 'package:flutter/cupertino.dart';

import '../form.dart';

typedef FastSegmentedControlWidgetBuilder<T extends Object>
    = FastWidgetBuilder<FastSegmentedControlState<T>>;

/// A [FastFormField] that contains a [CupertinoSlidingSegmentedControl].
@immutable
class FastSegmentedControl<T extends Object> extends FastFormField<T> {
  FastSegmentedControl({
    FormFieldBuilder<T>? builder,
    FastSegmentedControlWidgetBuilder<T>? cupertinoErrorBuilder,
    FastSegmentedControlWidgetBuilder<T>? cupertinoHelperBuilder,
    FastSegmentedControlWidgetBuilder<T>? cupertinoPrefixBuilder,
    T? initialValue,
    super.autovalidateMode,
    super.conditions,
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
    super.onTouched,
    super.restorationId,
    super.validator,
    this.backgroundColor = CupertinoColors.tertiarySystemFill,
    required this.children,
    this.disabledChildren = const {},
    this.padding = const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
    this.proportionalWidth = false,
    this.thumbColor,
  })  : assert(children.length >= 2),
        cupertinoErrorBuilder =
            cupertinoErrorBuilder ?? segmentedControlErrorBuilder,
        cupertinoHelperBuilder =
            cupertinoHelperBuilder ?? segmentedControlHelperBuilder,
        cupertinoPrefixBuilder =
            cupertinoPrefixBuilder ?? segmentedControlPrefixBuilder,
        super(
          builder: builder ?? segmentedControlBuilder<T>,
          initialValue: initialValue ?? children.keys.first,
        );

  final Color backgroundColor;
  final Map<T, Widget> children;
  final Set<T> disabledChildren;
  final FastSegmentedControlWidgetBuilder<T> cupertinoErrorBuilder;
  final FastSegmentedControlWidgetBuilder<T> cupertinoHelperBuilder;
  final FastSegmentedControlWidgetBuilder<T> cupertinoPrefixBuilder;
  final EdgeInsetsGeometry padding;
  final bool proportionalWidth;
  final Color? thumbColor;

  @override
  FastSegmentedControlState<T> createState() => FastSegmentedControlState<T>();
}

/// State associated with a [FastSegmentedControl] widget.
class FastSegmentedControlState<T extends Object>
    extends FastFormFieldState<T> {
  @override
  FastSegmentedControl<T> get widget => super.widget as FastSegmentedControl<T>;
}

/// A function that is the default [FastSegmentedControl.cupertinoErrorBuilder].
///
/// Uses [cupertinoErrorBuilder].
Widget? segmentedControlErrorBuilder<T extends Object>(
    FastSegmentedControlState<T> field) {
  return cupertinoErrorBuilder(field);
}

/// A function that is the default [FastSegmentedControl.cupertinoHelperBuilder].
///
/// Uses [cupertinoHelperBuilder].
Widget? segmentedControlHelperBuilder<T extends Object>(
    FastSegmentedControlState<T> field) {
  return cupertinoHelperBuilder(field);
}

/// A function that is the default [FastSegmentedControl.cupertinoPrefixBuilder].
///
/// Uses [cupertinoPrefixBuilder].
Widget? segmentedControlPrefixBuilder<T extends Object>(
    FastSegmentedControlState<T> field) {
  return cupertinoPrefixBuilder(field);
}

/// A [FormFieldBuilder] that is the default [FastSegmentedControl.builder].
///
/// Returns a [CupertinoFormRow] that contains a
/// [CupertinoSlidingSegmentedControl] on any [TargetPlatform].
Widget segmentedControlBuilder<T extends Object>(FormFieldState<T> field) {
  field as FastSegmentedControlState<T>;
  final FastSegmentedControlState<T>(:didChange, :value, :widget) = field;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.cupertinoPrefixBuilder(field),
    helper: widget.cupertinoHelperBuilder(field),
    error: widget.cupertinoErrorBuilder(field),
    child: CupertinoSlidingSegmentedControl<T>(
      backgroundColor: widget.backgroundColor,
      children: widget.children,
      disabledChildren: widget.disabledChildren,
      groupValue: value,
      onValueChanged: didChange,
      padding: widget.padding,
      proportionalWidth: widget.proportionalWidth,
      thumbColor: widget.thumbColor ??
          const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFFFFFFF),
            darkColor: Color(0xFF636366),
          ),
    ),
  );
}
