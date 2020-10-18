import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/app/page/homePage.dart';
import 'package:precept/common/logger.dart';
import 'package:precept/inject/inject.dart';

/// A [RouteLocator] implementation returns a widget for [settings.name], or null
/// if it does not recognise the route.
abstract class RouteLocator {
  Route<dynamic> generateRoute(RouteSettings settings);
}

/// Maintains a list of [RouteLocator], used to find a Widget to match a route.
/// [locators] are queried in the order supplied.
///
/// An entry for [RouteLocatorSet] must be made in [getIt], usually as part of the
/// [setupInjector] call.  The [locators] are specified as part of the [getIt] declaration,
/// for example:
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
}
