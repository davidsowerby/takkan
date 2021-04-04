import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

void main() {
  group('PScript all level validation', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
    });

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
        dataProvider: PRestDataProvider(
          schemaSource: PSchemaSource(segment: 'back4app', instance: 'dev'),
        ),
        routes: {
          "/home": PRoute(
            page: PPage(
              pageType: "mine",
              title: "Wiggly",
              query: PGet(
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
          dataProvider: PRestDataProvider(
            configSource: PConfigSource(
              segment: 'back4app',
              instance: 'dev',
            ),
            schemaSource: PSchemaSource(
              segment: 'back4app',
              instance: 'dev',
            ),
          ),
          routes: {
            "/home": PRoute(
              page: PPage(
                pageType: "mine",
                title: "Wiggly",
                query: PGet(
                  // ignore: missing_required_param
                  documentId: DocumentId(), // ignore: missing_required_param
                ),
                content: [
                  PPanel(property: ''),
                ],
              ),
            )
          });
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 0);
    });

    test('any non-static PPanel must be able to access Query', () {
      // given
      final withoutQueryOrDataProvider = PScript(
        routes: {
          "/home": PRoute(
            page: PPage(
              pageType: "mine",
              title: "Wiggly",
              content: [PPanel(caption: 'panel1')],
            ),
          ),
        },
      );

      final withoutQuery = PScript(
        dataProvider: PRestDataProvider(
          configSource: PConfigSource(
            segment: 'back4app',
            instance: 'dev',
          ),
          schemaSource: PSchemaSource(
            segment: 'back4app',
            instance: 'dev',
          ),
        ),
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

      final withQueryAndProvider = PScript(
        dataProvider: PRestDataProvider(
          configSource: PConfigSource(
            segment: 'back4app',
            instance: 'dev',
          ),
          schemaSource: PSchemaSource(
            segment: 'back4app',
            instance: 'dev',
          ),
        ),
        // ignore: missing_required_param

        routes: {
          "/home": PRoute(
            page: PPage(
              pageType: "mine",
              title: "Wiggly",
              query: PGet(
                // ignore: missing_required_param
                documentId: DocumentId(), // ignore: missing_required_param
              ),
              content: [PPanel(caption: 'panel1')],
            ),
          )
        },
      );

      // when
      final withoutQueryOrProviderResults =
          withoutQueryOrDataProvider.validate().map((e) => e.toString());
      final withoutQueryResults = withoutQuery.validate().map((e) => e.toString());
      final withQueryAndProviderResults = withQueryAndProvider.validate().map((e) => e.toString());
      // then

      expect(withoutQueryOrProviderResults, [
        'PPanel : Script:0./home.Wiggly.panel1 : is not static, and must therefore declare a property (which can be an empty String)',
        'PPanel : Script:0./home.Wiggly.panel1 : must either be static or have a query defined',
      ]);
      expect(withoutQueryResults, [
        'PPanel : Script:0./home.Wiggly.panel1 : is not static, and must therefore declare a property (which can be an empty String)',
        'PPanel : Script:0./home.Wiggly.panel1 : must either be static or have a query defined',
      ]);
      expect(withQueryAndProviderResults, [
        'PPanel : Script:0./home.Wiggly.panel1 : is not static, and must therefore declare a property (which can be an empty String)',
      ]);
    });
  });
}
