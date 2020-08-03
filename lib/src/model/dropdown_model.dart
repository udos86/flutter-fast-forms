import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../form_container.dart';
import 'form_field_model.dart';

import '../form_style.dart';

@immutable
class DropdownModel extends FormFieldModel<String> {
  DropdownModel({
    builder,
    decoration,
    helper,
    hint,
    id,
    String initialValue,
    label,
    validator,
    this.items,
  }) : super(
          builder: builder ??
              (context, state) {
                final store =
                    Provider.of<FastFormStore>(context, listen: false);
                final styler = FormStyle.of(context);
                return DropdownButtonFormField(
                    decoration: decoration ??
                        styler.createInputDecoration(context, state.widget),
                    autovalidate: state.autovalidate,
                    items: buildDropdownMenuItems(items),
                    value: state.value,
                    validator: validator,
                    onSaved: (value) => store.setValue(id, value),
                    onChanged: state.save);
              },
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final List<String> items;

  static List<DropdownMenuItem> buildDropdownMenuItems(List<String> items) {
    return items.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  @override
  State<StatefulWidget> createState() => FormFieldModelState<String>();
}
