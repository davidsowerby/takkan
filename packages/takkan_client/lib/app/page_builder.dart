import 'package:flutter/material.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_client/pod/page/static_page.dart';
import 'package:takkan_client/pod/panel/static_panel.dart';
import 'package:takkan_client/library/part_library.dart';
import 'package:takkan_client/pod/page/document_list_page.dart';
import 'package:takkan_client/pod/page/document_page.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/part/part.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_script/script/content.dart';
import 'package:takkan_script/script/script.dart';

abstract class PageBuilder {
  Route<dynamic>? buildPage({
    required String route,
    required Map<String, dynamic> pageArguments,
    required BuildContext context,
    required DataBinding parentBinding,
    required Script script,
    required DocumentCache cache,
  });

  Widget createChild({
    required DataContext dataContext,
    required Content p,
    required DataBinding parentBinding,
    required ThemeData theme,
    required Map<String, dynamic> pageArguments,
  });
}

class DefaultPageBuilder implements PageBuilder {
  const DefaultPageBuilder();

  Route<dynamic>? buildPage({
    required String route,
    required Map<String, dynamic> pageArguments,
    required BuildContext context,
    required DataBinding parentBinding,
    required Script script,
    required DocumentCache cache,
  }) {
    final takkanRoute = TakkanRoute.fromString(route);
    final pageConfig = script.routes[takkanRoute];
    if (pageConfig is PageConfig.Page) {
      return (pageConfig.isStatic)
          ? _staticRoute(
              takkanRoute,
              context,
              pageArguments,
              parentBinding,
              script,
              pageConfig,
            )
          : _dynamicRoute(
              takkanRoute,
              context,
              pageArguments,
              script,
              cache,
              pageConfig,
            );
    }
    return null;
  }

  Route<dynamic>? _staticRoute(
    TakkanRoute route,
    BuildContext context,
    Map<String, dynamic> pageArguments,
    DataBinding parentBinding,
    Script script,
    PageConfig.Page pageConfig,
  ) {
    final PageConfig.Page pageCfg = pageConfig;
    final dataContext = StaticDataContext(
      parentDataContext: NullDataContext(),
    );
    final pageBuilder = inject<PageBuilder>();
    final pageWidget = StaticPage(
      pageBuilder: pageBuilder,
      config: pageCfg,
      dataContext: dataContext,
      route: route,
      pageArguments: pageArguments,
    );
    return constructRoute(
      route,
      pageArguments,
      pageWidget,
    );
  }

  List<Widget> createChildren({
    required DataContext dataContext,
    required List<Content> children,
    required DataBinding parentBinding,
    required ThemeData theme,
    required Map<String, dynamic> pageArguments,
  }) {
    final output = List<Widget>.empty(growable: true);

    /// Using switch stops from detecting Part sub-classes
    for (Content p in children) {
      if (p is Panel) {
        final panel = panelBuilder(
          config: p,
          parentDataContext: dataContext,
          parentBinding: parentBinding,
          theme: theme,
          pageArguments: pageArguments,
        );
        output.add(panel);
      } else if (p is Part) {
        final part = library.constructPart(
          config: p,
          theme: theme,
          parentDataBinding: parentBinding,
          dataContext: dataContext,
          pageArguments: pageArguments,
        );
        output.add(part);
      }
    }
    return output;
  }

  Widget panelBuilder({
    required Panel config,
    required DataContext parentDataContext,
    required DataBinding parentBinding,
    required ThemeData theme,
    required Map<String, dynamic> pageArguments,
  }) {
    if (config.isStatic) {
      final widget = StaticPanel(
        content: panelExpansion(
          config: config,
          content: createChildren(
            parentBinding: parentBinding,
            theme: theme,
            dataContext: parentDataContext,
            children: config.children,
            pageArguments: pageArguments,
          ),
        ),
        parentDataContext: parentDataContext,
      );
      return widget;
    }

    throw UnimplementedError();
  }

  Widget createChild({
    required DataContext dataContext,
    required Content p,
    required DataBinding parentBinding,
    required ThemeData theme,
    required Map<String, dynamic> pageArguments,
  }) {
    /// Using switch stops from detecting Part sub-classes
    if (p is Panel) {
      final panel = panelBuilder(
        config: p,
        parentDataContext: dataContext,
        parentBinding: parentBinding,
        theme: theme,
        pageArguments: pageArguments,
      );
      return panel;
    } else if (p is Part) {
      final part = library.constructPart(
        config: p,
        theme: theme,
        parentDataBinding: parentBinding,
        dataContext: dataContext,
        pageArguments: pageArguments,
      );
      return part;
    }
    String msg = 'Unrecognised content';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  /// TODO: Panel style was removed, something needs to replace it
  Widget panelExpansion(
      {required Panel config, required List<Widget> content}) {
    return true
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

  Route<dynamic>? constructRoute(TakkanRoute route,
      Map<String, dynamic> pageArguments, Widget pageWidget) {
    return MaterialPageRoute(
        settings: RouteSettings(
          name: route.toString(),
          arguments: pageArguments,
        ),
        builder: (_) => pageWidget);
  }

  Route<dynamic>? _dynamicRoute(
    TakkanRoute route,
    BuildContext context,
    Map<String, dynamic> pageArguments,
    Script script,
    DocumentCache cache,
    PageConfig.Page pageConfig,
  ) {
    Document? documentSchema =
        script.schema.documents[pageConfig.documentClass!];
    if (documentSchema == null) {
      String msg =
          "document schema '$documentSchema' has not been declared in the schema, but has been allocated a route";
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }

    final dataSelector = pageConfig.dataSelectorByName(route.dataSelectorName);

    final DataContext dataContext =
        DefaultDataContext(classCache: cache.getClassCache(config: pageConfig));
    final pageWidget = (dataSelector.isItem)
        ? DocumentPage(
            dataContext: dataContext,
            pageArguments: pageArguments,
            config: pageConfig,
            route: route,
          )
        : DocumentListPage(
            dataContext: cache.dataContext(
              dataSelector: dataSelector,
              parentDataContext: NullDataContext(),
              config: pageConfig,
            ),
            pageArguments: pageArguments,
            config: pageConfig,
            route: route,
          );
    return constructRoute(
      route,
      pageArguments,
      pageWidget,
    );
  }
}
