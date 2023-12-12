import 'package:flutter/material.dart';

import 'form.dart';

/// Signature for building a single array item.
///
/// The [key] should always be passed to the superclass constructor of the
/// [Widget] that is returned from the builder to preserve the state across
/// widget trees when array items are moved around.
/// see https://medium.com/flutter/keys-what-are-they-good-for-13cb51742e7d
typedef FastFormArrayItemBuilder<T> = Widget Function(
    UniqueKey key, int index, FastFormArrayState<T> field);

/// Signature for building the widget when the array is empty.
typedef FastFormEmptyArrayBuilder<T> = Widget Function(
    FastFormArrayState<T> field);

/// A form field that maintains an array of homogenous items whose total number
/// or position can dynamically change at runtime depending on individual user
/// input.
class FastFormArray<T> extends FastFormField<List<T?>> {
  const FastFormArray({
    FormFieldBuilder<List<T?>>? builder,
    super.adaptive,
    super.autovalidateMode,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.emptyBuilder,
    required this.itemBuilder,
    this.reorderable = false,
  }) : super(builder: builder ?? formArrayBuilder<T>);

  final FastFormEmptyArrayBuilder? emptyBuilder;
  final FastFormArrayItemBuilder<T> itemBuilder;
  final bool reorderable;

  @override
  FastFormArrayState<T> createState() => FastFormArrayState<T>();
}

class FastFormArrayState<T> extends FastFormFieldState<List<T?>> {
  /// Saves a [UniqueKey] for every single array item.
  final List<UniqueKey> _keys = [];

  /// Returns the [FastFormArray] widget.
  @override
  FastFormArray<T> get widget => super.widget as FastFormArray<T>;

  /// Calls [_initKeys] to initially create [_keys] when [initState] is called.
  @override
  void initState() {
    super.initState();
    _initKeys();
  }

  /// Calls [_initKeys] to reset [_keys] when [onReset] is called.
  @override
  void onReset() {
    super.onReset();
    _initKeys();
  }

  ///  Updates the [value] of the item at the specified [index].
  ///
  /// Triggers [Form.didChange] under the hood to update the state of the
  /// form field.
  ///
  /// method should be called inside [FastFormArrayItemBuilder] whenever a
  /// value change occurs on an array item.
  void didItemChange(int index, T? value) {
    final newValue = this.value != null ? [...this.value!] : <T?>[];
    newValue[index] = value;
    didChange(newValue);
  }

  /// Adds a new item with the initial [value] to the end of the array.
  void add(T? value) {
    _keys.add(UniqueKey());
    final newValue = this.value != null ? [...this.value!, value] : [value];
    didChange(newValue);
  }

  /// Inserts a new item with the initial [value] at the specified [index].
  void insert(int index, T? value) {
    _keys.insert(index, UniqueKey());
    final newValue = (this.value != null ? [...this.value!] : <T?>[])
      ..insert(index, value);
    didChange(newValue);
  }

  /// Moves an item from the specified [index] to the [newIndex].
  void move(int index, int newIndex) {
    if (newIndex < 0 || newIndex >= value!.length) return;

    final item = value![index];
    final key = _keys[index];

    _keys
      ..removeAt(index)
      ..insert(newIndex, key);

    didChange([...value!]
      ..removeAt(index)
      ..insert(newIndex, item));
  }

  /// Removes the item at the specified [index].
  void remove(int index) {
    if (value == null || index < 0 || index >= value!.length) return;

    _keys.removeAt(index);
    final newValue = [...value!]..removeAt(index);
    didChange(newValue);
  }

  /// Clears and (re-)initializes [_keys] based on the [initialValue] of the
  /// array.
  void _initKeys() {
    if (_keys.isNotEmpty) _keys.clear();
    if (widget.initialValue != null) {
      for (var index = 0; index < widget.initialValue!.length; index++) {
        _keys.add(UniqueKey());
      }
    }
  }
}

/// The default [FormFieldBuilder] of [FastFormArray].
///
/// Renders a [ReorderableListView] when [reorderable] is set to `true` which
/// allows moving single items around via drag & drop.
Widget formArrayBuilder<T>(FormFieldState<List<T?>> field) {
  final widget = (field as FastFormArrayState<T>).widget;
  final value = field.value;
  final hasItems = value is List<T?> && value.isNotEmpty;
  final children = <Widget>[
    if (hasItems)
      for (var index = 0; index < value.length; index++)
        widget.itemBuilder(field._keys[index], index, field),
    if (!hasItems && widget.emptyBuilder != null) widget.emptyBuilder!(field),
  ];

  return InputDecorator(
    decoration: field.decoration,
    child: widget.reorderable
        ? ReorderableListView(
            shrinkWrap: true,
            onReorder: (int oldIndex, int newIndex) {
              final trueNewIndex =
                  oldIndex > newIndex ? newIndex : newIndex - 1;
              field.move(oldIndex, trueNewIndex);
            },
            children: children,
          )
        : Column(children: children),
  );
}
