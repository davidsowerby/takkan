import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/documentId.dart';
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
        expect(result[0].toString(), 'PScript : Script:0 : must contain at least one component');
      });
    });
  });

  group('PRoute validation', () {
    test('Must have path and page', () {
      // given
      final script = PScript(
        name: 'test',
        routes: {
          '': PRoute(),
        },
      ); // ignore: missing_required_param
      // when
      final messages = script.validate();
      // then

      expect(messages.length, 3);
      expect(messages[0].toString(), 'PScript : test : PRoute path cannot be an empty String');
      expect(messages[1].toString(), 'PRoute : test.Route:0 : must define a path');
      expect(messages[2].toString(), 'PRoute : test.Route:0 : must define a page');
    });
  });

  group('PPage validation', () {
    test('Must have pageType and title', () {
      // given
      final component = PScript(
        isStatic: IsStatic.yes,
        routes: {
          "/home": PRoute(
            page: PPage(pageType: null),
          ),
        },
      ); // ignore: missing_required_param

      // when
      final messages = component.validate();
      // then

      expect(messages.length, 2);
      expect(messages[0].toString(), 'PPage : Script:0./home.Page:0 : must define a title');
      expect(messages[1].toString(), 'PPage : Script:0./home.Page:0 : must define a pageType');
    });

    test('No errors', () {
      // given
      final component = PScript(
        dataProvider: PRestDataProvider(instanceName: 'mock', connectionData: const {'instanceKey': 'test'}),
        routes: {
          "/home": PRoute(
            page: PPage(
              pageType: "mine",
              title: "Wiggly",
              dataSource: PGet(
                documentId: DocumentId(),
              ),
            ),
          ), // ignore: missing_required_param
        },
      );
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 0);
    });
  });

  group('PPanel validation', () {
    test('No errors', () {
      // given
      final component = PScript(
          dataProvider: PRestDataProvider(instanceName: 'mock', connectionData: const {'instanceKey': 'test'}),
          routes: {
            "/home": PRoute(
              page: PPage(
                pageType: "mine",
                title: "Wiggly",
                dataSource: PGet(
                  // ignore: missing_required_param
                  documentId: DocumentId(), // ignore: missing_required_param
                ),
                content: [PPanel()],
              ),
            )
          });
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 0);
    });

    test('any non-static PPanel must be able to access DataSource', () {
      // given
      final withoutDataSourceOrBackend = PScript(
        routes: {
          "/home": PRoute(
            dataProvider: PRestDataProvider(instanceName: 'mock', connectionData: const {'instanceKey': 'test'}),
            page: PPage(
              pageType: "mine",
              title: "Wiggly",
              content: [PPanel(caption: 'panel1')],
            ),
          ),
        },
      );

      final withoutDataSource = PScript(
        dataProvider: PRestDataProvider(instanceName: 'mock', connectionData: const {'instanceKey': 'test'}),
        routes: {
          "/home": PRoute(
            page: PPage(
              pageType: "mine",
              title: "Wiggly",
              content: [PPanel(caption: 'panel1')],
            ),
          )
        },
      );

      final withDataSourceAndBackend = PScript(
        dataProvider: PRestDataProvider(instanceName: 'mock', connectionData: const {'instanceKey': 'test'}),
        // ignore: missing_required_param

        routes: {
          "/home": PRoute(
            page: PPage(
              pageType: "mine",
              title: "Wiggly",
              dataSource: PGet(
                // ignore: missing_required_param
                documentId: DocumentId(), // ignore: missing_required_param
              ),
              content: [PPanel(caption: 'panel1')],
            ),
          )
        },
      );

      // when
      final withoutDataSourceOrBackendResults = withoutDataSourceOrBackend.validate();
      final withoutDataSourceResults = withoutDataSource.validate();
      final withDataSourceAndBackendResults = withDataSourceAndBackend.validate();
      // then

      expect(withoutDataSourceOrBackendResults.length, 1);
      expect(withoutDataSourceOrBackendResults[0].toString(),
          'PPanel : Script:0./home.Wiggly.panel1 : must either be static or have a dataSource defined');
      expect(withoutDataSourceResults.length, 1);
      expect(withoutDataSourceResults[0].toString(),
          'PPanel : Script:0./home.Wiggly.panel1 : must either be static or have a dataSource defined');
      expect(withDataSourceAndBackendResults.length, 0);
    });
  });
}
