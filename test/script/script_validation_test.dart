import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/panel/static_panel.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

void main() {
  group('PScript validation', () {
    setUp(() {
      getIt.reset();
      getIt.registerFactory<TakkanSchemaLoader>(() => FakeTakkanSchemaLoader());
    });
    test('Insufficient components', () {
      // given
      final script1 = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
      );
      // when
      final result = script1.validate();
      // then

      expect(result.length, 1);
      expect(result[0].toString(),
          'PScript : A Script : must contain at least one page');
    });
  }, skip: true);

  group('PPage validation 1', () {
    setUp(() {
      getIt.reset();
      getIt.registerFactory<TakkanSchemaLoader>(() => FakeTakkanSchemaLoader());
    });
    test(
      'Must have non-empty route',
      () {
        // given
        final script = Script(
          name: 'test',
          version: const Version(number: 0),
          schema: Schema(
            name: 'test',
            version: const Version(number: 0),
          ),
          pages: [
            Page(
              name: 'home',
              caption: 'A page',
            ),
          ],
        ); // ignore: missing_required_param
        // when
        final messages = script.validate();
        // then

        expect(messages.length, 1);
        expect(messages[0].toString(),
            'PScript : test : PPage route cannot be an empty String');
      },
    );
  }, skip: true);

  group('PPage validation 2', () {
    test('Must have non-empty pageType', () {
      // given
      final component = Script(
        name: 'A script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        pages: [
          Page(
            name: 'home',
            caption: 'a Page title',
          ),
        ],
      );
      getIt.registerFactory<TakkanSchemaLoader>(() => FakeTakkanSchemaLoader());
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 1);
      expect(messages[0].toString(),
          'PPage : A script./home : must define a non-empty pageType');
    });

    test('No errors', () {
      // given
      final component = Script(
        name: 'a script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        dataProvider: DataProvider(
          instanceConfig: const AppInstance(
            group: '',
            instance: '',
          ),
        ),
        pages: [
          Page(
            name: 'wiggly',
            caption: 'Wiggly',
            dataSelectors: const [
             DocByQuery(
               queryName: '?',
              )
            ],
          ),
        ],
      );
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 0);
    });
  }, skip: true);

  group('PPanel validation', () {
    test('No errors', () {
      // given
      final component = Script(
          name: 'A Script',
          version: const Version(number: 0),
          schema: Schema(
            name: 'test',
            version: const Version(number: 0),
          ),
          dataProvider: DataProvider(
            instanceConfig: const AppInstance(
              group: 'back4app',
              instance: 'dev',
            ),
          ),
          pages: [
            Page(
              name: 'wiggly',
              caption: 'Wiggly',
              dataSelectors: const [
               DocByQuery(
                 queryName: '?',
                  caption: 'Wiggly',
                )
              ],
              children: [
                PanelStatic(),
              ],
            ),
          ]);
      // when
      final messages = component.validate();
      // then

      expect(messages.length, 0);
    });

    test('any non-static PPanel must be able to access Query', () {
      // given
      final withoutQueryOrDataProvider = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        pages: [
          Page(
            name: 'home',
            caption: 'Wiggly',
            children: [
              PanelStatic(
                caption: 'panel1',
              ),
            ],
          ),
        ],
      );

      final withoutQuery = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        dataProvider: DataProvider(
          instanceConfig: const AppInstance(
            group: 'back4app',
            instance: 'dev',
          ),
        ),
        pages: [
          Page(
            name: 'home',
            caption: 'Wiggly',
            children: [PanelStatic(caption: 'panel1')],
          ),
        ],
      );

      final withQueryAndProvider = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        dataProvider: DataProvider(
          instanceConfig: const AppInstance(
            group: 'back4app',
            instance: 'dev',
          ),
        ),
        pages: [
          Page(
            name: 'wiggly',
            caption: 'Wiggly',
            dataSelectors: const [
             DocByQuery(
               queryName: 'fixed thing',
              )
            ],
            children: [PanelStatic(caption: 'panel1')],
          ),
        ],
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
        'PPanel : A Script./home.panel1 : must either be static or have a data-select defined',
      ]);
      expect(withoutQueryResults, [
        'PPanel : A Script./home.panel1 : is not static, and must therefore declare a property (which can be an empty String)',
        'PPanel : A Script./home.panel1 : must either be static or have a data-select defined'
      ]);
      expect(withQueryAndProviderResults, [
        'PPanel : A Script./home.panel1 : is not static, and must therefore declare a property (which can be an empty String)',
        'PPanel : A Script./home.panel1 : must either be static or have a data-select defined'
      ]);
    });
  }, skip: true);
}
