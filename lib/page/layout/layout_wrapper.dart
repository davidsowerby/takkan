import 'package:flutter/material.dart';
import 'package:precept_client/page/layout/page_layout_column.dart';
import 'package:precept_script/panel/panel.dart';

class LayoutWrapper extends StatelessWidget {
  final PPod config;
  final List<Widget> children;

  const LayoutWrapper({
    required this.config,
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageLayout layout = LayoutByColumn(
        config: config.layout,
        children: children); // TODO: lookup different types of layout
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          _assembleLayout(context, constraints, layout),
    );
  }

  /// TODO: There is only one layout currently defined.  One day there will be more!
  Widget _assembleLayout(
      BuildContext context, BoxConstraints constraints, PageLayout layout) {
    return LayoutByColumn(
      config: config.layout,
      children: children,
    ).assemble(context, constraints);
  }
}

abstract class PageLayout {
  Widget assemble(BuildContext context, BoxConstraints constraint);
}
