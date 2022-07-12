import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/panel/static_panel.dart';
import 'package:takkan_script/part/part.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/script_element.dart';
import 'package:takkan_script/script/version.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

void main() {
  group('ControlEdit settings', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<TakkanSchemaLoader>(() => FakeTakkanSchemaLoader());
    });

    tearDown(() {});

    test('defaults', () {
      // given
      final script = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        pages: [
          Page(name:'home',
            caption: 'A page',
            // ignore: missing_required_param
            children: [
              PanelStatic(
                caption: 'panel1',
                children: [
                  Part(traitName: 'part', caption: 'panel1-part1'),
                  PanelStatic(
                    caption: 'panel11',
                    children: [
                      Part(traitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              Part(
                  traitName: 'default',
                  property: '',
                  caption: 'page-part1'),
            ],
          ),
        ],
      );
      script.init();
      // ignore: cast_nullable_to_non_nullable
      final page = script.pageFromStringRoute('home/static') as Page;
      final panel1 = page.children[0] as PanelStatic;
      final panel11 = panel1.children[1] as PanelStatic;
      final panel1Part1 = panel1.children[0] as Part;
      final panel11Part1 = panel11.children[0] as Part;
      final pagePart = page.children[1] as Part;

      // when
      // then
      expect(script.controlEdit, ControlEdit.firstLevelPanels);
      expect(page.controlEdit, ControlEdit.inherited);
      expect(panel1.controlEdit, ControlEdit.inherited);
      expect(panel11.controlEdit, ControlEdit.inherited);
      expect(panel1Part1.controlEdit, ControlEdit.inherited);
      expect(panel11Part1.controlEdit, ControlEdit.inherited);
      expect(pagePart.controlEdit, ControlEdit.inherited);

      expect(script.hasEditControl, false);
      expect(page.hasEditControl, false);
      expect(panel1.hasEditControl, true);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, false);
      expect(pagePart.hasEditControl, false);
    });

    test('panelsOnly with Part override', () {
      // given
      final script = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        controlEdit: ControlEdit.panelsOnly,
        pages: [
          Page(name:'home',
            caption: 'A page',
            // ignore: missing_required_param
            children: [
              PanelStatic(
                caption: 'panel1',
                children: [
                  Part(traitName: 'part', caption: 'panel1-part1'),
                  PanelStatic(
                    caption: 'panel11',
                    children: [
                      Part(traitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              Part(
                  traitName: 'part',
                  caption: 'page-part1',
                  controlEdit: ControlEdit.thisOnly),
            ],
          ),
        ],
      );
      script.init();

      final page = script.pageFromStringRoute('home/static')!;
      final panel1 = page.children[0] as PanelStatic;
      final panel11 = panel1.children[1] as PanelStatic;
      final panel1Part1 = panel1.children[0] as Part;
      final panel11Part1 = panel11.children[0] as Part;
      final pagePart = page.children[1] as Part;

      // when
      // then

      expect(script.hasEditControl, false);
      expect(page.hasEditControl, false);
      expect(panel1.hasEditControl, true);
      expect(panel11.hasEditControl, true);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, false);
      expect(pagePart.hasEditControl, true);
    });

    test('firstLevelPanels with Part override', () {
      // given
      final script = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        pages: [
          Page(name:'home',
            caption: 'title',
            controlEdit: ControlEdit.firstLevelPanels,
            children: [
              PanelStatic(
                caption: 'panel1',
                children: [
                  Part(traitName: 'part', caption: 'panel1-part1'),
                  PanelStatic(
                    caption: 'panel11',
                    children: [
                      Part(traitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              Part(
                  traitName: 'part',
                  caption: 'page-part1',
                  controlEdit: ControlEdit.thisOnly),
            ],
          ),
        ],
      );
      script.init();

      final page = script.pageFromStringRoute('home/static')!;
      final panel1 = page.children[0] as PanelStatic;
      final panel11 = panel1.children[1] as PanelStatic;
      final panel1Part1 = panel1.children[0] as Part;
      final panel11Part1 = panel11.children[0] as Part;
      final pagePart = page.children[1] as Part;

      // when

      // then

      expect(script.hasEditControl, false);
      expect(page.hasEditControl, false);
      expect(panel1.hasEditControl, true);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, false);
      expect(pagePart.hasEditControl, true);
    });

    test('thisOnly does nothing if too high', () {
      // given
      final script = Script(
        name: 'A script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        pages: [
          Page(name:'home',
            caption: 'A page',
            children: [
              PanelStatic(
                caption: 'panel1',
                children: [
                  Part(traitName: 'part', caption: 'panel1-part1'),
                  PanelStatic(
                    caption: 'panel11',
                    children: [
                      Part(traitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              Part(traitName: 'part', caption: 'page-part1'),
            ],
          ),
        ],
      );
      script.init();

      final page = script.pageFromStringRoute('home/static')!;
      final panel1 = page.children[0] as PanelStatic;
      final panel11 = panel1.children[1] as PanelStatic;
      final panel1Part1 = panel1.children[0] as Part;
      final panel11Part1 = panel11.children[0] as Part;
      final pagePart = page.children[1] as Part;

      // when

      // then

      expect(script.hasEditControl, false);
      expect(page.hasEditControl, false);
      expect(panel1.hasEditControl, true);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, false);
      expect(pagePart.hasEditControl, false);
    });

    test('thisAndBelow with negation', () {
      // given
      final script = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        controlEdit: ControlEdit.thisAndBelow,
        // ignore: missing_required_param
        pages: [
          Page(name:'home',
            caption: 'A page',
            children: [
              PanelStatic(
                caption: 'panel1',
                children: [
                  Part(traitName: 'part', caption: 'panel1-part1'),
                  PanelStatic(
                    controlEdit: ControlEdit.noEdit,
                    caption: 'panel11',
                    children: [
                      Part(traitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              Part(
                  traitName: 'part',
                  caption: 'page-part1',
                  controlEdit: ControlEdit.thisOnly),
            ],
          ),
        ],
      );
      script.init();
      final page = script.pageFromStringRoute('home/static')!;
      final panel1 = page.children[0] as PanelStatic;
      final panel11 = panel1.children[1] as PanelStatic;
      final panel1Part1 = panel1.children[0] as Part;
      final panel11Part1 = panel11.children[0] as Part;
      final pagePart = page.children[1] as Part;

      // when
      // then

      expect(script.hasEditControl, false);
      expect(page.hasEditControl, true);
      expect(panel1.hasEditControl, true);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, true);
      expect(panel11Part1.hasEditControl, false);
      expect(pagePart.hasEditControl, true);
    });

    test('partsOnly, single branch', () {
      // given
      final script = Script(
        name: 'A Script',
        version: const Version(number: 0),
        schema: Schema(
          name: 'test',
          version: const Version(number: 0),
        ),
        controlEdit: ControlEdit.inherited,
        pages: [
          Page(name:'home',
            caption: 'A page',
            children: [
              PanelStatic(
                caption: 'panel1',
                children: [
                  Part(
                      traitName: 'default',
                      property: '',
                      caption: 'panel1-part1'),
                  PanelStatic(
                    controlEdit: ControlEdit.partsOnly,
                    caption: 'panel11',
                    children: [
                      Part(
                          traitName: 'default',
                          property: '',
                          caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              Part(
                  traitName: 'default',
                  property: '',
                  caption: 'page-part1'),
            ],
          ),
        ],
      );
      script.init();
      final page = script.pageFromStringRoute('home/static')!;
      final panel1 = page.children[0] as PanelStatic;
      final panel11 = panel1.children[1] as PanelStatic;
      final panel1Part1 = panel1.children[0] as Part;
      final panel11Part1 = panel11.children[0] as Part;
      final pagePart = page.children[1] as Part;

      // when
      // then

      expect(script.hasEditControl, false);
      expect(page.hasEditControl, false);
      expect(panel1.hasEditControl, false);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, true);
      expect(pagePart.hasEditControl, false);
    });
  });
}
