import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/common/page/signInPage.dart';
import 'package:precept_client/page/errorPage.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_client/user/userState.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/inject/inject.dart';
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
  PRoute _preSignInRoute;

  PreceptRouter();

  Route<dynamic> generateRoute(RouteSettings settings, UserState userState) {
    logType(this.runtimeType)
        .d("Requested route is: ${settings.name} with arguments ${settings.arguments}.");
    PRoute preceptRoute = script.routes[settings.name];
    if (preceptRoute == null) {
      return _routeNotRecognised(settings);
    }
    return _route(preceptRoute, userState);
  }

  /// Returns the Widget representing the page type specified by [PRoute.page], configured with [route.page]
  /// If [PageBuilder] throws an exception - perhaps because there is no matching key in the [PageLibrary], an error page is returned.
  ///
  /// If a page requires the user to be authenticated, and that has not yet happened, redirects to
  /// the [SignIn] page, which is defined through GetIt injection
  Route<dynamic> _route(PRoute route, UserState userState) {
    final requiresAuth = false;//(route.page.schema == null) ? false : (route.page.schema as PDocument).readRequiresAuth;
    if (requiresAuth && (!userState.isAuthenticated)) {
      _preSignInRoute=route;
      final pageWidget = injectParam<SignInPage>(param1: script.authenticator.signInOptions);
      return MaterialPageRoute(builder: (_) => pageWidget);
    }
    try {
      final pageWidget = PreceptPage(config: route.page);
      return MaterialPageRoute(builder: (_) => pageWidget);
    } catch (e) {
      final errorPageWidget = PreceptDefaultErrorPage(
        config: PError(
            message:
                "Page '${route.page.pageType}' has not been defined in the PageLibrary, but was requested by route: '${route.path}'"),
      ); // TODO message should come from Precept
      return MaterialPageRoute(builder: (_) => errorPageWidget);
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
  final Function(RouteSettings settings) alternateRouter;

  const PreceptRouterConfig({this.preceptFirst = true, this.alternateRouter});
}

PreceptRouter get router => inject<PreceptRouter>();
