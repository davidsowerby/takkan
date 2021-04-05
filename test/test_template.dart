import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/common/action/editSave.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/library/borderLibrary.dart';
import 'package:precept_client/library/library.dart';
import 'package:precept_client/library/themeLookup.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_mock_backend/pMockBackend.dart';
import 'package:precept_mock_backend/precept_mock_backend.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/particle/text.dart';
import 'package:precept_script/particle/textBox.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/field/date.dart';
import 'package:precept_script/schema/field/double.dart';
import 'package:precept_script/schema/field/geoPosition.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/pointer.dart';
import 'package:precept_script/schema/field/postCode.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

import 'helper/widgetTestTree.dart';

initialData(String instanceName) {
  mockBackend.initialData(
    instanceName: instanceName,
    tables: [
      MockTable(
        name: 'Account',
        rows: [
          MockRow(
            objectId: 'wVdGK8TDXR',
            columns: {
              'accountNumber': '1',
              'category': 'permanent',
              'customer': {
                'firstName': 'David',
                'lastName': 'Sowerby',
              }
            },
          ),
          MockRow(
            objectId: 'objectId2',
            columns: {
              'accountNumber': '2',
              'category': 'temporary',
              'customer': {
                'firstName': 'Monty',
                'lastName': 'Python',
              },
            },
          ),
        ],
      ),
    ],
  );
}

final validationSchema = PSchema(
  name: 'kitchenSink',
  documents: {
    'Account': PDocument(
      fields: {
        'objectId': PString(),
        'accountNumber': PString(),
        'category': PString(),
        'recordDate': PDate(),
        'customer': PDocument(
          fields: {
            'firstName': PString(),
            'lastName': PString(),
            'age': PInteger(),
          },
        ),
        'address': PPointer(),
        // 'notifications': PSelectBoolean(),
        'linkedAccounts': PPointer(),
        'joinDate': PDate(),
        'average': PDouble(),
        // 'colourChoices': PSelectString(),
        'successRate': PDouble(),
      },
    ),
    'Address': PDocument(
      fields: {
        'firstLine': PString(),
        'secondLine': PString(),
        // 'country': PSelectString(),
        'location': PGeoPosition(),
        // 'region': PGeoRegion(),
        'postCode': PPostCode(),
      },
    ),
  },
);

final PScript kitchenSinkValidation = PScript(
  name: 'data validation test',
  dataProvider: PMockDataProvider(
    instanceName: 'mock1',
    schema: validationSchema,
  ),
  routes: {
    '/test': PRoute(
      page: PPage(
        pageType: Library.simpleKey,
        title: 'Page 1',
        content: [
          PPart(caption: 'Part 1', staticData: 'Part 1', read: PText(), isStatic: IsStatic.yes),
          PPanel(
            query: PGet(
              documentId: DocumentId(path: 'Account', itemId: 'wVdGK8TDXR'),
            ),
            caption: 'Panel 2',
            property: '',
            heading: PPanelHeading(),
            content: [
              PPart(
                property: 'category',
                read: PText(showCaption: false),
                edit: PTextBox(),
                id: 'Part 2-1-2',
              ),
            ],
          ),
        ],
      ),
    ),
  },
);

/// See [developer guide]()
void main() {
  group('Validation process', () {
    setUpAll(() {
      PMockDataProvider.register();
      getIt.reset();
      getIt.registerFactory<TemporaryDocument>(() => DefaultTemporaryDocument());
      getIt.registerFactory<ThemeLookup>(() => DefaultThemeLookup());
      getIt
          .registerSingleton<BorderLibrary>(BorderLibrary(modules: [PreceptBorderLibraryModule()]));
    });

    tearDownAll(() {});

    setUp(() {
      initialData('mock1');
    });

    tearDown(() {});

    testWidgets('??? ', (WidgetTester tester) async {
      // given
      // when
      final app = MaterialApp(
          home: PreceptPage(
        config: kitchenSinkValidation.routes['/test'].page,
      ));

      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final testTree = WidgetTestTree(kitchenSinkValidation, tester.allWidgets.toList(),
          pages: 1, panels: 1, parts: 2);
      testTree.verify();
      // then

      final EditAction editAction = testTree.widgets[191];
      editAction.doAction(null);
      expect(1, 1);
    });
  });
}
