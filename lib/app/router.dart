import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/page/errorPage.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_client/user/signInFactory.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/error.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/signin/signIn.dart';

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
  String _preSignInRoute;

  PreceptRouter();

  Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
    logType(this.runtimeType)
        .d("Requested route is: ${settings.name} with arguments ${settings.arguments}.");
    final Map<String, dynamic> pageArguments = settings.arguments ?? {};
    if (settings.name == 'signIn') {
      _preSignInRoute = pageArguments['returnRoute'];
      final PSignInOptions options = pageArguments['signInConfig'];
      final DataProvider dataProvider = pageArguments['dataProvider'];
      final SignInFactory pageFactory = inject<SignInFactory>();
      final pageWidget = pageFactory.signInPage(
        options: options,
        pageArguments: pageArguments,
        dataProvider: dataProvider,
      );
      return MaterialPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => pageWidget);
    }
    if (settings.name == 'emailSignIn') {
      final factory = inject<EmailSignInFactory>();
      final DataProvider dataProvider = pageArguments['dataProvider'];
      final pageWidget = factory.emailSignInPage(
        successRoute: _preSignInRoute,
        failureRoute: 'tbd',
        pageArguments: pageArguments,
        dataProvider: dataProvider,
      );
      return MaterialPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => pageWidget);
    }
    final PPage preceptPage = script.pages[settings.name];
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
    return script.pages.containsKey(path);
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
