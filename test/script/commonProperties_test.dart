import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

void main() {
  group('Common properties', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
    });

    tearDown(() {});

    test('correct inherit / overrule', ()
    {
      // given
      final  PSchema schema = PSchema();
      final script = PScript(
        name: 'test',
        dataProvider: PRestDataProvider(),
        isStatic: IsStatic.yes,
        query: PGet(),
        pages: {
          '': PPage(
              controlEdit: ControlEdit.thisAndBelow,
              content: [
                PPanel(
                  controlEdit: ControlEdit.noEdit,
                  content: [
                    PPart(),
                  ],
                ),
              ],
            ),
        },
      );
      // when
       script.init();
      // then
      final page = script.pages[''];
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;

      expect(page.isStatic, IsStatic.yes);
      expect(page.dataProvider, isNotNull);
      expect(page.query, isNotNull);
      expect(page.controlEdit, ControlEdit.thisAndBelow);
      expect(page.queryIsDeclared, true);
      expect(page.dataProviderIsDeclared, true);

      expect(panel.isStatic, IsStatic.yes);
      expect(panel.dataProvider, isNotNull);
      expect(panel.query, isNotNull);
      expect(panel.controlEdit, ControlEdit.noEdit);
      expect(panel.queryIsDeclared, false);
      expect(panel.dataProviderIsDeclared, false);

      expect(part.isStatic, IsStatic.yes);
      expect(part.dataProvider, isNotNull);
      expect(part.query, isNotNull);
      expect(part.controlEdit, ControlEdit.inherited);
      expect(part.queryIsDeclared, false);
      expect(part.dataProviderIsDeclared, false);
    });

    test('defaults, unset', () {
      // given
      final script = PScript(name: 'test',
          pages: {
            '/test': PPage(
                content: [
                  PPanel(
                    content: [
                  PPart(),
                ],
                  ),
                ],
              ),
      });
      // when

      script.init();
      // then
      final page = script.pages['/test'];
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;



      expect(page.isStatic, IsStatic.inherited);
      expect(page.dataProvider, isInstanceOf<PNoDataProvider>());
      expect(page.query, isNull);
      expect(page.controlEdit, ControlEdit.inherited);
      expect(page.queryIsDeclared, false);
      expect(page.dataProviderIsDeclared, false);

      expect(panel.isStatic, IsStatic.inherited);
      expect(page.dataProvider, isInstanceOf<PNoDataProvider>());
      expect(panel.query, isNull);
      expect(panel.controlEdit, ControlEdit.inherited);
      expect(panel.queryIsDeclared, false);
      expect(panel.dataProviderIsDeclared, false);

      expect(part.isStatic, IsStatic.inherited);
      expect(page.dataProvider, isInstanceOf<PNoDataProvider>());
      expect(part.query, isNull);
      expect(part.controlEdit, ControlEdit.inherited);
      expect(part.queryIsDeclared, false);
      expect(part.dataProviderIsDeclared, false);
    });
  });
}
