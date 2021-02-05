import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/app/router.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/script.dart';

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
        routes: {'/home': PRoute()},
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
