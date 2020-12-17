import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_mock_backend/pMockBackend.dart';
import 'package:precept_mock_backend/precept_mock_backend.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/script.dart';

import '../../helper/widgetTestTree.dart';

/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchenSink.html#static-page-with-overrides)
///

final PScript kitchenSink01 = PScript(
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
              PPanel(
                id: 'Panel 1',
                heading: PPanelHeading(title: 'Panel 2'),
                content: [
                  PString(id: 'Part 1-1', staticData: 'Part 1-1'),
                  PString(id: 'Part 1-2', staticData: 'Part 1-2'),
                  PPanel(
                    id: 'Panel 1-3',
                    isStatic: IsStatic.no,
                    backend: PMockBackend(instance: 'test'),
                    dataSource:
                        PDataGet(documentId: DocumentId(path: 'Account', itemId: 'objectId1')),
                    controlEdit: ControlEdit.thisOnly,
                    heading: PPanelHeading(title: 'Panel 2-1'),
                    content: [
                      PString(
                        property: 'firstName',
                        id: 'Part 1-3-1',
                        staticData: 'Part 1-3-1',
                      ),
                      PString(
                        property: 'lastName',
                        id: 'Part 1-3-2',
                        staticData: 'Part 1-3-2',
                      ),
                    ],
                  ),
                ],
              ),
              PString(id: 'Part 2', staticData: 'Part 2'),
              PString(id: 'Part 3', staticData: 'Part 3'),
            ],
          ),
        ),
      ],
    ),
  ],
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
      final PScript script = KitchenSinkTest().init(script: kitchenSink01);
      // when
      final widgetTree = MaterialApp(
          home: PageBuilder().build(
        config: script.components[0].routes[0].page,
      ));
      await tester.pumpWidget(widgetTree);
      testTree = WidgetTestTree(tester.allWidgets.toList());
      // then
      testTree.verify();

      expect(testTree.elementHasPanelState('Page 1'), isFalse);
      expect(testTree.elementHasEditState('Page 1'), isFalse);
      expect(testTree.elementHasDataBinding('Page 1'), isFalse);
      expect(testTree.elementHasDataSource('Page 1'), isFalse);

      expect(testTree.elementHasPanelState('Panel 1'), isTrue);
      expect(testTree.elementHasEditState('Panel 1'), isFalse);
      expect(testTree.elementHasDataBinding('Panel 1'), isFalse);
      expect(testTree.elementHasDataSource('Panel 1'), isFalse);

      expect(testTree.elementHasPanelState('Panel 1-3'), isTrue);
      expect(testTree.elementHasEditState('Panel 1-3'), isTrue);
      expect(testTree.elementHasDataBinding('Panel 1-3'), isTrue);
      expect(testTree.elementHasDataSource('Panel 1-3'), isTrue);

      expect(testTree.elementHasEditState('Part 2'), isFalse);
      expect(testTree.elementHasDataBinding('Part 2'), isFalse);
      expect(testTree.elementHasDataSource('Part 2'), isFalse);

      expect(testTree.elementHasEditState('Part 3'), isFalse);
      expect(testTree.elementHasDataBinding('Part 3'), isFalse);
      expect(testTree.elementHasDataSource('Part 3'), isFalse);

      expect(testTree.elementHasEditState('Part 1-1'), isFalse);
      expect(testTree.elementHasDataBinding('Part 1-1'), isFalse);
      expect(testTree.elementHasDataSource('Part 1-1'), isFalse);

      expect(testTree.elementHasEditState('Part 1-2'), isFalse);
      expect(testTree.elementHasDataBinding('Part 1-2'), isFalse);
      expect(testTree.elementHasDataSource('Part 1-2'), isFalse);

      expect(testTree.elementHasEditState('Part 1-3-1'), isFalse);
      expect(testTree.elementHasDataBinding('Part 1-3-1'), isFalse);
      expect(testTree.elementHasDataSource('Part 1-3-1'), isFalse);

      expect(testTree.elementHasEditState('Part 1-3-2'), isFalse);
      expect(testTree.elementHasDataBinding('Part 1-3-2'), isFalse);
      expect(testTree.elementHasDataSource('Part 1-3-2'), isFalse);
    });
  });
}
