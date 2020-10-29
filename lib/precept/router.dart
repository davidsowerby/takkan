import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/app/page/errorPage.dart';
import 'package:precept/app/page/standardPage.dart';
import 'package:precept/common/logger.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/assembler.dart';
import 'package:precept/precept/loader.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/pPart.dart';

/// A [RouteLocator] implementation returns a widget for [settings.name], or null
/// if it does not recognise the route.
abstract class RouteLocator {
  /// See [init]
  bool get isInitialised;

  /// Most sources require authentication or other form of preparation.  This method
  /// is invoked only when a [RouteLocator] instance is first queried for a route.
  ///
  /// Implementations should ignore this call if [isInitialised] is true, unless there is some
  /// reason not to do so.
  init();

  /// Returns all [PRoute]s declared by this locator.   These are combined with other
  /// instances within the [PreceptRouter] to form a single route map.
  ///
  /// Usually asynchronous to allow loader to retrieve data
  Future<Map<String, PRoute>> routeMap();

  /// Returns all the [PPart]s declared by the locator.  These are held as a lookup in the
  /// [router]
  Future<Map<String, PPart>> sectionDeclarations();
}

/// Maintains a list of [RouteLocator], used to find widgets for routes, and
/// a [PreceptPart] for a [PreceptSection]
///
/// [locators] are queried in the order supplied.
///
/// An entry for [RouteLocatorSet] must be made in [getIt], as part of the
/// [setupInjector] call, either directly or indirectly.
///
/// The [locators] are specified as part of the [getIt] declaration, for example:
///
/// getIt.registerFactory<RouteLocatorSet>(() => RouteLocatorSet(locators:[PreceptRouteLocator()]));
///
class RouteLocatorSet {
  final List<RouteLocator> locators;

  const RouteLocatorSet({@required this.locators});

  /// Returns a widget from the first [RouteLocator] in [locators] which recognises
  /// [settings.name]
  Future<Map<String, PRoute>> routeMap() async {
    Map<String, PRoute> masterMap = Map();
    for (RouteLocator locator in locators) {
      masterMap.addAll(await locator.routeMap());
    }
    return masterMap;
  }

  Future<Map<String, PPart>> sectionDeclarations() async {
    Map<String, PPart> masterMap = Map();
    for (RouteLocator locator in locators) {
      masterMap.addAll(await locator.sectionDeclarations());
    }
    return masterMap;
  }
}

/// This class should be used as a singleton. It is accessible either via [router],
/// or by invoking inject<PreceptRouter>() - both will return the same instance
///
/// It builds a Precept route map, [_preceptRoutes], from all the registered [RouteLocator]s, via
/// [RouteLocatorSet]
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
  final PreceptPageAssembler assembler = PreceptPageAssembler();

  PreceptRouter();

  Route<dynamic> generateRoute(RouteSettings settings) {
    getLogger(this.runtimeType).d(
        "Requested route is: ${settings.name} with arguments ${settings.arguments}.");
    PRoute preceptRoute = _preceptRoutes[settings.name];
    if (preceptRoute == null) {
      return _route(ErrorPage(
          message: "Requested route: '${settings.name}' not recognised"));
    }
    return _route(StandardPage(
        sections: assembler.assembleSections(route: preceptRoute)));
  }

  /// Indexes all [PRoutes] into [_preceptRoutes], mapped by route path
  /// This is a bit of a sledgehammer approach, see [open issue](https://gitlab.com/precept1/precept-client/-/issues/2).
  init({@required List<PreceptModel> models}) {
    for (PreceptModel model in models) {
      for (PComponent component in model.components) {
        for (PRoute r in component.routes) {
          _preceptRoutes[r.path] = r;
        }
      }
    }
    _indexed = true;
  }

  bool get ready => _indexed;

  Route<dynamic> _route(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  hasRoute(String path) {
    return _preceptRoutes.containsKey(path);
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

class PreceptRouteLocator implements RouteLocator {
  bool _loaded = false;
  final PreceptLoader loader;
  PreceptModel _model;

  PreceptRouteLocator({@required this.loader});

  @override
  Future<Map<String, PRoute>> routeMap() async {
    _model = await loader.load();
    Map<String, PRoute> map = Map();
    for (PComponent component in _model.components) {
      for (PRoute preceptRoute in component.routes) {
        map[preceptRoute.path] = preceptRoute;
      }
    }
    return map;
  }

  @override
  Future<Map<String, PPart>> sectionDeclarations() async {
    _model = await loader.load();
    Map<String, PPart> map = Map();
    for (PComponent component in _model.components) {
      map.addAll(component.parts);
    }
    return map;
  }

  Route<dynamic> _route(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  @override
  init() async {
    if (!_loaded) {
      _model = await loader.load();
      _loaded = true;
    }
  }

  @override
  bool get isInitialised => _loaded;
}
