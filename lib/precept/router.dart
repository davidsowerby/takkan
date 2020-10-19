import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/app/page/homePage.dart';
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

  /// Retrieves a [Route] for [settings.name], or null if no such route defined.
  Route<dynamic> generateRoute(RouteSettings settings);
}

/// Maintains a list of [RouteLocator], used to find a Widget to match a route.
/// [locators] are queried in the order supplied.
///
/// An entry for [RouteLocatorSet] must be made in [getIt], as part of the
/// [setupInjector] call, either directly or indirectly.
///
/// The [locators] are specified as part of the [getIt] declaration, for example:
///
/// getIt.registerFactory<RouteLocatorSet>(() => RouteLocatorSet(locators:[PreceptRouteLocator()]));
class RouteLocatorSet {
  final List<RouteLocator> locators;

  const RouteLocatorSet({@required this.locators});

  /// Returns a widget from the first [RouteLocator] in [locators] which recognises
  /// [settings.name]
  Route<dynamic> generateRoute(RouteSettings settings) {
    for (RouteLocator locator in locators) {
      Route<dynamic> route = locator.generateRoute(settings);
      if (route != null) {
        return route;
      }
    }
    return null;
  }
}

/// This singleton is accessible via [router], and needs to be declared for your
/// [MaterialApp.router]
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
  RouteLocatorSet _locatorSet;

  PreceptRouter._private() : _locatorSet = inject<RouteLocatorSet>();

  Route<dynamic> generateRoute(RouteSettings settings) {
    getLogger(this.runtimeType).d(
        "Requested route is: ${settings.name} with arguments ${settings.arguments}.");
    Route<dynamic> route = _locatorSet.generateRoute(settings);
    return route; // TODO do we catch the unrecognised route here or somewhere else?
  }

  static PreceptRouter get instance {
    _instance ??= PreceptRouter._private();
    return _instance;
  }
}

PreceptRouter _router = PreceptRouter.instance;

PreceptRouter get router => _router;

class PreceptRouteLocator implements RouteLocator {
  bool _initialised = false;
  bool _loaded = false;
  final PreceptLoader loader;

  PreceptRouteLocator({@required this.loader});

  @override
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return _route(MyHomePage(
          title: "Wiggly",
        ));
      default:
        return null;
    }
  }

  Route<dynamic> _route(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  @override
  init() {
    if (!_initialised) {
      _initialised = true;
    }
  }

  @override
  bool get isInitialised => _initialised;
}
