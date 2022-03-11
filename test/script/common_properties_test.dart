import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/panel/static_panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/data/select/data.dart';
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
      final script = PScript(
        name: 'test',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        dataProvider: PDataProvider(
          instanceConfig: const PInstance(group: '', instance: ''),
        ),
        pages: [
          PPageStatic(routes: ['/'],
            caption: 'A Page',
            controlEdit: ControlEdit.thisAndBelow,
            children: [
              PPanelStatic(
                controlEdit: ControlEdit.noEdit,
                children: [
                  PPart(readTraitName: 'default'),
                ],
              ),
            ],
          ),
        ],
      );
      // when
      script.init();
      // then
      final page = script.routes['/'] as PPageStatic;
      final panel = page.children[0] as PPanelStatic;
      final part = panel.children[0] as PPart;

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
      final script = PScript(
          name: 'test',
          version: PVersion(number: 0),
          schema: PSchema(
            name: 'test',
            version: PVersion(number: 0),
          ),
          dataProvider: PNoDataProvider(),
          pages: [
            PPageStatic(
              routes: ['/test'],
              caption: 'A Page',
              children: [
                PPanelStatic(
                  children: [
                    PPart(
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
      final page = script.routes['/test'] as PPageStatic;
      final panel = page.children[0] as PPanelStatic;
      final part = panel.children[0] as PPart;

      expect(page.isStatic, true);
      expect(page.dataProvider, isA<PNoDataProvider>());
      expect(page.controlEdit, ControlEdit.inherited);
      expect(page.dataProviderIsDeclared, false);

      expect(panel.isStatic, true);
      expect(page.dataProvider, isA<PNoDataProvider>());
      expect(panel.controlEdit, ControlEdit.inherited);
      expect(panel.isDataRoot, false);
      expect(panel.dataProviderIsDeclared, false);

      expect(page.dataProvider, isA<PNoDataProvider>());
      expect(part.controlEdit, ControlEdit.inherited);
      expect(part.dataProviderIsDeclared, false);
    });
  });
}
