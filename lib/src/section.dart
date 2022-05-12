import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'form.dart';

enum FastFormSectionOrientation { horizontal, vertical }

@immutable
class FastFormSection extends StatelessWidget {
  const FastFormSection({
    super.key,
    this.adaptive = false,
    required this.children,
    this.header,
    this.insetGrouped = false,
    this.orientation = FastFormSectionOrientation.vertical,
    this.padding = EdgeInsets.zero,
  });

  final bool adaptive;
  final List<Widget> children;
  final Widget? header;
  final bool insetGrouped;
  final FastFormSectionOrientation orientation;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    var builder = _buildFormSection;

    if (adaptive) {
      final platform = Theme.of(context).platform;
      if (platform == TargetPlatform.iOS) builder = _buildCupertinoFormSection;
    }

    return builder(context);
  }

  Widget _buildFormSection(BuildContext context) {
    final builder = orientation == FastFormSectionOrientation.vertical
        ? _buildVerticalFormSection
        : _buildHorizontalFormSection;

    return builder(context);
  }

  Widget _buildFormField(BuildContext context, FastFormField field) {
    return Padding(padding: padding, child: field);
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
    final builder = insetGrouped
        ? CupertinoFormSection.insetGrouped
        : CupertinoFormSection.new;

    return builder(
      header: header,
      children: [
        for (final child in children)
          child is FastFormField ? _buildFormField(context, child) : child,
      ],
    );
  }
}
