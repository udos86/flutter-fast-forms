import 'package:flutter/material.dart';

typedef DropdownMenuItemsBuilder = List<DropdownMenuItem> Function(
    BuildContext context, List<dynamic> items);

class DropdownFormField extends FormField<String> {
  DropdownFormField({
    bool autofocus,
    bool autovalidate,
    InputDecoration decoration = const InputDecoration(),
    Color dropdownColor,
    FocusNode focusNode,
    String initialValue,
    List<dynamic> items,
    DropdownMenuItemsBuilder itemsBuilder,
    Key key,
    this.onChanged,
    this.onReset,
    FormFieldSetter onSaved,
    DropdownButtonBuilder selectedItemBuilder,
    FormFieldValidator validator,
  })  : assert(decoration != null),
        super(
          autovalidate: autovalidate,
          builder: (field) {
            final _itemsBuilder = itemsBuilder ?? dropdownMenuItemsBuilder;
            return DropdownButtonFormField<String>(
              autofocus: autofocus,
              autovalidate: autovalidate,
              decoration: decoration,
              dropdownColor: dropdownColor,
              focusNode: focusNode,
              items: _itemsBuilder(field.context, items),
              onChanged: (value) {
                if (value != field.value) field.didChange(value);
              },
              onSaved: onSaved,
              selectedItemBuilder: selectedItemBuilder,
              validator: validator,
              value: field.value,
            );
          },
          initialValue: initialValue,
          key: key,
          onSaved: onSaved,
          validator: validator,
        );

  final ValueChanged<String> onChanged;
  final VoidCallback onReset;

  @override
  FormFieldState<String> createState() => DropdownFormFieldState();
}

class DropdownFormFieldState extends FormFieldState<String> {
  @override
  DropdownFormField get widget => super.widget as DropdownFormField;

  @override
  void didChange(String value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    widget.onReset?.call();
  }
}

final DropdownMenuItemsBuilder dropdownMenuItemsBuilder =
    (BuildContext context, List<dynamic> items) {
  return items.map((item) {
    return DropdownMenuItem(
      value: item.toString(),
      child: Text(item.toString()),
    );
  }).toList();
};
