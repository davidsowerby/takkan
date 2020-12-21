import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/script.dart';
import 'package:test/test.dart';

void main() {
  group('PScript all level validation', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    group('PScript validation', () {
      test('Insufficient components', () {
        // given
        final script1 = PScript();
        // when
        final result = script1.validate();
        // then

        expect(result.length, 1);
        expect(result[0].toString(),
            'PScript : Script:0 : must contain at least one component');
      });
    });

    group('PComponent validation', () {
      test('routes and name not null', () {
        // given
        final component = PScript(name: 'test', components: [PComponent()]);// ignore: missing_required_param
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PComponent : test.Component:0 : PComponent at index 0 must have a name defined');
        expect(messages[1].toString(),
            'PComponent : test.Component:0 : PComponent at index 0 must contain at least one PRoute');
      });

      test('routes and name must not be not empty', () {
        // given
        final component = PScript(components: [PComponent(name: '')]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PComponent : Script:0.Component:0 : PComponent at index 0 must have a name defined');
        expect(messages[1].toString(),
            "PComponent : Script:0.Component:0 : PComponent at index 0 must contain at least one PRoute");
      });
    });

    group('PRoute validation', () {
      test('Must have path and page', () {
        // given
        final component = PScript(components: [
          PComponent(name: 'core', routes: [PRoute()])// ignore: missing_required_param
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PRoute : Script:0.core.Route:0 : must define a path');
        expect(messages[1].toString(),
            'PRoute : Script:0.core.Route:0 : must define a page');
      });
    });

    group('PPage validation', () {
      test('Must have pageType and title', () {
        // given
        final component = PScript(isStatic: IsStatic.yes, components: [
          PComponent(name: 'core', routes: [PRoute(path: "/home", page: PPage(pageType: null))])// ignore: missing_required_param
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(), 'PPage : Script:0.core./home.Page:0 : must define a title');
        expect(
            messages[1].toString(), 'PPage : Script:0.core./home.Page:0 : must define a pageType');
      });

      test('No errors', () {
        // given
        final component = PScript(backend: PBackend(backendType: 'mock', connection:const {'instanceKey':'test'}), components: [// ignore: missing_required_param
          PComponent(name: 'core', routes: [
            PRoute(
                path: "/home",
                page: PPage(
                    pageType: "mine", title: "Wiggly", dataSource: PDataGet(documentId: DocumentId())))// ignore: missing_required_param
          ])
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 0);
      });
    });

    group('PPanel validation', () {
      test('No errors', () {
        // given
        final component = PScript(backend: PBackend(backendType: 'mock', connection: const {'instanceKey':'test'}),components: [// ignore: missing_required_param
          PComponent(name: 'core', routes: [
            PRoute(
              path: "/home",
              page: PPage(
                pageType: "mine",
                title: "Wiggly",
                dataSource: PDataGet(// ignore: missing_required_param
                  documentId: DocumentId(),// ignore: missing_required_param
                ),
                content: [PPanel()],
              ),
            )
          ])
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 0);
      });

      test('any non-static PPanel must be able to access DataSource', () {
        // given
        final withoutDataSourceOrBackend = PScript(
          components: [
            PComponent(backend: PBackend(backendType: 'mock', connection: const {'instanceKey':'test'}),
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",content: [PPanel(caption: 'panel1')],
                  ),
                ),
              ],
            )
          ],
        );


        final withoutDataSource = PScript(
          backend: PBackend(backendType: 'mock', connection: const {'instanceKey':'test'}),
          components: [
            PComponent(
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",
                    content: [PPanel(caption: 'panel1')],),
                )
              ],
            )
          ],
        );

        final withDataSourceAndBackend = PScript(
          backend: PBackend(backendType: 'mock',connection: const {'instanceKey':'test'}), // ignore: missing_required_param
          components: [
            PComponent(
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",
                    dataSource: PDataGet( // ignore: missing_required_param
                      documentId: DocumentId(), // ignore: missing_required_param
                    ),content: [PPanel(caption: 'panel1')],
                  ),
                )
              ],
            )
          ],
        );

        // when
        final withoutDataSourceOrBackendResults = withoutDataSourceOrBackend.validate();
        final withoutDataSourceResults = withoutDataSource.validate();
        final withDataSourceAndBackendResults = withDataSourceAndBackend.validate();
        // then

        expect(withoutDataSourceOrBackendResults.length, 1);
        expect(withoutDataSourceOrBackendResults[0].toString(), 'PPanel : Script:0.core./home.Wiggly.panel1 : must either be static or have a dataSource defined');
        expect(withoutDataSourceResults.length, 1);
        expect(withoutDataSourceResults[0].toString(), 'PPanel : Script:0.core./home.Wiggly.panel1 : must either be static or have a dataSource defined');
        expect(withDataSourceAndBackendResults.length, 0);
      });
    });
  });
}
