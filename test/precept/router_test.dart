import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/router.dart';
import 'package:precept_script/script/script.dart';
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
      final script = PScript(
        components: {
          'core': PComponent(
            routes: {'/home': PRoute()},
          ),
        },
      );
      script.init();
      await router.init(
        scripts: [script],
      );
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
