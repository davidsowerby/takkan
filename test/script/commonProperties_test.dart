import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/configLoader.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/script.dart';
import 'package:flutter_test/flutter_test.dart';

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
        schema: schema,
        dataProvider: PRestDataProvider(),
        isStatic: IsStatic.yes,
        dataSource: PGet(),
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
      expect(route.dataSource, isNotNull);
      expect(route.schema, schema);

      expect(page.isStatic, IsStatic.yes);
      expect(page.dataProvider, isNotNull);
      expect(page.dataSource, isNotNull);
      expect(page.controlEdit, ControlEdit.thisAndBelow);
      expect(page.schema, schema);
      expect(page.dataSourceIsDeclared, true);
      expect(page.backendIsDeclared, true);

      expect(panel.isStatic, IsStatic.yes);
      expect(panel.dataProvider, isNotNull);
      expect(panel.dataSource, isNotNull);
      expect(panel.controlEdit, ControlEdit.noEdit);
      expect(panel.schema, schema);
      expect(panel.dataSourceIsDeclared, false);
      expect(panel.backendIsDeclared, false);

      expect(part.isStatic, IsStatic.yes);
      expect(part.dataProvider, isNotNull);
      expect(part.dataSource, isNotNull);
      expect(part.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(part.schema, schema);
      expect(part.dataSourceIsDeclared, false);
      expect(part.backendIsDeclared, false);
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
      expect(route.dataSource, isNull);

      expect(page.isStatic, IsStatic.inherited);
      expect(page.dataProvider, isNull);
      expect(page.dataSource, isNull);
      expect(page.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(page.dataSourceIsDeclared, false);
      expect(page.backendIsDeclared, false);

      expect(panel.isStatic, IsStatic.inherited);
      expect(panel.dataProvider, isNull);
      expect(panel.dataSource, isNull);
      expect(panel.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(panel.dataSourceIsDeclared, false);
      expect(panel.backendIsDeclared, false);

      expect(part.isStatic, IsStatic.inherited);
      expect(part.dataProvider, isNull);
      expect(part.dataSource, isNull);
      expect(part.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(part.dataSourceIsDeclared, false);
      expect(part.backendIsDeclared, false);
    });
  });
}
