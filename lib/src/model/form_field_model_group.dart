import 'package:flutter/material.dart';

import 'form_field_model.dart';

enum FormFieldModelGroupOrientation {
  horizontal,
  vertical,
}

@immutable
class FormFieldModelGroup extends StatelessWidget {
  FormFieldModelGroup({
    @required this.fields,
    this.orientation = FormFieldModelGroupOrientation.vertical,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
    this.title,
  });

  final List<FormFieldModel> fields;
  final FormFieldModelGroupOrientation orientation;
  final EdgeInsets padding;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (title != null) title,
        orientation == FormFieldModelGroupOrientation.vertical
            ? _buildVerticalFormFieldGroup(context)
            : _buildHorizontalFormFieldGroup(context),
      ],
    );
  }

  Widget _buildVerticalFormFieldGroup(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final field in fields)
          Container(
            padding: padding,
            child: field,
          ),
      ],
    );
  }

  Widget _buildHorizontalFormFieldGroup(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final field in fields)
          Expanded(
            child: Container(
              padding: padding,
              child: field,
            ),
          ),
      ],
    );
  }
}
