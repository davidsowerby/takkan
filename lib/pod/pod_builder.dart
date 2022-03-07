import 'package:flutter/material.dart';
import 'package:precept_client/data/cache_entry.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/page/document_page.dart';
import 'package:precept_client/page/static_page.dart';
import 'package:precept_client/panel/static_panel.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';

import '../library/part_library.dart';

Widget pageBuilder({
  required PPage config,
  required DataContext dataContext,
  required ThemeData theme,
  required String route,
  required DataBinding parentBinding,
  required Map<String, dynamic> pageArguments,
}) {
  if (config.isStatic)
    return StaticPage(
      children: createChildren(
          children: config.children,
          theme: theme,
          parentBinding: parentBinding,
          dataContext: StaticDataContext(parentDataContext: dataContext)),
      config: config as PPageStatic,
      dataContext: dataContext,
      route: route,
    );
  if (config.isDataRoot) {
    // precept.cache.dataConnector(parentDataConnector: Null, config: config, requester: requester)
    return DocumentPage(
      route: '?',
      dataContext: dataContext,
      pageArguments: pageArguments,
      config: config,
    );
  }

  throw UnimplementedError();
}

Widget panelBuilder({
  required PPanel config,
  required DataContext parentDataContext,
  required DataBinding parentBinding,
  required ThemeData theme,
}) {
  if (config.isStatic) {
    final widget = StaticPanel(
      content: panelExpansion(
        config: config,
        content: createChildren(
          theme: theme,
          parentBinding: parentBinding,
          dataContext: parentDataContext,
          children: config.children,
        ),
      ),
      parentDataContext: parentDataContext,
    );
    return widget;
  }

  throw UnimplementedError();
}

Widget panelExpansion({required PPanel config, required List<Widget> content}) {
  return config.panelStyle.expandable
      ? ExpansionTile(
          title: Text(config.caption ?? ''),
          children: content,
        )
      : Container(
          child: ListView(
            children: content,
          ),
        );
}

List<Widget> createChildren(
    {required DataContext dataContext,
    required List<PContent> children,
    required DataBinding parentBinding,
    required ThemeData theme}) {
  final output = List<Widget>.empty(growable: true);

  /// Using switch stops from detecting PPart sub-classes
  for (PContent p in children) {
    if (p is PPanel) {
      final panel = panelBuilder(
        config: p,
        parentDataContext: dataContext,
        parentBinding: parentBinding,
        theme: theme,
      );
      output.add(panel);
    } else if (p is PPart) {
      final part = partLibrary.partBuilder(
        partConfig: p,
        dataContext: dataContext,
        parentBinding: parentBinding,
        pageArguments: const {},
        theme: theme,
      );
      output.add(part);
    }
  }
  return output;
}
