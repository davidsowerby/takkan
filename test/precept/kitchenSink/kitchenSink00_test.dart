import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';

import '../../helper/widgetTestTree.dart';

/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchensink.html#static-page)
///

final PScript kitchenSink00 = PScript(
  isStatic: IsStatic.yes,
  components: [
    PComponent(
      name: 'core',
      routes: [
        PRoute(
          path: '/test',
          page: PPage(
            pageType: Library.simpleKey,
            title: 'Page 1',
            content: [
              PString(id: 'Part 1', staticData: 'Part 1'),
              PPanel(
                id: 'Panel 2',
                heading: PPanelHeading(title: 'Panel 2'),
                content: [
                  PPanel(
                    id: 'Panel 2-1',
                    heading: PPanelHeading(title: 'Panel 2-1'),
                    content: [
                      PString(id: 'Part 2-1-1', staticData: 'Part 2-1-1'),
                      PString(id: 'Part 2-1-2', staticData: 'Part 2-1-2'),
                    ],
                  ),
                  PString(id: 'Part 2-2', staticData: 'Part 2-2'),
                  PString(id: 'Part 2-3', staticData: 'Part 2-3'),
                ],
              ),
              PString(id: 'Part 3', staticData: 'Part 3'),
            ],
          ),
        ),
      ],
    ),
  ],
);

void main() {
  group('Static Page (kitchen-sink-00)', () {
    WidgetTestTree testTree;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {
      testTree.debug.forEach((element) {
        print("$element\n");
      });
    });

    testWidgets('All ', (WidgetTester tester) async {
      // given
      final PScript script = KitchenSinkTest().init(script: kitchenSink00);
      // when
      final widgetTree = MaterialApp(
          home: PageBuilder().build(
        config: script.components[0].routes[0].page,
      ));
      await tester.pumpWidget(widgetTree);
      testTree = WidgetTestTree(tester.allWidgets.toList());
      testTree.verify();
      // then
      expect(testTree.elementHasPanelState('Page 1'), isFalse);
      expect(testTree.elementHasEditState('Page 1'), isFalse);
      expect(testTree.elementHasDataBinding('Page 1'), isFalse);
      expect(testTree.elementHasDataSource('Page 1'), isFalse);

      expect(testTree.elementHasPanelState('Panel 2'), isTrue);
      expect(testTree.elementHasEditState('Panel 2'), isFalse);
      expect(testTree.elementHasDataBinding('Panel 2'), isFalse);
      expect(testTree.elementHasDataSource('Panel 2'), isFalse);

      expect(testTree.elementHasPanelState('Panel 2-1'), isTrue);
      expect(testTree.elementHasEditState('Panel 2-1'), isFalse);
      expect(testTree.elementHasDataBinding('Panel 2-1'), isFalse);
      expect(testTree.elementHasDataSource('Panel 2-1'), isFalse);

      expect(testTree.elementHasEditState('Part 1'), isFalse);
      expect(testTree.elementHasDataBinding('Part 1'), isFalse);
      expect(testTree.elementHasDataSource('Part 1'), isFalse);

      expect(testTree.elementHasEditState('Part 3'), isFalse);
      expect(testTree.elementHasDataBinding('Part 3'), isFalse);
      expect(testTree.elementHasDataSource('Part 3'), isFalse);

      expect(testTree.elementHasEditState('Part 2-2'), isFalse);
      expect(testTree.elementHasDataBinding('Part 2-2'), isFalse);
      expect(testTree.elementHasDataSource('Part 2-2'), isFalse);

      expect(testTree.elementHasEditState('Part 2-1-1'), isFalse);
      expect(testTree.elementHasDataBinding('Part 2-1-1'), isFalse);
      expect(testTree.elementHasDataSource('Part 2-1-1'), isFalse);

      expect(testTree.elementHasEditState('Part 2-1-2'), isFalse);
      expect(testTree.elementHasDataBinding('Part 2-1-2'), isFalse);
      expect(testTree.elementHasDataSource('Part 2-1-2'), isFalse);
    });
  });
}
