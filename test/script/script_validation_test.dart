import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/restDataProvider.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

import '../fixtures.dart';

void main() {
  group('PScript all level validation', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(() => FakePreceptSchemaLoader());
    });

    tearDown(() {});

    group('PScript validation', () {
      test('Insufficient components', () {
        // given
        final script1 = PScript(name: 'A Script');
        // when
        final result = script1.validate();
        // then

        expect(result.length, 1);
        expect(result[0].toString(), 'PScript : A Script : must contain at least one page');
      });
    });
  });

  group('PPage validation 1', () {
    test('Must have non-empty route', () {
      // given
      final script = PScript(
        name: 'test',
        pages: {
          '': PPage(title: 'A page'),
        },
      ); // ignore: missing_required_param
      // when
      final messages = script.validate();
      // then

      expect(messages.length, 1);
      expect(messages[0].toString(), 'PScript : test : PPage route cannot be an empty String');
    });
  });

  group('PPage validation 2', () {
    test('Must have non-empty pageType', () {
      // given
      final component = PScript(
        name: 'A script',
        isStatic: IsStatic.yes,
        pages: {
          "/home": PPage(title: 'a Page title', pageType: ''),
        },
      );
      getIt.registerFactory<PreceptSchemaLoader>(() => FakePreceptSchemaLoader());
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 1);
      expect(messages[0].toString(), 'PPage : A script./home : must define a non-empty pageType');
    });

    test('No errors', () {
      // given
      final component = PScript(
        name: 'a script',
        dataProvider: PRestDataProvider(
          documentEndpoint: '',
          configSource: const PConfigSource(
            segment: '',
            instance: '',
          ),
          sessionTokenKey: '',
          headerKeys: const [],
          schemaSource: PSchemaSource(segment: 'back4app', instance: 'dev'),
        ),
        pages: {
          "/home": PPage(
            pageType: "mine",
            title: "Wiggly",
            query: PGetDocument(
              documentId: DocumentId(path: '', itemId: 'x'),
            ),
          ),
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
          name: 'A Script',
          dataProvider: PRestDataProvider(
            documentEndpoint: '',
            sessionTokenKey: '',
            headerKeys: const [],
            configSource: PConfigSource(
              segment: 'back4app',
              instance: 'dev',
            ),
            schemaSource: PSchemaSource(
              segment: 'back4app',
              instance: 'dev',
            ),
          ),
          pages: {
            "/home": PPage(
              pageType: "mine",
              title: "Wiggly",
              query: PGetDocument(
                documentId: DocumentId(path: '', itemId: 'x'),
              ),
              content: [
                PPanel(property: ''),
              ],
            ),
          });
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 0);
    });

    test('any non-static PPanel must be able to access Query', () {
      // given
      final withoutQueryOrDataProvider = PScript(
        name: 'A Script',
        pages: {
          "/home": PPage(
            pageType: "mine",
            title: "Wiggly",
            content: [PPanel(caption: 'panel1')],
          ),
        },
      );

      final withoutQuery = PScript(
        name: 'A Script',
        dataProvider: PRestDataProvider(
          documentEndpoint: '',
          sessionTokenKey: '',
          headerKeys: const [],
          configSource: PConfigSource(
            segment: 'back4app',
            instance: 'dev',
          ),
          schemaSource: PSchemaSource(
            segment: 'back4app',
            instance: 'dev',
          ),
        ),
        pages: {
          "/home": PPage(
            pageType: "mine",
            title: "Wiggly",
            content: [PPanel(caption: 'panel1')],
          ),
        },
      );

      final withQueryAndProvider = PScript(
        name: 'A Script',
        dataProvider: PRestDataProvider(
          documentEndpoint: '',
          sessionTokenKey: '',
          headerKeys: const [],
          configSource: PConfigSource(
            segment: 'back4app',
            instance: 'dev',
          ),
          schemaSource: PSchemaSource(
            segment: 'back4app',
            instance: 'dev',
          ),
        ),
        pages: {
          "/home": PPage(
            pageType: "mine",
            title: "Wiggly",
            query: PGetDocument(
              documentId: DocumentId(itemId: 'xx', path: ''),
            ),
            content: [PPanel(caption: 'panel1')],
          ),
        },
      );

      // when
      final withoutQueryOrProviderResults =
          withoutQueryOrDataProvider.validate().map((e) => e.toString());
      final withoutQueryResults = withoutQuery.validate().map((e) => e.toString());
      final withQueryAndProviderResults = withQueryAndProvider.validate().map((e) => e.toString());
      // then

      expect(withoutQueryOrProviderResults, [
        'PPanel : A Script./home.panel1 : is not static, and must therefore declare a property (which can be an empty String)',
        'PPanel : A Script./home.panel1 : must either be static or have a query defined',
      ]);
      expect(withoutQueryResults, [
        'PPanel : A Script./home.panel1 : is not static, and must therefore declare a property (which can be an empty String)',
        'PPanel : A Script./home.panel1 : must either be static or have a query defined'
      ]);
      expect(withQueryAndProviderResults, [
        'PPanel : A Script./home.panel1 : is not static, and must therefore declare a property (which can be an empty String)',
      ]);
    });
  });
}
