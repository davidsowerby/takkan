import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_client/library/library.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

import '../../helper/fake.dart';
import '../../helper/mock.dart';
import '../../helper/widgetTestTree.dart';

/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchenSink.html#static-page-with-overrides)
///

final PScript kitchenSink01 = PScript(
  name: 'script01',
  isStatic: IsStatic.yes,
  routes: {
    'test': PPage(
      pageType: Library.simpleKey,
      title: 'Page 1',
      content: [
        PPanel(
          caption: 'Panel 1',
          heading: PPanelHeading(),
          content: [
            PText(
              pid: 'Part 1-1',
              staticData: 'Part 1-1',
            ),
            PText(
              pid: 'Part 1-2',
              staticData: 'Part 1-2',
            ),
            PPanel(
              caption: 'Panel 1-3',
              isStatic: IsStatic.no,
              dataProvider: PFakeDataProvider(
                schema: kitchenSinkSchema01,
                instanceName: 'mock',
                configSource: PConfigSource(segment: 'fake', instance: 'fake'),
              ),
              query: PGetDocument(
                documentId: DocumentId(
                  path: 'Account',
                  itemId: 'objectId1',
                ),
                documentSchema: 'Account',
              ),
              controlEdit: ControlEdit.thisOnly,
              property: '',
              content: [
                PPart(
                  readTraitName: PText.defaultReadTrait,
                  property: 'firstName',
                  caption: 'Part 1-3-1',
                  staticData: 'Part 1-3-1',
                ),
                PPart(
                  readTraitName: PText.defaultReadTrait,
                  property: 'lastName',
                  caption: 'Part 1-3-2',
                  staticData: 'Part 1-3-2',
                ),
              ],
            ),
          ],
        ),
        PPart(
            readTraitName: PText.defaultReadTrait,
            pid: 'Part 2',
            staticData: 'Part 2',
            caption: 'Part 2'),
        PPart(
            readTraitName: PText.defaultReadTrait,
            pid: 'Part 3',
            staticData: 'Part 3',
            caption: 'Part 3'),
      ],
    ),
  },
);

final PSchema kitchenSinkSchema01 = PSchema(
  name: 'schema01',
  documents: {
    'Account': PDocument(
      fields: {
        'firstName': PString(),
        'lastName': PString(),
      },
    ),
  },
);

void main() {
  group('Static Page with Overrides (kitchen-sink-01)', () {
    late WidgetTestTree testTree;
    final AppConfig appConfig = MockAppConfig();

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
      final PScript script = KitchenSinkTest().init(
        script: kitchenSink01,
        useCaptionsAsIds: true,
        appConfig: MockAppConfig(),
      );

      // when
      final widgetTree = MaterialApp(
          home: PreceptPage(
            config: script.routes['test']!,
      ));
      await tester.pumpWidget(widgetTree);
      final pumps = await tester.pumpAndSettle();
      print('pumps: $pumps');

      testTree = WidgetTestTree(script, tester.allWidgets.toList(), pages: 1, panels: 2, parts: 6);
      // then
      testTree.verify();

      final pageId = 'script01.test';
      expect(testTree.elementHasEditState(pageId), isFalse);
      expect(testTree.elementHasDataBinding(pageId, PreceptPage, tester), isFalse);
      expect(testTree.elementHasDataSource(pageId, PreceptPage, tester), isFalse);

      final panel1Id = 'script01.test.Panel 1';
      expect(testTree.elementHasEditState(panel1Id), isFalse);
      expect(testTree.elementHasDataBinding(panel1Id, Panel, tester), isFalse);
      expect(testTree.elementHasDataSource(panel1Id, Panel, tester), isFalse);

      final panel13Id = 'script01.test.Panel 1.Panel 1-3';
      expect(testTree.elementHasEditState(panel13Id), isTrue);
      expect(testTree.elementHasDataBinding(panel13Id, Panel, tester), isTrue);
      expect(testTree.elementHasDataSource(panel13Id, Panel, tester), isTrue);

      final part2Id = 'script01.test.Part 2';
      expect(testTree.elementHasEditState(part2Id), isFalse);
      expect(testTree.elementHasDataBinding(part2Id, PreceptPage, tester), isFalse);
      expect(testTree.elementHasDataSource(part2Id, PreceptPage, tester), isFalse);

      final part3Id = 'script01.test.Part 3';
      expect(testTree.elementHasEditState(part3Id), isFalse);
      expect(testTree.elementHasDataBinding(part3Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part3Id, Part, tester), isFalse);

      final part11Id = 'script01.test.Panel 1.Part 1-1';
      expect(testTree.elementHasEditState(part11Id), isFalse);
      expect(testTree.elementHasDataBinding(part11Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part11Id, Part, tester), isFalse);

      final part12Id = 'script01.test.Panel 1.Part 1-2';
      expect(testTree.elementHasEditState(part12Id), isFalse);
      expect(testTree.elementHasDataBinding(part12Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part12Id, Part, tester), isFalse);

      final part131Id = 'script01.test.Panel 1.Panel 1-3.Part 1-3-1';
      expect(testTree.elementHasEditState(part131Id), isFalse);
      expect(testTree.elementHasDataBinding(part131Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part131Id, Part, tester), isFalse);

      final part132Id = 'script01.test.Panel 1.Panel 1-3.Part 1-3-2';
      expect(testTree.elementHasEditState(part132Id), isFalse);
      expect(testTree.elementHasDataBinding(part132Id, Part, tester), isFalse);
      expect(testTree.elementHasDataSource(part132Id, Part, tester), isFalse);
    });
  });
}
