import 'package:flutter/material.dart';

import '../form_style.dart';

import 'form_field.dart';

enum FormFieldModelGroupOrientation {
  horizontal,
  vertical,
}

@immutable
class FormFieldModelGroup extends StatelessWidget {
  FormFieldModelGroup({
    @required this.fields,
    this.orientation = FormFieldModelGroupOrientation.vertical,
    this.padding,
    this.title,
  });

  final List<FastFormField> fields;
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
    final style = FormStyle.of(context);
    return Column(
      children: <Widget>[
        for (final field in fields)
          Container(
            padding: padding ?? style.padding,
            child: field,
          ),
      ],
    );
  }

  Widget _buildHorizontalFormFieldGroup(BuildContext context) {
    final style = FormStyle.of(context);
    return Row(
      children: <Widget>[
        for (final field in fields)
          Expanded(
            child: Container(
              padding: padding ?? style.padding,
              child: field,
            ),
          ),
      ],
    );
  }
}
