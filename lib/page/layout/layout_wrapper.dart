import 'package:flutter/material.dart';
import 'package:precept_client/app/page_builder.dart';
import 'package:precept_client/convert/script.dart';
import 'package:precept_client/data/cache_entry.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/page/layout/page_layout_column.dart';
import 'package:precept_script/panel/panel.dart';

class LayoutWrapper extends StatelessWidget {
  final PPod config;
  final DataBinding parentBinding;
  final DataContext dataContext;
  final PageBuilder pageBuilder;

  const LayoutWrapper({
    required this.config,
    required this.dataContext,
    required this.parentBinding,
    required this.pageBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          _outerContainer(context, constraints),
    );
  }

  Container _outerContainer(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final padding = config.layout.padding;
    final theme = Theme.of(context);
    return Container(
      padding: padding.edgeInsets(),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            _assembleLayout(context, constraints, theme),
      ),
    );
  }

  /// TODO: There is only one layout currently defined.  One day there will be more!
  Widget _assembleLayout(
    BuildContext context,
    BoxConstraints constraints,
    ThemeData theme,
  ) {
    return LayoutDistributedColumn(
      layoutConfig: config.layout,
      podConfig: config,
      parentBinding: parentBinding,
      dataContext: dataContext,
      theme: theme,
      pageBuilder: pageBuilder,
    ).assemble(context, constraints);
  }
}

abstract class PageLayout {
  Widget assemble(BuildContext context, BoxConstraints constraints);
}
