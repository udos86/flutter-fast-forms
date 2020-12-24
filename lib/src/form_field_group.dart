import 'package:flutter/material.dart';

import 'form_field.dart';
import 'form_theme.dart';

enum FormFieldGroupOrientation {
  horizontal,
  vertical,
}

@immutable
class FastFormFieldGroup extends StatelessWidget {
  FastFormFieldGroup({
    @required this.children,
    this.orientation = FormFieldGroupOrientation.vertical,
    this.padding,
    this.title,
  });

  final List<FastFormField> children;
  final FormFieldGroupOrientation orientation;
  final EdgeInsets padding;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (title != null) title,
        orientation == FormFieldGroupOrientation.vertical
            ? _buildVerticalFormFieldGroup(context)
            : _buildHorizontalFormFieldGroup(context),
      ],
    );
  }

  Widget _buildVerticalFormFieldGroup(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final field in children) _buildFormField(context, field),
      ],
    );
  }

  Widget _buildHorizontalFormFieldGroup(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final field in children)
          Expanded(
            child: _buildFormField(context, field),
          ),
      ],
    );
  }

  Widget _buildFormField(BuildContext context, FastFormField field) {
    final theme = FastFormTheme.of(context);
    return Container(
      padding: padding ?? theme.padding,
      child: field,
    );
  }
}
