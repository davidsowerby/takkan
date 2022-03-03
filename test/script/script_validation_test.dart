import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

void main() {
  group('PScript all level validation', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(
          () => FakePreceptSchemaLoader());
    });

    tearDown(() {});
  });

  group('PScript validation', () {
    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(
          () => FakePreceptSchemaLoader());
    });
    test('Insufficient components', () {
      // given
      final script1 = PScript(
        name: 'A Script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
      );
      // when
      final result = script1.validate();
      // then

      expect(result.length, 1);
      expect(result[0].toString(),
          'PScript : A Script : must contain at least one page');
    });
  });

  group('PPage validation 1', () {
    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(
          () => FakePreceptSchemaLoader());
    });
    test('Must have non-empty route', () {
      // given
      final script = PScript(
        name: 'test',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        routes: {
          '': PPage(title: 'A page'),
        },
      ); // ignore: missing_required_param
      // when
      final messages = script.validate();
      // then

      expect(messages.length, 1);
      expect(messages[0].toString(),
          'PScript : test : PPage route cannot be an empty String');
    });
  });

  group('PPage validation 2', () {
    test('Must have non-empty pageType', () {
      // given
      final component = PScript(
        name: 'A script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        isStatic: IsStatic.yes,
        routes: {
          "/home": PPage(title: 'a Page title', pageType: ''),
        },
      );
      getIt.registerFactory<PreceptSchemaLoader>(
          () => FakePreceptSchemaLoader());
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 1);
      expect(messages[0].toString(),
          'PPage : A script./home : must define a non-empty pageType');
    });

    test('No errors', () {
      // given
      final component = PScript(
        name: 'a script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        dataProvider: PDataProvider(
          instanceConfig: const PInstance(
            group: '',
            instance: '',
          ),
        ),
        routes: {
          "/home": PPage(
            pageType: "mine",
            title: "Wiggly",
            query: PGetDocument(
              documentId: DocumentId(path: '', itemId: 'x'),
              documentSchema: 'Document',
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
          version: PVersion(number: 0),
          schema: PSchema(
            name: 'test',
            version: PVersion(number: 0),
          ),
          dataProvider: PDataProvider(
            instanceConfig: PInstance(
              group: 'back4app',
              instance: 'dev',
            ),
          ),
          routes: {
            "/home": PPage(
              pageType: "mine",
              title: "Wiggly",
              query: PGetDocument(
                documentId: DocumentId(path: '', itemId: 'x'),
                documentSchema: 'Document',
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
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        routes: {
          "/home": PPage(
            pageType: "mine",
            title: "Wiggly",
            content: [PPanel(caption: 'panel1')],
          ),
        },
      );

      final withoutQuery = PScript(
        name: 'A Script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        dataProvider: PDataProvider(
          instanceConfig: PInstance(
            group: 'back4app',
            instance: 'dev',
          ),
        ),
        routes: {
          "/home": PPage(
            pageType: "mine",
            title: "Wiggly",
            content: [PPanel(caption: 'panel1')],
          ),
        },
      );

      final withQueryAndProvider = PScript(
        name: 'A Script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        dataProvider: PDataProvider(
          instanceConfig: PInstance(
            group: 'back4app',
            instance: 'dev',
          ),
        ),
        routes: {
          "/home": PPage(
            pageType: "mine",
            title: "Wiggly",
            query: PGetDocument(
              documentId: DocumentId(itemId: 'xx', path: ''),
              documentSchema: 'Document',
            ),
            content: [PPanel(caption: 'panel1')],
          ),
        },
      );

      // when
      final withoutQueryOrProviderResults =
          withoutQueryOrDataProvider.validate().map((e) => e.toString());
      final withoutQueryResults =
          withoutQuery.validate().map((e) => e.toString());
      final withQueryAndProviderResults =
          withQueryAndProvider.validate().map((e) => e.toString());
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
