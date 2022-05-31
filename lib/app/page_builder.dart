import 'package:flutter/material.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_client/pod/page/static_page.dart';
import 'package:takkan_client/pod/panel/static_panel.dart';
import 'package:takkan_client/library/part_library.dart';
import 'package:takkan_client/pod/page/document_list_page.dart';
import 'package:takkan_client/pod/page/document_page.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/part/part.dart';
import 'package:takkan_script/schema/schema.dart';
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
    final s = route.split('/');
    final autogenRoute = (s[0] == 'document' || s[0] == 'documents');
    return (autogenRoute)
        ? _autoGeneratedRoute(route, s, context, pageArguments, script, cache)
        : _staticRoute(route, context, pageArguments, parentBinding, script);
  }

  Route<dynamic>? _staticRoute(
    String route,
    BuildContext context,
    Map<String, dynamic> pageArguments,
    DataBinding parentBinding,
    Script script,
  ) {
    final pageConfig = script.routes[route];
    if (pageConfig == null) {
      return null;
    }
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
    String msg='Unrecognised content';
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

  Route<dynamic>? constructRoute(
      String route, Map<String, dynamic> pageArguments, Widget pageWidget) {
    return MaterialPageRoute(
        settings: RouteSettings(
          name: route,
          arguments: pageArguments,
        ),
        builder: (_) => pageWidget);
  }

  /// When a route contains an object reference, that part of the route is ignored.
  /// When present is should be in the form of 'objectId==xxxxxx'
  Route<dynamic>? _autoGeneratedRoute(
    String route,
    List<String> routeSegments,
    BuildContext context,
    Map<String, dynamic> pageArguments,
    Script script,
    DocumentCache cache,
  ) {
    final documentClassName = routeSegments[1];
    final routeOnly = '${routeSegments[0]}/${routeSegments[1]}';

    /// Cast should be safe, as auto routes only generated from PPage
    PageConfig.Page? pageConfig = script.routes[route];
    if (pageConfig == null) {
      return null;
    }
    Data dataSelector = DataItem();

    /// this gets replaced
    if (routeSegments.length > 2) {
      final selectorTag = routeSegments[2];
      final found = pageConfig.dataSelectors
          .where((element) => element.tag == selectorTag);
      if (found.isEmpty) {
        String msg = 'Data selector tag \'$selectorTag\'not found';
        logType(this.runtimeType).e(msg);
        throw TakkanException(msg);
      }
      if (found.length > 1) {
        String msg = 'Duplicate data selector tag \'$selectorTag\' found';
        logType(this.runtimeType).e(msg);
        throw TakkanException(msg);
      }
      dataSelector = found.first;
    }

    Document? documentSchema = script.schema.documents[documentClassName];
    if (documentSchema == null) {
      String msg =
          "document schema '$documentSchema' has not been declared in the schema, but has been allocated a route";
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }

    final DataContext dataContext =
        DefaultDataContext(classCache: cache.getClassCache(config: pageConfig));
    final pageBuilder = inject<PageBuilder>();
    final pageWidget = (dataSelector.isItem)
        ? DocumentPage(
            dataContext: dataContext,
            pageBuilder: pageBuilder,
            pageArguments: pageArguments,
            config: pageConfig,
            objectId:
                (dataSelector is DataItemById) ? dataSelector.objectId : null,
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
            objectIds:
                (dataSelector is DataListById) ? dataSelector.objectIds : null,
          );
    return constructRoute(
      routeOnly,
      pageArguments,
      pageWidget,
    );
  }
}
