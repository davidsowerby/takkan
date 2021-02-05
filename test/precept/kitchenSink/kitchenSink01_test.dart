import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/library/library.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_mock_backend/pMockBackend.dart';
import 'package:precept_mock_backend/precept_mock_backend.dart';
import 'package:precept_script/schema/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/particle/pText.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/script.dart';

import '../../helper/widgetTestTree.dart';

/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchenSink.html#static-page-with-overrides)
///

final PScript kitchenSink01 = PScript(
  name: 'script01',
  isStatic: IsStatic.yes,
  schema: kitchenSinkSchema01,
  routes: {
    'test': PRoute(
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
                backend: PMockDataProvider(instanceName: 'mock'),
                dataSource: PGet(documentId: DocumentId(path: 'Account', itemId: 'objectId1')),
                controlEdit: ControlEdit.thisOnly,
                content: [
                  PPart(
                    property: 'firstName',
                    caption: 'Part 1-3-1',
                    staticData: 'Part 1-3-1',
                  ),
                  PPart(
                    property: 'lastName',
                    caption: 'Part 1-3-2',
                    staticData: 'Part 1-3-2',
                  ),
                ],
              ),
            ],
          ),
          PPart(id: 'Part 2', staticData: 'Part 2', caption: 'Part 2'),
          PPart(id: 'Part 3', staticData: 'Part 3', caption: 'Part 3'),
        ],
      ),
    ),
  },
);

final PSchema kitchenSinkSchema01 = PSchema(documents: {
  'Account': PDocument(
    fields: {
      'firstName': PString(),
      'lastName': PString(),
    },
  ),
});

void main() {
  group('Static Page with Overrides (kitchen-sink-01)', () {
    WidgetTestTree testTree;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      mockBackend.initialData(
        instanceName: 'mock',
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
        config: script.routes['test'].page,
      ));
      await tester.pumpWidget(widgetTree);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      testTree = WidgetTestTree(script, tester.allWidgets.toList(), pages: 1, panels: 2, parts: 6);
      // then
      testTree.verify();

      final pageId = 'script01.test.Page 1';
      expect(testTree.elementHasEditState(pageId), isFalse);
      expect(testTree.elementHasDataBinding(pageId, PreceptPage, tester), isFalse);
      expect(testTree.elementHasDataSource(pageId, PreceptPage, tester), isFalse);

      final panel1Id = 'script01.test.Page 1.Panel 1';
      expect(testTree.elementHasEditState(panel1Id), isFalse);
      expect(testTree.elementHasDataBinding(panel1Id, Panel, tester), isFalse);
      expect(testTree.elementHasDataSource(panel1Id, Panel, tester), isFalse);

      final panel13Id = 'script01.test.Page 1.Panel 1.Panel 1-3';
      expect(testTree.elementHasEditState(panel13Id), isTrue);
      expect(testTree.elementHasDataBinding(panel13Id, Panel, tester), isTrue);
      expect(testTree.elementHasDataSource(panel13Id, Panel, tester), isTrue);

      final part2Id = 'script01.test.Page 1.Part 2';
      expect(testTree.elementHasEditState(part2Id), isFalse);
      expect(testTree.elementHasDataBinding(part2Id, PreceptPage, tester), isFalse);
      expect(testTree.elementHasDataSource(part2Id, PreceptPage, tester), isFalse);

      final part3Id = 'script01.test.Page 1.Part 3';
      expect(testTree.elementHasEditState(part3Id), isFalse);
      expect(testTree.elementHasDataBinding(part3Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part3Id, Part, tester), isFalse);

      final part11Id = 'script01.test.Page 1.Panel 1.Part 1-1';
      expect(testTree.elementHasEditState(part11Id), isFalse);
      expect(testTree.elementHasDataBinding(part11Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part11Id, Part, tester), isFalse);

      final part12Id = 'script01.test.Page 1.Panel 1.Part 1-2';
      expect(testTree.elementHasEditState(part12Id), isFalse);
      expect(testTree.elementHasDataBinding(part12Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part12Id, Part, tester), isFalse);

      final part131Id = 'script01.test.Page 1.Panel 1.Panel 1-3.Part 1-3-1';
      expect(testTree.elementHasEditState(part131Id), isFalse);
      expect(testTree.elementHasDataBinding(part131Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part131Id, Part, tester), isFalse);

      final part132Id = 'script01.test.Page 1.Panel 1.Panel 1-3.Part 1-3-2';
      expect(testTree.elementHasEditState(part132Id), isFalse);
      expect(testTree.elementHasDataBinding(part132Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part132Id, Part, tester), isFalse);
    });
  });
}
