import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef DropdownMenuItemsBuilder = List<DropdownMenuItem<String>> Function(
    List<String> items, FastDropdownState state);

@immutable
class FastDropdown extends FastFormField<String> {
  FastDropdown({
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
    FormFieldSetter? onSaved,
    FormFieldValidator? validator,
    this.dropdownColor,
    this.focusNode,
    this.hint,
    this.items = const [],
    this.itemsBuilder,
    this.selectedItemBuilder,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder =
                    scope?.builders[FastDropdown] ?? dropdownBuilder;
                return builder(field);
              },
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final Color? dropdownColor;
  final FocusNode? focusNode;
  final Widget? hint;
  final List<String> items;
  final DropdownMenuItemsBuilder? itemsBuilder;
  final DropdownButtonBuilder? selectedItemBuilder;

  @override
  FastDropdownState createState() => FastDropdownState();
}

class FastDropdownState extends FastFormFieldState<String> {
  @override
  FastDropdown get widget => super.widget as FastDropdown;
}

List<DropdownMenuItem<String>> dropdownMenuItemsBuilder(
    List<String> items, FastDropdownState state) {
  return items.map((item) {
    return DropdownMenuItem<String>(
      value: item.toString(),
      child: Text(item.toString()),
    );
  }).toList();
}

DropdownButtonFormField<String> dropdownBuilder(FormFieldState<String> field) {
  final state = field as FastDropdownState;
  final widget = state.widget;

  final decorator = FastFormScope.of(state.context)?.inputDecorator;
  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final _itemsBuilder = widget.itemsBuilder ?? dropdownMenuItemsBuilder;
  void _onChanged(value) {
    if (value != field.value) field.didChange(value);
  }

  return DropdownButtonFormField<String>(
    autofocus: widget.autofocus,
    autovalidateMode: widget.autovalidateMode,
    decoration: _decoration,
    dropdownColor: widget.dropdownColor,
    focusNode: widget.focusNode,
    hint: widget.hint,
    items: _itemsBuilder(widget.items, state),
    onChanged: widget.enabled ? _onChanged : null,
    onSaved: widget.onSaved,
    selectedItemBuilder: widget.selectedItemBuilder,
    validator: widget.validator,
    value: state.value,
  );
}
