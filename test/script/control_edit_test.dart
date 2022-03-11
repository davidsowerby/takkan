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
  group('ControlEdit settings', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(
          () => FakePreceptSchemaLoader());
    });

    tearDown(() {});

    test('defaults', () {
      // given
      final script = PScript(
        name: 'A Script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        pages: [
          PPageStatic(
            routes: ['/home'],
            caption: 'A page',
            // ignore: missing_required_param
            children: [
              PPanelStatic(
                caption: 'panel1',
                children: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanelStatic(
                    caption: 'panel11',
                    children: [
                      PPart(readTraitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              PPart(
                  readTraitName: 'default',
                  property: '',
                  caption: 'page-part1'),
            ],
          ),
        ],
      );
      script.init();
      final page = script.routes['/home'] as PPageStatic;
      final panel1 = page.children[0] as PPanelStatic;
      final panel11 = panel1.children[1] as PPanelStatic;
      final panel1Part1 = panel1.children[0] as PPart;
      final panel11Part1 = panel11.children[0] as PPart;
      final pagePart = page.children[1] as PPart;

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
      final script = PScript(
        name: 'A Script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        controlEdit: ControlEdit.panelsOnly,
        pages: [
          PPageStatic(
            routes: ['/home'],
            caption: 'A page',
            // ignore: missing_required_param
            children: [
              PPanelStatic(
                caption: 'panel1',
                children: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanelStatic(
                    caption: 'panel11',
                    children: [
                      PPart(readTraitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              PPart(
                  readTraitName: 'part',
                  caption: 'page-part1',
                  controlEdit: ControlEdit.thisOnly),
            ],
          ),
        ],
      );
      script.init();

      final page = script.routes['/home'] as PPageStatic;
      final panel1 = page.children[0] as PPanelStatic;
      final panel11 = panel1.children[1] as PPanelStatic;
      final panel1Part1 = panel1.children[0] as PPart;
      final panel11Part1 = panel11.children[0] as PPart;
      final pagePart = page.children[1] as PPart;

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
      final script = PScript(
        name: 'A Script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        pages: [
          PPageStatic(
            routes: ['/home'],
            caption: 'title',
            controlEdit: ControlEdit.firstLevelPanels,
            children: [
              PPanelStatic(
                caption: 'panel1',
                children: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanelStatic(
                    caption: 'panel11',
                    children: [
                      PPart(readTraitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              PPart(
                  readTraitName: 'part',
                  caption: 'page-part1',
                  controlEdit: ControlEdit.thisOnly),
            ],
          ),
        ],
      );
      script.init();

      final page = script.routes['/home'] as PPageStatic;
      final panel1 = page.children[0] as PPanelStatic;
      final panel11 = panel1.children[1] as PPanelStatic;
      final panel1Part1 = panel1.children[0] as PPart;
      final panel11Part1 = panel11.children[0] as PPart;
      final pagePart = page.children[1] as PPart;

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
      final script = PScript(
        name: 'A script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        pages: [
          PPageStatic(
            routes: ['/home'],
            caption: 'A page',
            children: [
              PPanelStatic(
                caption: 'panel1',
                children: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanelStatic(
                    caption: 'panel11',
                    children: [
                      PPart(readTraitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              PPart(readTraitName: 'part', caption: 'page-part1'),
            ],
          ),
        ],
      );
      script.init();

      final page = script.routes['/home'] as PPageStatic;
      final panel1 = page.children[0] as PPanelStatic;
      final panel11 = panel1.children[1] as PPanelStatic;
      final panel1Part1 = panel1.children[0] as PPart;
      final panel11Part1 = panel11.children[0] as PPart;
      final pagePart = page.children[1] as PPart;

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
      final script = PScript(
        name: 'A Script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        controlEdit: ControlEdit.thisAndBelow,
        // ignore: missing_required_param
        pages: [
          PPageStatic(
            routes: ['/home'],
            caption: 'A page',
            children: [
              PPanelStatic(
                caption: 'panel1',
                children: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanelStatic(
                    controlEdit: ControlEdit.noEdit,
                    caption: 'panel11',
                    children: [
                      PPart(readTraitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              PPart(
                  readTraitName: 'part',
                  caption: 'page-part1',
                  controlEdit: ControlEdit.thisOnly),
            ],
          ),
        ],
      );
      script.init();
      final page = script.routes['/home'] as PPageStatic;
      final panel1 = page.children[0] as PPanelStatic;
      final panel11 = panel1.children[1] as PPanelStatic;
      final panel1Part1 = panel1.children[0] as PPart;
      final panel11Part1 = panel11.children[0] as PPart;
      final pagePart = page.children[1] as PPart;

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
      final script = PScript(
        name: 'A Script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
        controlEdit: ControlEdit.inherited,
        pages: [
          PPageStatic(
            routes: ['/home'],
            caption: 'A page',
            children: [
              PPanelStatic(
                caption: 'panel1',
                children: [
                  PPart(
                      readTraitName: 'default',
                      property: '',
                      caption: 'panel1-part1'),
                  PPanelStatic(
                    controlEdit: ControlEdit.partsOnly,
                    caption: 'panel11',
                    children: [
                      PPart(
                          readTraitName: 'default',
                          property: '',
                          caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              PPart(
                  readTraitName: 'default',
                  property: '',
                  caption: 'page-part1'),
            ],
          ),
        ],
      );
      script.init();
      final page = script.routes['/home'] as PPageStatic;
      final panel1 = page.children[0] as PPanelStatic;
      final panel11 = panel1.children[1] as PPanelStatic;
      final panel1Part1 = panel1.children[0] as PPart;
      final panel11Part1 = panel11.children[0] as PPart;
      final pagePart = page.children[1] as PPart;

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
