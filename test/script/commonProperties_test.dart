import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/configLoader.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/script.dart';

import '../fixtures.dart';

void main() {
  group('Common properties', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<ConfigLoader>(() => MockConfigLoader());
    });

    tearDown(() {});

    test('correct inherit / overrule', ()
    {
      // given
      final  PSchema schema = PSchema();
      final script = PScript(
        name: 'test',
        dataProvider: PRestDataProvider(),
        isStatic: IsStatic.yes,
        query: PGet(),
        routes: {
          '': PRoute(
            page: PPage(
              controlEdit: ControlEdit.thisAndBelow,
              content: [
                PPanel(
                  controlEdit: ControlEdit.noEdit,
                  content: [
                    PPart(),
                  ],
                ),
              ],
            ),
          ),
        },
      );
      // when
       script.init();
      // then
      final route = script.routes[''];
      final page = route.page;
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;

      expect(route.isStatic, IsStatic.yes);
      expect(route.dataProvider, isNotNull);
      expect(route.query, isNotNull);

      expect(page.isStatic, IsStatic.yes);
      expect(page.dataProvider, isNotNull);
      expect(page.query, isNotNull);
      expect(page.controlEdit, ControlEdit.thisAndBelow);
      expect(page.queryIsDeclared, true);
      expect(page.dataProviderIsDeclared, true);

      expect(panel.isStatic, IsStatic.yes);
      expect(panel.dataProvider, isNotNull);
      expect(panel.query, isNotNull);
      expect(panel.controlEdit, ControlEdit.noEdit);
      expect(panel.queryIsDeclared, false);
      expect(panel.dataProviderIsDeclared, false);

      expect(part.isStatic, IsStatic.yes);
      expect(part.dataProvider, isNotNull);
      expect(part.query, isNotNull);
      expect(part.controlEdit, ControlEdit.inherited);
      expect(part.queryIsDeclared, false);
      expect(part.dataProviderIsDeclared, false);
    });

    test('defaults, unset', () {
      // given
      final script = PScript(name: 'test',
          routes: {
            '/test': PRoute(
              page: PPage(
                content: [
                  PPanel(
                    content: [
                  PPart(),
                ],
                  ),
                ],
              ),
            )
      });
      // when

      script.init();
      // then
      final route = script.routes['/test'];
      final page = route.page;
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;

      expect(route.isStatic, IsStatic.inherited);
      expect(route.dataProvider, isNull);
      expect(route.query, isNull);

      expect(page.isStatic, IsStatic.inherited);
      expect(page.dataProvider, isNull);
      expect(page.query, isNull);
      expect(page.controlEdit, ControlEdit.inherited);
      expect(page.queryIsDeclared, false);
      expect(page.dataProviderIsDeclared, false);

      expect(panel.isStatic, IsStatic.inherited);
      expect(panel.dataProvider, isNull);
      expect(panel.query, isNull);
      expect(panel.controlEdit, ControlEdit.inherited);
      expect(panel.queryIsDeclared, false);
      expect(panel.dataProviderIsDeclared, false);

      expect(part.isStatic, IsStatic.inherited);
      expect(part.dataProvider, isNull);
      expect(part.query, isNull);
      expect(part.controlEdit, ControlEdit.inherited);
      expect(part.queryIsDeclared, false);
      expect(part.dataProviderIsDeclared, false);
    });
  });
}
