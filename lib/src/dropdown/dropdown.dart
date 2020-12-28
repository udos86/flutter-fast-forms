import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef DropdownMenuItemsBuilder = List<DropdownMenuItem> Function(
    List<dynamic> items, FastDropdownState state);

@immutable
class FastDropdown extends FastFormField<String> {
  FastDropdown({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<String> builder,
    InputDecoration decoration,
    Color dropdownColor,
    bool enabled = true,
    FocusNode focusNode,
    String helper,
    @required String id,
    String initialValue,
    List<dynamic> items,
    DropdownMenuItemsBuilder itemsBuilder,
    Key key,
    String label,
    ValueChanged<String> onChanged,
    VoidCallback onReset,
    FormFieldSetter onSaved,
    DropdownButtonBuilder selectedItemBuilder,
    FormFieldValidator validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastDropdownState;
                final decorator =
                    FastFormScope.of(state.context).inputDecorator;
                final _decoration = decoration ??
                    decorator(state.context, state.widget) ??
                    const InputDecoration();
                final _itemsBuilder = itemsBuilder ?? dropdownMenuItemsBuilder;
                final _onChanged = (value) {
                  if (value != field.value) field.didChange(value);
                };
                return DropdownButtonFormField<String>(
                  autofocus: autofocus,
                  autovalidateMode: autovalidateMode,
                  decoration: _decoration,
                  dropdownColor: dropdownColor,
                  focusNode: focusNode,
                  items: _itemsBuilder(items, state),
                  onChanged: enabled ? _onChanged : null,
                  onSaved: onSaved,
                  selectedItemBuilder: selectedItemBuilder,
                  validator: validator,
                  value: state.value,
                );
              },
          decoration: decoration,
          enabled: enabled,
          helper: helper,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  @override
  FastDropdownState createState() => FastDropdownState();
}

class FastDropdownState extends FastFormFieldState<String> {
  @override
  FastDropdown get widget => super.widget as FastDropdown;
}

final DropdownMenuItemsBuilder dropdownMenuItemsBuilder =
    (List<dynamic> items, FastDropdownState state) {
  return items.map((item) {
    return DropdownMenuItem<String>(
      value: item.toString(),
      child: Text(item.toString()),
    );
  }).toList();
};
