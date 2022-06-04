import 'package:flutter/material.dart';

import 'form.dart';

typedef FastFormArrayItemBuilder<T> = Widget Function(
    UniqueKey key, int index, FastFormArrayState<T> field);

class FastFormArray<T> extends FastFormField<List<T>> {
  const FastFormArray({
    FormFieldBuilder<List<T>>? builder,
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
    super.validator,
    required this.itemBuilder,
  }) : super(builder: builder ?? formArrayBuilder<T>);

  final FastFormArrayItemBuilder<T> itemBuilder;

  @override
  FastFormArrayState<T> createState() => FastFormArrayState<T>();
}

class FastFormArrayState<T> extends FastFormFieldState<List<T>> {
  final List<UniqueKey> keys = [];

  @override
  FastFormArray<T> get widget => super.widget as FastFormArray<T>;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      for (var index = 0; index < widget.initialValue!.length; index++) {
        keys.add(UniqueKey());
      }
    }
  }

  void didItemChange(int index, T value) {
    final newValue = [...this.value!];
    newValue[index] = value;
    didChange(newValue);
  }

  void add(T value) {
    keys.add(UniqueKey());
    didChange([...this.value!, value]);
  }

  void insert(int index, T value) {
    keys.insert(index, UniqueKey());
    didChange([...this.value!]..insert(index, value));
  }

  void move(int oldIndex, int newIndex) {
    if (newIndex >= 0 && newIndex < value!.length) {
      final item = value![oldIndex];
      final key = keys[oldIndex];

      keys
        ..removeAt(oldIndex)
        ..insert(newIndex, key);

      didChange([...value!]
        ..removeAt(oldIndex)
        ..insert(newIndex, item));
    }
  }

  void remove(int index) {
    keys.removeAt(index);
    didChange([...value!]..removeAt(index));
  }
}

Widget formArrayBuilder<T>(FormFieldState<List<T>> field) {
  final widget = (field as FastFormArrayState<T>).widget;
  final value = field.value;

  return InputDecorator(
    decoration: field.decoration,
    child: Column(
      children: [
        if (value != null)
          for (var index = 0; index < value.length; index++)
            widget.itemBuilder(field.keys[index], index, field),
      ],
    ),
  );
}

Widget reorderableFormArrayBuilder<T>(FormFieldState<List<T>> field) {
  final widget = (field as FastFormArrayState<T>).widget;
  final value = field.value;

  return InputDecorator(
    decoration: field.decoration,
    child: ReorderableListView(
      shrinkWrap: true,
      onReorder: (int oldIndex, int newIndex) {
        final trueNewIndex = oldIndex > newIndex ? newIndex : newIndex - 1;
        field.move(oldIndex, trueNewIndex);
      },
      children: [
        if (value != null)
          for (var index = 0; index < value.length; index++)
            widget.itemBuilder(field.keys[index], index, field),
      ],
    ),
  );
}
