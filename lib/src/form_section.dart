import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'form_field.dart';

enum FormSectionOrientation { horizontal, vertical }

@immutable
class FastFormSection extends StatelessWidget {
  FastFormSection({
    this.adaptive = false,
    required this.children,
    this.header,
    this.insetGrouped = false,
    this.orientation = FormSectionOrientation.vertical,
    this.padding = EdgeInsets.zero,
  });

  final bool adaptive;
  final List<Widget> children;
  final Widget? header;
  final bool insetGrouped;
  final FormSectionOrientation orientation;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (this.adaptive) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.iOS:
          return _buildCupertinoFormSection(context);
        case TargetPlatform.android:
        default:
          return _buildFormSection(context);
      }
    }

    return _buildFormSection(context);
  }

  Widget _buildFormSection(BuildContext context) {
    return orientation == FormSectionOrientation.vertical
        ? _buildVerticalFormSection(context)
        : _buildHorizontalFormSection(context);
  }

  Widget _buildFormField(BuildContext context, FastFormField field) {
    return Padding(
      padding: padding,
      child: field,
    );
  }

  Widget _buildVerticalFormSection(BuildContext context) {
    return Column(
      children: <Widget>[
        if (header != null) header!,
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

  Widget _buildCupertinoFormSection(BuildContext context) {
    final _children = <Widget>[
      for (final child in children)
        child is FastFormField ? _buildFormField(context, child) : child,
    ];

    return insetGrouped
        ? CupertinoFormSection.insetGrouped(header: header, children: _children)
        : CupertinoFormSection(header: header, children: _children);
  }
}
