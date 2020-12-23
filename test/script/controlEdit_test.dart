import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/script.dart';
import 'package:test/test.dart';

void main() {
  group('ControlEdit settings', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('defaults', () {
      // given
      final script = PScript(
        components: {
          'core': PComponent(
            // ignore: missing_required_param
            routes: {
              '/home': PRoute(
                page: PPage(
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
              ),
            },
          ),
        },
      );

      final component = script.components['core'];
      final route = component.routes['/home'];
      final page = route.page;
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
      // then
      expect(script.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(route.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(page.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(panel1.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(panel11.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(panel1Part1.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(panel11Part1.controlEdit, ControlEdit.notSetAtThisLevel);
      expect(pagePart.controlEdit, ControlEdit.notSetAtThisLevel);

      expect(script.hasEditControl, false);
      expect(component.hasEditControl, false);
      expect(route.hasEditControl, false);
      expect(page.hasEditControl, false);
      expect(panel1.hasEditControl, false);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, false);
      expect(pagePart.hasEditControl, false);
    });

    test('panelsOnly with Part override', () {
      // given
      final script = PScript(
        controlEdit: ControlEdit.panelsOnly,
        components: {
          'core': PComponent(
            // ignore: missing_required_param
            routes: {
              '/home': PRoute(
                page: PPage(
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
              ),
            },
          ),
        },
      );

      final component = script.components['core'];
      final route = component.routes['/home'];
      final page = route.page;
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(component.hasEditControl, false);
      expect(route.hasEditControl, false);
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
        components: {
          'core': PComponent(
            controlEdit: ControlEdit.firstLevelPanels, // ignore: missing_required_param
            routes: {
              '/home': PRoute(
                page: PPage(
                  title: 'title',
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
              ),
            },
          ),
        },
      );

      final component = script.components['core'];
      final route = component.routes['/home'];
      final page = route.page;
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(component.hasEditControl, false);
      expect(route.hasEditControl, false);
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
        components: {
          'core': PComponent(
            controlEdit: ControlEdit.thisOnly, // ignore: missing_required_param
            routes: {'/home':
            PRoute(
              page: PPage(
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
            ),
            },
          ),
        },
      );

      final component = script.components['core'];
      final route = component.routes['/home'];
      final page = route.page;
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(component.hasEditControl, false);
      expect(route.hasEditControl, false);
      expect(page.hasEditControl, false);
      expect(panel1.hasEditControl, false);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, false);
      expect(pagePart.hasEditControl, false);
    });

    test('thisAndBelow with negation', () {
      // given
      final script = PScript(
        components: {
          'core': PComponent(
            controlEdit: ControlEdit.thisAndBelow, // ignore: missing_required_param
            routes: {'/home':
            PRoute(
              page: PPage(
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
            ),
            },
          ),
        },
      );

      final component = script.components['core'];
      final route = component.routes['/home'];
      final page = route.page;
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(component.hasEditControl, false);
      expect(route.hasEditControl, false);
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
        components: {
          'core': PComponent(
            // ignore: missing_required_param
            routes: {'/home':
            PRoute(
              page: PPage(
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
            ),
            },
          ),
        },
      );

      final component = script.components['core'];
      final route = component.routes['/home'];
      final page = route.page;
      final panel1 = page.content[0] as PPanel;
      final panel11 = panel1.content[1] as PPanel;
      final panel1Part1 = panel1.content[0] as PPart;
      final panel11Part1 = panel11.content[0] as PPart;
      final pagePart = page.content[1] as PPart;

      // when
      script.init();
      // then

      expect(script.hasEditControl, false);
      expect(component.hasEditControl, false);
      expect(route.hasEditControl, false);
      expect(page.hasEditControl, false);
      expect(panel1.hasEditControl, false);
      expect(panel11.hasEditControl, false);
      expect(panel1Part1.hasEditControl, false);
      expect(panel11Part1.hasEditControl, true);
      expect(pagePart.hasEditControl, false);
    });
  });
}
