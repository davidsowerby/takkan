import 'package:precept/app/data/kitchenSink.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/loader.dart';
import 'package:precept/precept/router.dart';
import 'package:test/test.dart';


void main() {
  group('Precept Router', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('builds route map on init', () async {
      // given
      setupInjector(buildInjector);
      // when
      await router.init();
      // then
      expect(router.hasRoute("/home"), isTrue);
      // expect(router.hasSection(CorePart.address), isTrue);
    });
  });
}

buildInjector() {
  getIt.registerFactory<PreceptRouterConfig>(() => PreceptRouterConfig());
  getIt.registerFactory<RouteLocatorSet>(() => RouteLocatorSet(locators: [
        PreceptRouteLocator(loader: DirectPreceptLoader(model: kitchenSinkModel))
      ]));
}
