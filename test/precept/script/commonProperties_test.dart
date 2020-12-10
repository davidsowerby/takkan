import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:precept_client/precept/script/backend.dart';
import 'package:precept_client/precept/script/data.dart';
import 'package:precept_client/precept/script/script.dart';
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
          PScript(backend: PBackend(), isStatic: Triple.yes, dataSource: PDataSource(), components: [
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

      expect(component.isStatic, Triple.yes);
      expect(component.backend, isNotNull);
      expect(component.dataSource, isNotNull);

      expect(route.isStatic, Triple.yes);
      expect(route.backend, isNotNull);
      expect(route.dataSource, isNotNull);

      expect(page.isStatic, Triple.yes);
      expect(page.backend, isNotNull);
      expect(page.dataSource, isNotNull);
      expect(page.controlEdit, ControlEdit.thisAndBelow);

      expect(panel.isStatic, Triple.yes);
      expect(panel.backend, isNotNull);
      expect(panel.dataSource, isNotNull);
      expect(panel.controlEdit, ControlEdit.noEdit);

      expect(part.isStatic, Triple.yes);
      expect(part.backend, isNotNull);
      expect(part.dataSource, isNotNull);
      expect(part.controlEdit, ControlEdit.notSetAtThisLevel);
    });

    test('defaults, unset', () {
      // given
      final script =
      PScript(  components: [
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

      expect(component.isStatic, Triple.inherited);
      expect(component.backend, isNull);
      expect(component.dataSource, isNull);

      expect(route.isStatic, Triple.inherited);
      expect(route.backend, isNull);
      expect(route.dataSource, isNull);

      expect(page.isStatic, Triple.inherited);
      expect(page.backend, isNull);
      expect(page.dataSource, isNull);
      expect(page.controlEdit, ControlEdit.notSetAtThisLevel);

      expect(panel.isStatic, Triple.inherited);
      expect(panel.backend, isNull);
      expect(panel.dataSource, isNull);
      expect(panel.controlEdit, ControlEdit.notSetAtThisLevel);

      expect(part.isStatic, Triple.inherited);
      expect(part.backend, isNull);
      expect(part.dataSource, isNull);
      expect(part.controlEdit, ControlEdit.notSetAtThisLevel);
    });


  });

}
