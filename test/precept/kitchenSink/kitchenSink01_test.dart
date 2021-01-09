import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/library/library.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_mock_backend/pMockBackend.dart';
import 'package:precept_mock_backend/precept_mock_backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/particle/pText.dart';
import 'package:precept_script/script/script.dart';

import '../../helper/widgetTestTree.dart';

/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchenSink.html#static-page-with-overrides)
///

final PScript kitchenSink01 = PScript(
  name: 'script01',
  isStatic: IsStatic.yes,
  routes: {
    '/test': PRoute(
      page: PPage(
        pageType: Library.simpleKey,
        title: 'Page 1',
        content: [
          PPanel(
            caption: 'Panel 1',
            heading: PPanelHeading(),
            content: [
              PPart(
                id: 'Part 1-1',
                staticData: 'Part 1-1',
                read: PText(showCaption: false),
              ),
              PPart(
                id: 'Part 1-2',
                staticData: 'Part 1-2',
                read: PText(showCaption: false),
              ),
              PPanel(
                caption: 'Panel 1-3',
                isStatic: IsStatic.no,
                backend: PMockBackend(instance: 'test'),
                dataSource: PDataGet(documentId: DocumentId(path: 'Account', itemId: 'objectId1')),
                controlEdit: ControlEdit.thisOnly,
                heading: PPanelHeading(),
                content: [
                  PString(
                    property: 'firstName',
                    caption: 'Part 1-3-1',
                    staticData: 'Part 1-3-1',
                  ),
                  PString(
                    property: 'lastName',
                    caption: 'Part 1-3-2',
                    staticData: 'Part 1-3-2',
                  ),
                ],
              ),
            ],
          ),
          PString(id: 'Part 2', staticData: 'Part 2', caption: 'Part 2'),
          PString(id: 'Part 3', staticData: 'Part 3', caption: 'Part 3'),
        ],
      ),
    ),
  },
);

void main() {
  group('Static Page with Overrides (kitchen-sink-01)', () {
    WidgetTestTree testTree;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      mockBackend.initialData(
        instanceKey: 'test',
        tables: [
          MockTable(
            name: 'Account',
            rows: [
              MockRow(
                objectId: 'objectId1',
                columns: {'firstName': 'David', 'lastName': 'Sowerby'},
              ),
            ],
          ),
        ],
      );
    });

    tearDown(() {
      testTree.debug.forEach((element) {
        print("$element\n");
      });
    });

    testWidgets('All ', (WidgetTester tester) async {
      // given
      final PScript script = KitchenSinkTest().init(script: kitchenSink01, useCaptionsAsIds: true);
      // when
      final widgetTree = MaterialApp(
          home: PreceptPage(
        config: script.routes['/test'].page,
      ));
      await tester.pumpWidget(widgetTree);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      testTree = WidgetTestTree(script, tester.allWidgets.toList());
      // then
      testTree.verify();

      final pageId = 'script01./test.Page 1';
      // expect(testTree.elementHasPanelState(pageId), isFalse);
      expect(testTree.elementHasEditState(pageId), isFalse);
      expect(testTree.elementHasDataBinding(pageId), isFalse);
      expect(testTree.elementHasDataSource(pageId), isFalse);

      final panel1Id = 'script01./test.Page 1.Panel 1';
      // expect(testTree.elementHasPanelState(panel1Id), isTrue);
      expect(testTree.elementHasEditState(panel1Id), isFalse);
      expect(testTree.elementHasDataBinding(panel1Id), isFalse);
      expect(testTree.elementHasDataSource(panel1Id), isFalse);

      final panel13Id = 'script01./test.Page 1.Panel 1.Panel 1-3';
      // expect(testTree.elementHasPanelState(panel13Id), isTrue);
      expect(testTree.elementHasEditState(panel13Id), isTrue);
      expect(testTree.elementHasDataBinding(panel13Id), isTrue);
      expect(testTree.elementHasDataSource(panel13Id), isTrue);

      final part2Id = 'script01./test.Page 1.Part 2';
      expect(testTree.elementHasEditState(part2Id), isFalse);
      expect(testTree.elementHasDataBinding(part2Id), isFalse);
      expect(testTree.elementHasDataSource(part2Id), isFalse);

      final part3Id = 'script01./test.Page 1.Part 3';
      expect(testTree.elementHasEditState(part3Id), isFalse);
      expect(testTree.elementHasDataBinding(part3Id), isFalse);
      expect(testTree.elementHasDataSource(part3Id), isFalse);

      final part11Id = 'script01./test.Page 1.Panel 1.Part 1-1';
      expect(testTree.elementHasEditState(part11Id), isFalse);
      expect(testTree.elementHasDataBinding(part11Id), isFalse);
      expect(testTree.elementHasDataSource(part11Id), isFalse);

      final part12Id = 'script01./test.Page 1.Panel 1.Part 1-2';
      expect(testTree.elementHasEditState(part12Id), isFalse);
      expect(testTree.elementHasDataBinding(part12Id), isFalse);
      expect(testTree.elementHasDataSource(part12Id), isFalse);

      final part131Id = 'script01./test.Page 1.Panel 1.Panel 1-3.Part 1-3-1';
      expect(testTree.elementHasEditState(part131Id), isFalse);
      expect(testTree.elementHasDataBinding(part131Id), isFalse);
      expect(testTree.elementHasDataSource(part131Id), isFalse);

      final part132Id = 'script01./test.Page 1.Panel 1.Panel 1-3.Part 1-3-2';
      expect(testTree.elementHasEditState(part132Id), isFalse);
      expect(testTree.elementHasDataBinding(part132Id), isFalse);
      expect(testTree.elementHasDataSource(part132Id), isFalse);
    });
  });
}
