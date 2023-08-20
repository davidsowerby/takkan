import 'package:flutter/material.dart';
import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/app/takkan.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/pod/page/error_page.dart';
import 'package:takkan_client/pod/panel/panel.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/script/error.dart';
import 'package:takkan_script/script/script.dart';

/// Router for Takkan.
///
/// This class should be used as a singleton. It is accessible either via [router],
/// or by invoking inject<TakkanRouter>() - both will return the same instance
///
///
/// Example of use:
///
/// return MaterialApp(
///       title: 'Flutter Demo',
///       theme: ThemeData(
///         primarySwatch: Colors.blue,
///         visualDensity: VisualDensity.adaptivePlatformDensity,
///       ),
///       // home: MyHomePage(title: 'Flutter Demo Home Page'),
///       initialRoute: '/',
///       onGenerateRoute: router.generateRoute,
///     );
///
/// Pages are defined by [Script].
///
/// For automatically generated routes (those from the [Script.pages] collection)
/// follow certain conventions and the developer should ensure that
/// any routes they define do not conflict with these:
///
/// A page displaying a single document has a route of:
///
/// document/{document class}/{objectId}
///
/// For example: document/Person/xx001s76c
///
/// The page may also contain [PanelWidget]s which connect to other documents, so to the user,
/// there may be more than one document actually presented.
///
///
/// A page displaying a list of documents has a route of:
///
/// documents/{document class}/{filterId}
///
/// For example: documents/Person/adult
///
/// where the filterId is defined within [PPage]
///
///
/// Static pages define their own routes, which can be any valid String, as long
/// as it does not be being with 'document' or 'documents'
///
///
///
/// TODO: There needs to be something similar for the use of cloud functions to return a single document or list of documents
/// TODO: Filtered lists could generate cloud code
///
class TakkanRouter {
  String? _preSignInRoute;
  final PageBuilder pageBuilder;

  String? get preSignInRoute => _preSignInRoute;

  late List<RouteGenerator> _routersBefore;
  late List<RouteGenerator> _routersAfter;

  TakkanRouter() : pageBuilder = inject<PageBuilder>();

  init({
    required List<RouteGenerator> routersBefore,
    required List<RouteGenerator> routersAfter,
  }) {
    _routersBefore = routersBefore;
    _routersAfter = routersAfter;
  }

  /// Ultimately this will return a [Route] if a route matching [settings.name]
  /// is found, or an error page [Route] if no match is found.
  ///
  /// Multiple routers are supported, and can be accessed before and after this
  /// router.  This is to allow Takkan to co-exist with other methods of
  /// generating pages
  ///
  /// Using [settings.name] as the route, routers from [_routersBefore] are
  /// checked for a match first, in the order in which they are declared.
  /// If no valid route is found (null is returned), this router is checked.
  /// If no valid route is found, [_routersAfter] is checked in the order declared.
  /// If there is still no match then [_routeNotRecognised] is called to return
  /// an error route.
  Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
    logType(this.runtimeType).d(
        "Requested route is: ${settings.name} with arguments ${settings.arguments}.");
    final before = _processRoutersBefore(settings, context);
    if (before != null) {
      return before;
    }
    final thisRouter = _processThisRouter(settings, context);
    if (thisRouter != null) {
      return thisRouter;
    }
    final after = _processRoutersAfter(settings, context);
    if (after != null) {
      return after;
    }
    return _routeNotRecognised(settings);
  }

  hasRoute(String path) {
    return script.routes.containsKey(path);
  }

  MaterialPageRoute _routeNotRecognised(RouteSettings settings) {
    final page = TakkanDefaultErrorPage(
        config: TakkanError(
            message:
                "Route '${settings.name}' is not recognised")); // TODO message should come from Takkan
    return MaterialPageRoute(builder: (_) => page);
  }

  /// Passes route to Routers in [_routersBefore], which wil return null if they
  /// do not support the route.
  ///
  Route<dynamic>? _processRoutersBefore(
      RouteSettings settings, BuildContext context) {
    for (RouteGenerator f in _routersBefore) {
      final Route<dynamic>? r = f(settings, context);
      if (r != null) return r;
    }
    return null;
  }

  Route<dynamic>? _processThisRouter(
      RouteSettings settings, BuildContext context) {
    final Map<String, dynamic> pageArguments = (settings.arguments == null)
        ? {}
        : settings.arguments as Map<String, dynamic>;

    ///If we are signing in, we need to know where to go back to after authentication
    if (settings.name == 'signIn') {
      _preSignInRoute = pageArguments['returnRoute'];
    }

    /// Not sure when this happens.  Do we need a better way to handle?
    if (settings.name == null) {
      throw UnsupportedError('anonymous routes not supported');
    }

    return pageBuilder.buildPage(
      pageArguments: pageArguments,
      route: settings.name!,
      script: script,
      cache: takkan.cache,
      parentBinding: NullDataBinding(),
      context: context,
    );
  }

  Route<dynamic>? _processRoutersAfter(
      RouteSettings settings, BuildContext context) {
    for (RouteGenerator f in _routersAfter) {
      final Route<dynamic>? r = f(settings, context);
      if (r != null) return r;
    }
    return null;
  }
}

/// Provides a way to modify the options for the [TakkanRouter].
/// Injected during [TakkanRouter] construction

class TakkanRouterConfig {
  final bool takkanFirst;
  final Function(RouteSettings settings)? alternateRouter;

  const TakkanRouterConfig({this.takkanFirst = true, this.alternateRouter});
}

final TakkanRouter _router = TakkanRouter();

TakkanRouter get router => _router;

typedef RouteGenerator = Function(RouteSettings settings, BuildContext context);
