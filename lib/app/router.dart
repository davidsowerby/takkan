import 'package:flutter/material.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/page/error_page.dart';
import 'package:precept_client/page/standard_page.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/error.dart';
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
  String? _preSignInRoute;

  String? get preSignInRoute=> _preSignInRoute;

  PreceptRouter();

  Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
    logType(this.runtimeType).d(
        "Requested route is: ${settings.name} with arguments ${settings.arguments}.");

    final Map<String, dynamic> pageArguments = (settings.arguments == null)
        ? {}
        : settings.arguments as Map<String, dynamic>;
    if (settings.name == 'signIn') {
      _preSignInRoute = pageArguments['returnRoute'];
    }
    final PPage? preceptPage = script.routes[settings.name];
    if (preceptPage == null) {
      return _routeNotRecognised(settings);
    }
    return _route(context, preceptPage, pageArguments);
  }

  /// Returns the Widget representing the page type specified by [PRoute.page], configured with [page.page]
  /// If [PageBuilder] throws an exception - perhaps because there is no matching key in the [PageLibrary], an error page is returned.
  ///
  /// If a page requires the user to be authenticated, and that has not yet happened, redirects to
  /// the [SignIn] page, which is defined through GetIt injection
  Route<dynamic> _route(BuildContext context, PPage page, Map<String, dynamic> pageArguments) {
    try {
      final pageWidget = PreceptPage(
        config: page,
        pageArguments: pageArguments,
      );
      return MaterialPageRoute(
          settings: RouteSettings(
            name: page.route,
            arguments: pageArguments,
          ),
          builder: (_) => pageWidget);
    } catch (e) {
      final errorPageWidget = PreceptDefaultErrorPage(
        config: PError(
            message:
                "Page '${page.pageType}' has not been defined in the PageLibrary, but was requested by route: '${page.route}'"),
      ); // TODO message should come from Precept
      return MaterialPageRoute(
          settings: RouteSettings(
            name: page.route,
            arguments: pageArguments,
          ),
          builder: (_) => errorPageWidget);
    }
  }

  hasRoute(String path) {
    return script.routes.containsKey(path);
  }

  MaterialPageRoute _routeNotRecognised(RouteSettings settings) {
    final page = PreceptDefaultErrorPage(
        config: PError(
            message:
                "Route '${settings.name}' is not recognised")); // TODO message should come from Precept
    return MaterialPageRoute(builder: (_) => page);
  }
}

/// Provides a way to modify the options for the [PreceptRouter].
/// Injected during [PreceptRouter] construction

class PreceptRouterConfig {
  final bool preceptFirst;
  final Function(RouteSettings settings)? alternateRouter;

  const PreceptRouterConfig({this.preceptFirst = true, this.alternateRouter});
}

final PreceptRouter _router = PreceptRouter();

PreceptRouter get router => _router;
