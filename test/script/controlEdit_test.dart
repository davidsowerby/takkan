import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/script/script.dart';

void main() {
  group('ControlEdit settings', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('defaults', () {
      // given
      final script = PScript(
        pages: {
          '/home': PPage(
              // ignore: missing_required_param
              content: [
                PPanel(
                  caption: 'panel1',
                  content: [
                    PPart(caption: 'panel1-part1'),
                    PPanel(
                      caption: 'panel11',
                      content: [PPart(caption: 'panel11-part1')],
                    ),
                  ],
                ),
                PPart(caption: 'page-part1'),
              ],
            ),
        },
      );

      final page = script.pages['/home'];
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
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
        controlEdit: ControlEdit.panelsOnly,
        pages: {
          '/home': PPage(
              // ignore: missing_required_param
              content: [
                PPanel(
                  caption: 'panel1',
                  content: [
                    PPart(caption: 'panel1-part1'),
                    PPanel(
                      caption: 'panel11',
                      content: [PPart(caption: 'panel11-part1')],
                    ),
                  ],
                ),
                PPart(caption: 'page-part1', controlEdit: ControlEdit.thisOnly),
              ],
            ),
        },
      );

      final page = script.pages['/home'];
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
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
        pages: {
          '/home': PPage(
              title: 'title',
              controlEdit: ControlEdit.firstLevelPanels,
              content: [
                PPanel(
                  caption: 'panel1',
                  content: [
                    PPart(caption: 'panel1-part1'),
                    PPanel(
                      caption: 'panel11',
                      content: [PPart(caption: 'panel11-part1')],
                    ),
                  ],
                ),
                PPart(caption: 'page-part1', controlEdit: ControlEdit.thisOnly),
              ],
            ),
        },
      );

      final page = script.pages['/home'];
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
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
        pages: {
          '/home': PPage(
              // ignore: missing_required_param
              content: [
                PPanel(
                  caption: 'panel1',
                  content: [
                    PPart(caption: 'panel1-part1'),
                    PPanel(
                      caption: 'panel11',
                      content: [PPart(caption: 'panel11-part1')],
                    ),
                  ],
                ),
                PPart(caption: 'page-part1'),
              ],
            ),
        },
      );

      final page = script.pages['/home'];
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
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
        controlEdit: ControlEdit.thisAndBelow, // ignore: missing_required_param
        pages: {
          '/home': PPage(
              // ignore: missing_required_param
              content: [
                PPanel(
                  caption: 'panel1',
                  content: [
                    PPart(caption: 'panel1-part1'),
                    PPanel(
                      controlEdit: ControlEdit.noEdit,
                      caption: 'panel11',
                      content: [PPart(caption: 'panel11-part1')],
                    ),
                  ],
                ),
                PPart(caption: 'page-part1', controlEdit: ControlEdit.thisOnly),
              ],
            ),
        },
      );

      final page = script.pages['/home'];
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
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
        controlEdit: ControlEdit.inherited,
        pages: {
          '/home': PPage(
              // ignore: missing_required_param
              content: [
                PPanel(
                  caption: 'panel1',
                  content: [
                    PPart(caption: 'panel1-part1'),
                    PPanel(
                      controlEdit: ControlEdit.partsOnly,
                      caption: 'panel11',
                      content: [PPart(caption: 'panel11-part1')],
                    ),
                  ],
                ),
                PPart(caption: 'page-part1'),
              ],
            ),
        },
      );

      final page = script.pages['/home'];
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
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
