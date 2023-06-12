import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/panel/static_panel.dart';
import 'package:takkan_script/part/part.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/script_element.dart';
import 'package:test/test.dart';

import '../../../takkan_schema/test/fixtures.dart';

void main() {
  group('Common properties', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<TakkanSchemaLoader>(() => FakeTakkanSchemaLoader());
    });

    tearDown(() {});

    test('correct inherit / overrule', () {
      // given
      final script = Script(
        name: 'test',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        dataProvider: DataProvider(
          instanceConfig: const AppInstance(group: '', instance: ''),
        ),
        pages: [
          Page(
            name: 'home',
            caption: 'A Page',
            controlEdit: ControlEdit.thisAndBelow,
            children: [
              PanelStatic(
                controlEdit: ControlEdit.noEdit,
                children: [
                  Part(traitName: 'default'),
                ],
              ),
            ],
          ),
        ],
      );
      // when
      script.init();
      // then
      final page = script.pageFromStringRoute('home/static')!;
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
          version: const Version(number: 0),
          schema: Schema(
            name: 'test',
            version: const Version(number: 0),
          ),
          dataProvider: NullDataProvider(),
          pages: [
            Page(
              name: 'test',
              caption: 'A Page',
              children: [
                PanelStatic(
                  children: [
                    Part(
                      traitName: 'default',
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
      // ignore: cast_nullable_to_non_nullable
      final page = script.routes[TakkanRoute.fromString('test/static')] as Page;
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
