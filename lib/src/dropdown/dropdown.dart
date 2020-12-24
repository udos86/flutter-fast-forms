import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';

typedef DropdownMenuItemsBuilder = List<DropdownMenuItem> Function(
    BuildContext context, List<dynamic> items);

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
                final formTheme = FastFormTheme.of(state.context);
                final _decoration = decoration ??
                    formTheme.getInputDecoration(state.context, state.widget) ??
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
                  items: _itemsBuilder(state.context, items),
                  onChanged: enabled ? _onChanged : null,
                  onSaved: onSaved,
                  selectedItemBuilder: selectedItemBuilder,
                  validator: validator,
                  value: state.value,
                );
              },
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
    (BuildContext context, List<dynamic> items) {
  return items.map((item) {
    return DropdownMenuItem<String>(
      value: item.toString(),
      child: Text(item.toString()),
    );
  }).toList();
};
