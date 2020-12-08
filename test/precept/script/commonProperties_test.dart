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
                controlEdit: true,
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

      expect(component.isStatic, true);
      expect(component.backend, isNotNull);
      expect(component.dataSource, isNotNull);

      expect(route.isStatic, true);
      expect(route.backend, isNotNull);
      expect(route.dataSource, isNotNull);

      expect(page.isStatic, true);
      expect(page.backend, isNotNull);
      expect(page.dataSource, isNotNull);
      expect(page.controlEdit, true);

      expect(panel.isStatic, true);
      expect(panel.backend, isNotNull);
      expect(panel.dataSource, isNotNull);
      expect(panel.controlEdit, false);

      expect(part.isStatic, true);
      expect(part.backend, isNotNull);
      expect(part.dataSource, isNotNull);
      expect(part.controlEdit, false);
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

      expect(component.isStatic, isNull);
      expect(component.backend, isNull);
      expect(component.dataSource, isNull);

      expect(route.isStatic, isNull);
      expect(route.backend, isNull);
      expect(route.dataSource, isNull);

      expect(page.isStatic, isNull);
      expect(page.backend, isNull);
      expect(page.dataSource, isNull);
      expect(page.controlEdit, false);

      expect(panel.isStatic, isNull);
      expect(panel.backend, isNull);
      expect(panel.dataSource, isNull);
      expect(panel.controlEdit, false);

      expect(part.isStatic, false);
      expect(part.backend, isNull);
      expect(part.dataSource, isNull);
      expect(part.controlEdit, true);
    });

    test('defaults, except pPart controlEdit==true', () {
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
                      PString(controlEdit: true),
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

      expect(component.isStatic, isNull);
      expect(component.backend, isNull);
      expect(component.dataSource, isNull);

      expect(route.isStatic, isNull);
      expect(route.backend, isNull);
      expect(route.dataSource, isNull);

      expect(page.isStatic, isNull);
      expect(page.backend, isNull);
      expect(page.dataSource, isNull);
      expect(page.controlEdit, false);

      expect(panel.isStatic, isNull);
      expect(panel.backend, isNull);
      expect(panel.dataSource, isNull);
      expect(panel.controlEdit, false);

      expect(part.isStatic, false);
      expect(part.backend, isNull);
      expect(part.dataSource, isNull);
      expect(part.controlEdit, true);
    });
  });

}
