import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
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
        routes: {
          '/home': PPage(
            title: 'A page',
            // ignore: missing_required_param
            content: [
              PPanel(
                property: '',
                caption: 'panel1',
                content: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanel(
                    property: '',
                    caption: 'panel11',
                    content: [
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
        },
      );

      final page = script.routes['/home'];
      final panel1 = page?.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page?.content[1] as PPart;

      // when
      script.init();
      // then
      expect(script.controlEdit, ControlEdit.firstLevelPanels);
      expect(page?.controlEdit, ControlEdit.inherited);
      expect(panel1.controlEdit, ControlEdit.inherited);
      expect(panel11.controlEdit, ControlEdit.inherited);
      expect(panel1Part1.controlEdit, ControlEdit.inherited);
      expect(panel11Part1.controlEdit, ControlEdit.inherited);
      expect(pagePart.controlEdit, ControlEdit.inherited);

      expect(script.hasEditControl, false);
      expect(page?.hasEditControl, false);
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
        controlEdit: ControlEdit.panelsOnly,
        routes: {
          '/home': PPage(
            title: 'A page',
            // ignore: missing_required_param
            content: [
              PPanel(
                property: '',
                caption: 'panel1',
                content: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanel(
                    property: '',
                    caption: 'panel11',
                    content: [
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
        },
      );

      final page = script.routes['/home'];
      final panel1 = page?.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page?.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(page?.hasEditControl, false);
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
        routes: {
          '/home': PPage(
            title: 'title',
            controlEdit: ControlEdit.firstLevelPanels,
            content: [
              PPanel(
                property: '',
                caption: 'panel1',
                content: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanel(
                    property: '',
                    caption: 'panel11',
                    content: [
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
        },
      );

      final page = script.routes['/home'];
      final panel1 = page?.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page?.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(page?.hasEditControl, false);
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
        routes: {
          '/home': PPage(
            title: 'A page',
            content: [
              PPanel(
                property: '',
                caption: 'panel1',
                content: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanel(
                    property: '',
                    caption: 'panel11',
                    content: [
                      PPart(readTraitName: 'part', caption: 'panel11-part1')
                    ],
                  ),
                ],
              ),
              PPart(readTraitName: 'part', caption: 'page-part1'),
            ],
          ),
        },
      );

      final page = script.routes['/home'];
      final panel1 = page?.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page?.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(page?.hasEditControl, false);
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
        controlEdit: ControlEdit.thisAndBelow, // ignore: missing_required_param
        routes: {
          '/home': PPage(
            title: 'A page',
            content: [
              PPanel(
                property: '',
                caption: 'panel1',
                content: [
                  PPart(readTraitName: 'part', caption: 'panel1-part1'),
                  PPanel(
                    property: '',
                    controlEdit: ControlEdit.noEdit,
                    caption: 'panel11',
                    content: [
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
        },
      );

      final page = script.routes['/home'];
      final panel1 = page?.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page?.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(page?.hasEditControl, true);
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
        controlEdit: ControlEdit.inherited,
        routes: {
          '/home': PPage(
            title: 'A page',
            content: [
              PPanel(
                property: '',
                caption: 'panel1',
                content: [
                  PPart(
                      readTraitName: 'default',
                      property: '',
                      caption: 'panel1-part1'),
                  PPanel(
                    property: '',
                    controlEdit: ControlEdit.partsOnly,
                    caption: 'panel11',
                    content: [
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
        },
      );

      final page = script.routes['/home'];
      final panel1 = page?.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page?.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(page?.hasEditControl, false);
      expect(panel1.hasEditControl, false);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, true);
      expect(pagePart.hasEditControl, false);
    });
  });
}
