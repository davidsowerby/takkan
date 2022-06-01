import 'package:flutter/material.dart';
import 'package:takkan_client/config/convert/script.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/pod/layout/layout_distributed_column.dart';
import 'package:takkan_script/panel/panel.dart';

class LayoutWrapper extends StatelessWidget {
  final Pod config;
  final DataBinding parentBinding;
  final DataContext dataContext;
  final Map<String, dynamic> pageArguments;

  const LayoutWrapper({
    required this.pageArguments,
    required this.config,
    required this.dataContext,
    required this.parentBinding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          _outerContainer(
        context: context,
        constraints: constraints,
        pageArguments: pageArguments,
      ),
    );
  }

  Container _outerContainer({
    required BuildContext context,
    required BoxConstraints constraints,
    required Map<String, dynamic> pageArguments,
  }) {
    final padding = config.layout.padding;
    final theme = Theme.of(context);
    return Container(
      padding: padding.edgeInsets(),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            _assembleLayout(
          context: context,
          constraints: constraints,
          theme: theme,
          pageArguments: pageArguments,
        ),
      ),
    );
  }

  /// TODO: There is only one layout currently defined.  One day there will be more!
  Widget _assembleLayout({
    required BuildContext context,
    required BoxConstraints constraints,
    required ThemeData theme,
    required Map<String, dynamic> pageArguments,
  }) {
    return LayoutDistributedColumn(
      layoutConfig: config.layout,
      podConfig: config,
      parentBinding: parentBinding,
      dataContext: dataContext,
      theme: theme,
    ).assemble(
      context: context,
      constraints: constraints,
      pageArguments: pageArguments,
    );
  }
}

abstract class PageLayout {
  Widget assemble({
    required BuildContext context,
    required BoxConstraints constraints,
    required Map<String, dynamic> pageArguments,
  });
}
