import 'package:flutter/material.dart';

import 'form_field.dart';
import 'form_theme.dart';

enum FormSectionOrientation { horizontal, vertical }

@immutable
class FastFormSection extends StatelessWidget {
  FastFormSection({
    @required this.children,
    this.orientation = FormSectionOrientation.vertical,
    this.padding,
    this.title,
  });

  final List<Widget> children;
  final FormSectionOrientation orientation;
  final EdgeInsets padding;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (title != null) title,
        orientation == FormSectionOrientation.vertical
            ? _buildVerticalFormSection(context)
            : _buildHorizontalFormSection(context),
      ],
    );
  }

  Widget _buildVerticalFormSection(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final field in children) _buildFormField(context, field),
      ],
    );
  }

  Widget _buildHorizontalFormSection(BuildContext context) {
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
