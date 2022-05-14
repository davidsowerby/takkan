import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/panel/static_panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

void main() {
  group('Common properties', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(
          () => FakePreceptSchemaLoader());
    });

    tearDown(() {});

    test('correct inherit / overrule', () {
      // given
      final script = Script(
        name: 'test',
        version: Version(number: 0),
        schema: Schema(
          name: 'test',
          version: Version(number: 0),
        ),
        dataProvider: DataProvider(
          instanceConfig: const AppInstance(group: '', instance: ''),
        ),
        pages: [
          PageStatic(
            routes: ['/'],
            caption: 'A Page',
            controlEdit: ControlEdit.thisAndBelow,
            children: [
              PanelStatic(
                controlEdit: ControlEdit.noEdit,
                children: [
                  Part(readTraitName: 'default'),
                ],
              ),
            ],
          ),
        ],
      );
      // when
      script.init();
      // then
      final page = script.routes['/'] as PageStatic;
      final panel = page.children[0] as PanelStatic;
      final part = panel.children[0] as Part;

      expect(page.dataProvider, isNotNull);
      expect(page.controlEdit, ControlEdit.thisAndBelow);
      expect(page.dataProviderIsDeclared, true);

      expect(panel.dataProvider, isNotNull);
      expect(panel.controlEdit, ControlEdit.noEdit);
      expect(panel.isDataRoot, false);
      expect(panel.dataProviderIsDeclared, false);

      expect(part.isStatic, true);
      expect(part.dataProvider, isNotNull);
      expect(part.controlEdit, ControlEdit.inherited);
      expect(part.dataProviderIsDeclared, false);
    });

    test('defaults, unset', () {
      // given
      final script = Script(
          name: 'test',
          version: Version(number: 0),
          schema: Schema(
            name: 'test',
            version: Version(number: 0),
          ),
          dataProvider: NullDataProvider(),
          pages: [
            PageStatic(
              routes: ['/test'],
              caption: 'A Page',
              children: [
                PanelStatic(
                  children: [
                    Part(
                      readTraitName: 'default',
                      property: '',
                    ),
                  ],
                ),
              ],
            ),
          ]);
      // when

      script.init();
      // then
      final page = script.routes['/test'] as PageStatic;
      final panel = page.children[0] as PanelStatic;
      final part = panel.children[0] as Part;

      expect(page.isStatic, true);
      expect(page.dataProvider, isA<NullDataProvider>());
      expect(page.controlEdit, ControlEdit.inherited);
      expect(page.dataProviderIsDeclared, false);

      expect(panel.isStatic, true);
      expect(page.dataProvider, isA<NullDataProvider>());
      expect(panel.controlEdit, ControlEdit.inherited);
      expect(panel.isDataRoot, false);
      expect(panel.dataProviderIsDeclared, false);

      expect(page.dataProvider, isA<NullDataProvider>());
      expect(part.controlEdit, ControlEdit.inherited);
      expect(part.dataProviderIsDeclared, false);
    });
  });
}
