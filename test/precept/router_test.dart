import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/router.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:test/test.dart';


void main() {
  group('Precept Router', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('builds route map on init', () async {
      // given
      buildInjector();
      // when
      await router.init(scripts: [PScript(components: [PComponent(routes: [PRoute(path: '/home')],)],),]);
      // then
      expect(router.hasRoute('/home'), isTrue);
      // expect(router.hasSection(CorePart.address), isTrue);
    });
  });
}

buildInjector() {
  getIt.registerSingleton<PreceptRouter>(PreceptRouter());
  getIt.registerFactory<PreceptRouterConfig>(() => PreceptRouterConfig());

}
