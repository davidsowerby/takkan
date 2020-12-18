import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/part/pPart.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/query.dart';
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
      final script =
      // ignore: missing_required_param
          PScript(name:'test',backend: PBackend(), isStatic: IsStatic.yes, dataSource: PDataSource(), components: [
            // ignore: missing_required_param
        PComponent(
          routes: [
            PRoute(
              path: null,
              // ignore: missing_required_param
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
            )
          ],
        )
      ]);
      // when
      script.init();
      // then
      final component = script.components[0];
      final route = component.routes[0];
      final page = route.page;
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;

      expect(component.isStatic, IsStatic.yes);
      expect(component.backend, isNotNull);
      expect(component.dataSource, isNotNull);

      expect(route.isStatic, IsStatic.yes);
      expect(route.backend, isNotNull);
      expect(route.dataSource, isNotNull);

      expect(page.isStatic, IsStatic.yes);
      expect(page.backend, isNotNull);
      expect(page.dataSource, isNotNull);
      expect(page.controlEdit, ControlEdit.thisAndBelow);

      expect(panel.isStatic, IsStatic.yes);
      expect(panel.backend, isNotNull);
      expect(panel.dataSource, isNotNull);
      expect(panel.controlEdit, ControlEdit.noEdit);

      expect(part.isStatic, IsStatic.yes);
      expect(part.backend, isNotNull);
      expect(part.dataSource, isNotNull);
      expect(part.controlEdit, ControlEdit.notSetAtThisLevel);
    });

    test('defaults, unset', () {
      // given
      final script =
      PScript(name:'test',  components: [
        // ignore: missing_required_param
        PComponent(
          routes: [
            PRoute(
              path: null,
              // ignore: missing_required_param
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
          ],
        )
      ]);
      // when

      script.init();
      // then
      final component = script.components[0];
      final route = component.routes[0];
      final page = route.page;
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;

      expect(component.isStatic, IsStatic.inherited);
      expect(component.backend, isNull);
      expect(component.dataSource, isNull);

      expect(route.isStatic, IsStatic.inherited);
      expect(route.backend, isNull);
      expect(route.dataSource, isNull);

      expect(page.isStatic, IsStatic.inherited);
      expect(page.backend, isNull);
      expect(page.dataSource, isNull);
      expect(page.controlEdit, ControlEdit.notSetAtThisLevel);

      expect(panel.isStatic, IsStatic.inherited);
      expect(panel.backend, isNull);
      expect(panel.dataSource, isNull);
      expect(panel.controlEdit, ControlEdit.notSetAtThisLevel);

      expect(part.isStatic, IsStatic.inherited);
      expect(part.backend, isNull);
      expect(part.dataSource, isNull);
      expect(part.controlEdit, ControlEdit.notSetAtThisLevel);
    });


  });

}
