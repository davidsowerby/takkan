import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_script/script/part/options.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';

import '../../helper/widgetTestTree.dart';

/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchensink.html#static-page)
///

final PScript kitchenSink00 = PScript(
  name: 'script00',
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
              PString(caption: 'Part 1', staticData: 'Part 1'),
              PPanel(
                caption: 'Panel 2',
                heading: PPanelHeading(),
                content: [
                  PPanel(
                    caption: 'Panel 2-1',
                    heading: PPanelHeading(),
                    content: [
                      PString(caption: 'Part 2-1-1', staticData: 'Part 2-1-1'),
                      PString(
                          readModeOptions: PReadModeOptions(showCaption: false),
                          id: 'Part 2-1-2',
                          staticData: 'Part 2-1-2'),
                    ],
                  ),
                  PString(caption: 'Part 2-2', staticData: 'Part 2-2'),
                  PString(
                      readModeOptions: PReadModeOptions(showCaption: false),
                      id: 'Part 2-3',
                      staticData: 'Part 2-3'),
                ],
              ),
              PString(caption: 'Part 3', staticData: 'Part 3'),
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
      final PScript script = KitchenSinkTest().init(script: kitchenSink00, useCaptionsAsIds: true);
      // when
      final widgetTree = MaterialApp(
          home: PageBuilder().build(
        config: script.components[0].routes[0].page,
      ));
      await tester.pumpWidget(widgetTree);
      testTree = WidgetTestTree(script, tester.allWidgets.toList());
      testTree.verify();
      // then
      final pageId = 'script00.core./test.Page 1';
      expect(testTree.elementHasPanelState(pageId), isFalse);
      expect(testTree.elementHasEditState(pageId), isFalse);
      expect(testTree.elementHasDataBinding(pageId), isFalse);
      expect(testTree.elementHasDataSource(pageId), isFalse);

      final panel2Id = 'script00.core./test.Page 1.Panel 2';
      expect(testTree.elementHasPanelState(panel2Id), isTrue);
      expect(testTree.elementHasEditState(panel2Id), isFalse);
      expect(testTree.elementHasDataBinding(panel2Id), isFalse);
      expect(testTree.elementHasDataSource(panel2Id), isFalse);
      
      final panel21Id = 'script00.core./test.Page 1.Panel 2.Panel 2-1';
      expect(testTree.elementHasPanelState(panel21Id), isTrue);
      expect(testTree.elementHasEditState(panel21Id), isFalse);
      expect(testTree.elementHasDataBinding(panel21Id), isFalse);
      expect(testTree.elementHasDataSource(panel21Id), isFalse);

      final part1Id = 'script00.core./test.Page 1.Part 1';
      expect(testTree.elementHasEditState(part1Id), isFalse);
      expect(testTree.elementHasDataBinding(part1Id), isFalse);
      expect(testTree.elementHasDataSource(part1Id), isFalse);

      final part3Id='script00.core./test.Page 1.Part 3';
      expect(testTree.elementHasEditState(part3Id), isFalse);
      expect(testTree.elementHasDataBinding(part3Id), isFalse);
      expect(testTree.elementHasDataSource(part3Id), isFalse);

      final part22Id='script00.core./test.Page 1.Panel 2.Part 2-2';
      expect(testTree.elementHasEditState(part22Id), isFalse);
      expect(testTree.elementHasDataBinding(part22Id), isFalse);
      expect(testTree.elementHasDataSource(part22Id), isFalse);

      final part23Id='script00.core./test.Page 1.Panel 2.Part 2-3';
      expect(testTree.elementHasEditState(part23Id), isFalse);
      expect(testTree.elementHasDataBinding(part23Id), isFalse);
      expect(testTree.elementHasDataSource(part23Id), isFalse);

      final part211Id='script00.core./test.Page 1.Panel 2.Panel 2-1.Part 2-1-1';
      expect(testTree.elementHasEditState(part211Id), isFalse);
      expect(testTree.elementHasDataBinding(part211Id), isFalse);
      expect(testTree.elementHasDataSource(part211Id), isFalse);

      final part212Id='script00.core./test.Page 1.Panel 2.Panel 2-1.Part 2-1-2';
      expect(testTree.elementHasEditState(part212Id), isFalse);
      expect(testTree.elementHasDataBinding(part212Id), isFalse);
      expect(testTree.elementHasDataSource(part212Id), isFalse);
    });
  });
}
