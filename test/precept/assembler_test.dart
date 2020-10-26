import 'package:precept/inject/inject.dart';
import 'package:precept/precept/assembler.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:precept/precept/router.dart';
import 'package:precept/precept/section/contact/address.dart';
import 'package:precept/section/base/section.dart';
import 'package:test/test.dart';

import '../data/testModel/testModel.dart';

void main() {
  group('Assemble', () {
    setUpAll(() async {
      setupInjector(buildInjector);
      await router.buildLookups();
    });

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final assembler = PreceptPageAssembler();
      // when
      final output =
          assembler.assembleSections(route: testModel.components[0].routes[0]);
      // then

      expect(output.length, 1);
      expect(output[0], isA<Section>());
      Section section = output[0];
      expect(section.child, isA<AddressWidget>());
    });
  });
}

buildInjector() {
  getIt.registerFactory<PreceptRouterConfig>(() => PreceptRouterConfig());
  getIt.registerFactory<RouteLocatorSet>(() => RouteLocatorSet(locators: [
        PreceptRouteLocator(loader: DirectPreceptLoader(model: testModel))
      ]));
}
