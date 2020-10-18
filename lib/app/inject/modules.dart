import 'package:precept/inject/inject.dart';
import 'package:precept/precept/router.dart';

appInjection() {}

locatorInjection() {
  getIt.registerFactory<RouteLocatorSet>(
      () => RouteLocatorSet(locators: [PreceptRouteLocator()]));
}
