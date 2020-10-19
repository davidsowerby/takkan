import 'package:precept/app/model.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:precept/precept/router.dart';

appInjection() {}

locatorInjection() {
  getIt.registerFactory<RouteLocatorSet>(() => RouteLocatorSet(locators: [
        PreceptRouteLocator(loader: DirectPreceptLoader(model: testModel()))
      ]));
}
