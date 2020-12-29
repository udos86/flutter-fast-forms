import 'package:flutter/material.dart';

import 'form_field.dart';
import 'form_scope.dart';

enum FormSectionOrientation { horizontal, vertical }

@immutable
class FastFormSection extends StatelessWidget {
  FastFormSection({
    required this.children,
    this.orientation = FormSectionOrientation.vertical,
    this.padding,
    this.title,
  });

  final List<Widget> children;
  final FormSectionOrientation orientation;
  final EdgeInsets? padding;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (title != null) title!,
        orientation == FormSectionOrientation.vertical
            ? _buildVerticalFormSection(context)
            : _buildHorizontalFormSection(context),
      ],
    );
  }

  Widget _buildVerticalFormSection(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final child in children)
          child is FastFormField ? _buildFormField(context, child) : child,
      ],
    );
  }

  Widget _buildHorizontalFormSection(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final child in children)
          Expanded(
            child: child is FastFormField
                ? _buildFormField(context, child)
                : child,
          ),
      ],
    );
  }

  Widget _buildFormField(BuildContext context, FastFormField field) {
    final scope = FastFormScope.of(context);
    return Container(
      padding: padding ?? scope?.padding,
      child: field,
    );
  }
}
