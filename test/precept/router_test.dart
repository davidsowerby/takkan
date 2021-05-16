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

    test('redirects to signIn when auth needed', () async {
      // given
      buildInjector();
      // when
      final script = PScript(
        pages: {'/home': PPage()},
      );
      // then
      expect(0,1);
      // expect(router.hasSection(CorePart.address), isTrue);
    });
  });
}

buildInjector() {
  getIt.registerSingleton<PreceptRouter>(PreceptRouter());
  getIt.registerFactory<PreceptRouterConfig>(() => PreceptRouterConfig());
}
