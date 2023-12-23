import 'package:flutter/cupertino.dart';

import '../form.dart';

typedef FastSegmentedControlWidgetBuilder<T>
    = FastWidgetBuilder<FastSegmentedControlState<T>>;

/// A [FastFormField] that contains a [CupertinoSlidingSegmentedControl].
@immutable
class FastSegmentedControl<T> extends FastFormField<T> {
  FastSegmentedControl({
    FormFieldBuilder<T>? builder,
    @Deprecated('Use cupertinoErrorBuilder instead.')
    FastSegmentedControlWidgetBuilder<T>? errorBuilder,
    @Deprecated('Use cupertinoHelperBuilder instead.')
    FastSegmentedControlWidgetBuilder<T>? helperBuilder,
    FastSegmentedControlWidgetBuilder<T>? cupertinoErrorBuilder,
    FastSegmentedControlWidgetBuilder<T>? cupertinoHelperBuilder,
    FastSegmentedControlWidgetBuilder<T>? cupertinoPrefixBuilder,
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
    this.padding = const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
    this.thumbColor,
  })  : assert(children.length >= 2),
        cupertinoErrorBuilder = errorBuilder ??
            cupertinoErrorBuilder ??
            segmentedControlErrorBuilder,
        cupertinoHelperBuilder = errorBuilder ??
            cupertinoHelperBuilder ??
            segmentedControlHelperBuilder,
        cupertinoPrefixBuilder =
            cupertinoPrefixBuilder ?? segmentedControlPrefixBuilder,
        super(
          builder: builder ?? segmentedControlBuilder,
          initialValue: initialValue ?? children.keys.first,
        );

  final Color backgroundColor;
  final Map<T, Widget> children;
  final FastSegmentedControlWidgetBuilder<T> cupertinoErrorBuilder;
  final FastSegmentedControlWidgetBuilder<T> cupertinoHelperBuilder;
  final FastSegmentedControlWidgetBuilder<T> cupertinoPrefixBuilder;
  final EdgeInsetsGeometry padding;
  final Color? thumbColor;

  @override
  FastSegmentedControlState<T> createState() => FastSegmentedControlState<T>();
}

/// State associated with a [FastSegmentedControl] widget.
class FastSegmentedControlState<T> extends FastFormFieldState<T> {
  @override
  FastSegmentedControl<T> get widget => super.widget as FastSegmentedControl<T>;
}

/// A function that is the default [FastSegmentedControl.cupertinoErrorBuilder].
///
/// Uses [cupertinoErrorBuilder].
Widget? segmentedControlErrorBuilder<T>(FastSegmentedControlState<T> field) {
  return cupertinoErrorBuilder(field);
}

/// A function that is the default [FastSegmentedControl.cupertinoHelperBuilder].
///
/// Uses [cupertinoHelperBuilder].
Widget? segmentedControlHelperBuilder<T>(FastSegmentedControlState<T> field) {
  return cupertinoHelperBuilder(field);
}

/// A function that is the default [FastSegmentedControl.cupertinoPrefixBuilder].
///
/// Uses [cupertinoPrefixBuilder].
Widget? segmentedControlPrefixBuilder<T>(FastSegmentedControlState<T> field) {
  return cupertinoPrefixBuilder(field);
}

/// A [FormFieldBuilder] that is the default [FastSegmentedControl.builder].
///
/// Returns a [CupertinoFormRow] that contains a
/// [CupertinoSlidingSegmentedControl] on any [TargetPlatform].
Widget segmentedControlBuilder<T>(FormFieldState<T> field) {
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
      groupValue: value,
      onValueChanged: didChange,
      padding: widget.padding,
      thumbColor: widget.thumbColor ??
          const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFFFFFFF),
            darkColor: Color(0xFF636366),
          ),
    ),
  );
}
