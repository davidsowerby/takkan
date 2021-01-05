import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';
import 'package:test/test.dart';

void main() {
  group('Common properties', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('correct inherit / overrule', () {
      // given
      final  PSchema schema = PSchema();
      final script = PScript(
        name: 'test',
        schema: schema,
        backend: PBackend(),
        isStatic: IsStatic.yes,
        dataSource: PDataGet(),
        routes: {
          '': PRoute(
            page: PPage(
              controlEdit: ControlEdit.thisAndBelow,
              content: [
                PPanel(
                  controlEdit: ControlEdit.noEdit,
                  content: [
                    PString(),
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
      expect(route.backend, isNotNull);
      expect(route.dataSource, isNotNull);
      expect(route.schema, schema);

      expect(page.isStatic, IsStatic.yes);
      expect(page.backend, isNotNull);
      expect(page.dataSource, isNotNull);
      expect(page.controlEdit, ControlEdit.thisAndBelow);
      expect(page.schema, schema);
      expect(page.dataSourceIsDeclared, true);
      expect(page.backendIsDeclared, true);

      expect(panel.isStatic, IsStatic.yes);
      expect(panel.backend, isNotNull);
      expect(panel.dataSource, isNotNull);
      expect(panel.controlEdit, ControlEdit.noEdit);
      expect(panel.schema, schema);
      expect(panel.dataSourceIsDeclared, false);
      expect(panel.backendIsDeclared, false);

      expect(part.isStatic, IsStatic.yes);
      expect(part.backend, isNotNull);
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
                      PString(),
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
      expect(route.backend, isNull);
      expect(route.dataSource, isNull);

      expect(page.isStatic, IsStatic.inherited);
      expect(page.backend, isNull);
      expect(page.dataSource, isNull);
      expect(page.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(page.dataSourceIsDeclared, false);
      expect(page.backendIsDeclared, false);

      expect(panel.isStatic, IsStatic.inherited);
      expect(panel.backend, isNull);
      expect(panel.dataSource, isNull);
      expect(panel.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(panel.dataSourceIsDeclared, false);
      expect(panel.backendIsDeclared, false);

      expect(part.isStatic, IsStatic.inherited);
      expect(part.backend, isNull);
      expect(part.dataSource, isNull);
      expect(part.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(part.dataSourceIsDeclared, false);
      expect(part.backendIsDeclared, false);
    });
  });
}
