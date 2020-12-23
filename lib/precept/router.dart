import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/library/pageLibrary.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/logger.dart';
import 'package:precept_script/script/error.dart';
import 'package:precept_script/script/script.dart';


/// Router for Precept.
///
/// This class should be used as a singleton. It is accessible either via [router],
/// or by invoking inject<PreceptRouter>() - both will return the same instance
///
///
/// Example of use:
///
/// return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       // home: MyHomePage(title: 'Flutter Demo Home Page'),
//       initialRoute: '/',
//       onGenerateRoute: router.generateRoute,
//     );
///
class PreceptRouter {
  final Map<String, PRoute> _preceptRoutes = Map();
  bool _indexed = false;

  PreceptRouter();

  Route<dynamic> generateRoute(RouteSettings settings) {
    if (!_indexed) {
      final msg = "PreceptRouter: must invoke 'init()' before calling 'generateRoute'";
      logType(this.runtimeType).d(msg);
      throw PreceptException(msg);
    }
    logType(this.runtimeType)
        .d("Requested route is: ${settings.name} with arguments ${settings.arguments}.");
    PRoute preceptRoute = _preceptRoutes[settings.name];
    if (preceptRoute == null) {
      return _routeNotRecognised(settings);
    }
    return _route(preceptRoute);
  }

  /// Indexes all [PRoutes] into [_preceptRoutes], mapped by route path
  /// This is a bit of a sledgehammer approach, see [open issue](https://gitlab.com/precept1/precept-client/-/issues/2).
  init({@required List<PScript> scripts}) {
    for (PScript script in scripts) {
      for (PComponent component in script.components.values) {
        for (PRoute r in component.routes.values) {
          _preceptRoutes[r.path] = r;
        }
      }
    }
    _indexed = true;
  }

  bool get ready => _indexed;

  /// Returns the Widget representing page [route.page.pageType], configured with [route.page]
  /// If [PageBuilder] throws an exception - perhaps because there is no matching key in the [PageLibrary], an error page is returned.
  Route<dynamic> _route(PRoute route) {
    try {
      final pageWidget = PageBuilder().build(config: route.page);
      return MaterialPageRoute(builder: (_) => pageWidget);
    } catch (e) {
      final errorPageWidget = pageLibrary.errorPage(PError(message: "Page '${route.page
          .pageType}' has not been defined in the PageLibrary, but was requested by route: '${route
          .path}'"),); // TODO message should come from Precept
      return MaterialPageRoute(builder: (_) => errorPageWidget);
    }



  }

  hasRoute(String path) {
    return _preceptRoutes.containsKey(path);
  }

  MaterialPageRoute _routeNotRecognised(RouteSettings settings) {
    final page = pageLibrary.errorPage(PError(
        message:
        "Route '${settings.name}' is not recognised")); // TODO message should come from Precept
    return MaterialPageRoute(builder: (_) => page);
  }
}

/// Provides a way to modify the options for the [PreceptRouter].
/// Injected during [PreceptRouter] construction
class PreceptRouterConfig {
  final bool preceptFirst;
  final Function(RouteSettings settings) alternateRouter;

  const PreceptRouterConfig({this.preceptFirst = true, this.alternateRouter});
}

PreceptRouter get router => inject<PreceptRouter>();

