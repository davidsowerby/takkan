import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/app/page/homePage.dart';
import 'package:precept/common/exceptions.dart';
import 'package:precept/common/logger.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/model/precept.dart';

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

  /// Returns all [PreceptRoutes] for this locator.   These are combined with other
  /// instances within the [PreceptRouter] to form a single route map.
  ///
  /// Usually asynchronous to allow loader to retrieve data
  Future<Map<String, PreceptRoute>> routeMap();

  /// Returns all the [PreceptWidget]s declared by the locator.  These are held as a lookup in the
  /// [router]
  Future<Map<EnumClass, PreceptWidget>> sectionDeclarations();
}

/// Maintains a list of [RouteLocator], used to find widgets for routes, and
/// a [PreceptWidget] for a [PreceptSection]
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
  Future<Map<String, PreceptRoute>> routeMap() async {
    Map<String, PreceptRoute> masterMap = Map();
    for (RouteLocator locator in locators) {
      masterMap.addAll(await locator.routeMap());
    }
    return masterMap;
  }

  Future<Map<EnumClass, PreceptWidget>> sectionDeclarations() async {
    Map<EnumClass, PreceptWidget> masterMap = Map();
    for (RouteLocator locator in locators) {
      masterMap.addAll(await locator.sectionDeclarations());
    }
    return masterMap;
  }
}

/// This singleton is accessible via [router], and needs to be declared for your
/// [MaterialApp.router]
///
/// It builds a Precept route map, [_preceptRoutes], from all the registered [RouteLocator]s, via
/// [RouteLocatorSet]
///
/// Example:
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
  static PreceptRouter _instance;
  final RouteLocatorSet _locatorSet;
  final Map<String, PreceptRoute> _preceptRoutes = Map();
  final Map<EnumClass, PreceptWidget> _sections = Map();

  PreceptRouter._private() : _locatorSet = inject<RouteLocatorSet>();

  Route<dynamic> generateRoute(RouteSettings settings) {
    getLogger(this.runtimeType).d(
        "Requested route is: ${settings.name} with arguments ${settings.arguments}.");
    PreceptRoute preceptRoute = _preceptRoutes[settings.name];
    if (preceptRoute == null) {
      // TODO: Should do we catch the unrecognised route here or somewhere else?
      throw ConfigurationException("Unknown route ${settings.name}");
    }
    return _route(MyHomePage());
  }

  static PreceptRouter get instance {
    _instance ??= PreceptRouter._private();
    return _instance;
  }

  /// Loads all [PreceptRoutes] into [routeMap], mapped by route path, and all section declarations into _sections.
  /// This is a bit of a sledgehammer approach, see [open issue](https://gitlab.com/precept1/precept-client/-/issues/2).
  buildLookups() async {
    _preceptRoutes.addAll(await _locatorSet.routeMap());

    _sections.addAll(await _locatorSet.sectionDeclarations());
  }

  Route<dynamic> _route(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  hasRoute(String path) {
    return _preceptRoutes.containsKey(path);
  }

  hasSection(EnumClass key) {
    return _sections.containsKey(key);
  }

  PreceptWidget section(PreceptSection sectionLookup) {
    return _sections[sectionLookup.sectionKey];
  }
}

/// Provides a way to modify the options for the [PreceptRouter].
/// Injected during [PreceptRouter] construction
class PreceptRouterConfig {
  final bool preceptFirst;
  final Function(RouteSettings settings) alternateRouter;

  const PreceptRouterConfig({this.preceptFirst = true, this.alternateRouter});
}

PreceptRouter _router = PreceptRouter.instance;

PreceptRouter get router => _router;

class PreceptRouteLocator implements RouteLocator {
  bool _initialised = false;
  final PreceptLoader loader;
  Precept _model;

  PreceptRouteLocator({@required this.loader});

  @override
  Future<Map<String, PreceptRoute>> routeMap() async {
    _model = await loader.load();
    Map<String, PreceptRoute> map = Map();
    for (PreceptComponent component in _model.components) {
      for (PreceptRoute preceptRoute in component.routes) {
        map[preceptRoute.path] = preceptRoute;
      }
    }
    return map;
  }

  @override
  Future<Map<EnumClass, PreceptWidget>> sectionDeclarations() async {
    _model = await loader.load();
    Map<EnumClass, PreceptWidget> map = Map();
    for (PreceptComponent component in _model.components) {
      map.addAll(component.sections.asMap());
    }
    return map;
  }

  // Route generateRoute(RouteSettings settings) {
  //   if (!_initialised) {
  //     throw PreceptException(
  //         "RouteLocator must be initialised before requesting a route");
  //   }
  //   switch (settings.name) {
  //     case "/":
  //       return _route(MyHomePage(
  //         title: "Wiggly",
  //       ));
  //     // default:
  //     //   PreceptRoute route = _model.routeFromPath(path: settings.name);
  //     //   return _route(assembler.assemblePage(route: route));
  //   }
  // }

  Route<dynamic> _route(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  @override
  init() async {
    if (!_initialised) {
      _model = await loader.load();
      _initialised = true;
    }
  }

  @override
  bool get isInitialised => _initialised;
}
