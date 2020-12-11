import 'package:precept_client/precept/script/backend.dart';
import 'package:precept_client/precept/script/data.dart';
import 'package:precept_client/precept/script/script.dart';
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
        final script2 = PScript(components: []);
        // when
        final result = script1.validate();
        // then

        expect(result.length, 1);
        expect(result[0].toString(),
            'PScript : script : must contain at least one component');
      });
    });

    group('PComponent validation', () {
      test('routes and name not null', () {
        // given
        final component = PScript(components: [PComponent()]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PComponent : missing id : PComponent at index 0 must have a name defined');
        expect(messages[1].toString(),
            "PComponent : missing id : PComponent at index 0 must contain at least one PRoute");
      });

      test('routes and name must not be not empty', () {
        // given
        final component = PScript(components: [PComponent(name: '')]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PComponent :  : PComponent at index 0 must have a name defined');
        expect(messages[1].toString(),
            "PComponent :  : PComponent at index 0 must contain at least one PRoute");
      });
    });

    group('PRoute validation', () {
      test('Must have path and page', () {
        // given
        final component = PScript(components: [
          PComponent(name: 'core', routes: [PRoute()])
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PRoute : missing id : at index 0 of PComponent core must define a path');
        expect(messages[1].toString(),
            "PRoute : missing id : at index 0 of PComponent core must define a page");
      });
    });

    group('PPage validation', () {
      test('Must have pageType and title', () {
        // given
        final component = PScript(isStatic: Triple.yes, components: [
          PComponent(name: 'core', routes: [PRoute(path: "/home", page: PPage(pageType: null))])
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(), 'PPage : missing id : PPage at route /home must define a title');
        expect(
            messages[1].toString(), 'PPage : missing id : PPage at route /home must define a pageType');
      });

      test('No errors', () {
        // given
        final component = PScript(backend: PBackend(), components: [
          PComponent(name: 'core', routes: [
            PRoute(
                path: "/home",
                page: PPage(
                    pageType: "mine", title: "Wiggly", dataSource: PDataGet(documentId: DocumentId())))
          ])
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 0);
      });

      test('any non-static Page must be able to access DataSource and Backend', () {
        // given
        final withoutDataSourceOrBackend = PScript(
          components: [
            PComponent(
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",
                  ),
                ),
              ],
            )
          ],
        );

        final withoutBackend = PScript(
          components: [
            PComponent(
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",
                    dataSource: PDataGet(
                      documentId: DocumentId(),
                    ),
                  ),
                )
              ],
            )
          ],
        );

        final withoutDataSource = PScript(
          backend: PBackend(),
          components: [
            PComponent(
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",
                  ),
                )
              ],
            )
          ],
        );

        final withDataSourceAndBackend = PScript(
          backend: PBackend(),
          components: [
            PComponent(
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",
                    dataSource: PDataGet(
                      documentId: DocumentId(),
                    ),
                  ),
                )
              ],
            )
          ],
        );

        // when
        final withoutDataSourceOrBackendResults = withoutDataSourceOrBackend.validate();
        final withoutBackendResults = withoutBackend.validate();
        final withoutDataSourceResults = withoutDataSource.validate();
        final withDataSourceAndBackendResults = withDataSourceAndBackend.validate();
        // then

        expect(withoutDataSourceOrBackendResults.length, 2);
        expect(withoutDataSourceOrBackendResults[0].toString(), 'PPage : Wiggly : PPage at route /home must either be static or have a backend defined');
        expect(withoutDataSourceOrBackendResults[1].toString(), 'PPage : Wiggly : PPage at route /home must either be static or have a dataSource defined');
        expect(withoutBackendResults.length, 1);
        expect(withoutBackendResults[0].toString(), 'PPage : Wiggly : PPage at route /home must either be static or have a backend defined');
        expect(withoutDataSourceResults.length, 1);
        expect(withoutDataSourceResults[0].toString(), 'PPage : Wiggly : PPage at route /home must either be static or have a dataSource defined');
        expect(withDataSourceAndBackendResults.length, 0);
      });
    });

    group('PPanel validation', () {
      test('No errors', () {
        // given
        final component = PScript(backend: PBackend(),components: [
          PComponent(name: 'core', routes: [
            PRoute(
              path: "/home",
              page: PPage(
                pageType: "mine",
                title: "Wiggly",
                dataSource: PDataGet(
                  documentId: DocumentId(),
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

      test('any non-static PPanel must be able to access DataSource and Backend', () {
        // given
        final withoutDataSourceOrBackend = PScript(
          components: [
            PComponent(
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

        final withoutBackend = PScript(
          components: [
            PComponent(
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",
                    dataSource: PDataGet(
                      documentId: DocumentId(),
                    ),content: [PPanel(caption: 'panel1')],
                  ),
                )
              ],
            )
          ],
        );

        final withoutDataSource = PScript(
          backend: PBackend(),
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
          backend: PBackend(),
          components: [
            PComponent(
              name: 'core',
              routes: [
                PRoute(
                  path: "/home",
                  page: PPage(
                    pageType: "mine",
                    title: "Wiggly",
                    dataSource: PDataGet(
                      documentId: DocumentId(),
                    ),content: [PPanel(caption: 'panel1')],
                  ),
                )
              ],
            )
          ],
        );

        // when
        final withoutDataSourceOrBackendResults = withoutDataSourceOrBackend.validate();
        final withoutBackendResults = withoutBackend.validate();
        final withoutDataSourceResults = withoutDataSource.validate();
        final withDataSourceAndBackendResults = withDataSourceAndBackend.validate();
        // then

        expect(withoutDataSourceOrBackendResults.length, 4, reason: 'PPage will still fail validation');
        expect(withoutDataSourceOrBackendResults[2].toString(), 'PPanel : panel1 : must either be static or have a backend defined');
        expect(withoutDataSourceOrBackendResults[3].toString(), 'PPanel : panel1 : must either be static or have a dataSource defined');
        expect(withoutBackendResults.length, 2);
        expect(withoutBackendResults[1].toString(), 'PPanel : panel1 : must either be static or have a backend defined');
        expect(withoutDataSourceResults.length, 2);
        expect(withoutDataSourceResults[1].toString(), 'PPanel : panel1 : must either be static or have a dataSource defined');
        expect(withDataSourceAndBackendResults.length, 0);
      });
    });
  });
}
