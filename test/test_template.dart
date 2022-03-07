import 'package:flutter_test/flutter_test.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_client/library/border_library.dart';
import 'package:precept_client/library/library.dart';
import 'package:precept_client/library/theme_lookup.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/select/single.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/schema/field/date.dart';
import 'package:precept_script/schema/field/double.dart';
import 'package:precept_script/schema/field/geo_position.dart';
import 'package:precept_script/schema/field/pointer.dart';
import 'package:precept_script/schema/field/post_code.dart';
import 'package:precept_script/schema/field/relation.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';

import 'helper/mock.dart';

initialData(String instanceName) {}

final validationSchema = PSchema(
  name: 'kitchenSink',
  documents: {
    'Account': PDocument(
      fields: {
        'objectId': PString(),
        'accountNumber': PString(),
        'category': PString(),
        'recordDate': PDate(),
        // 'customer': PDocument(
        //   fields: {
        //     'firstName': PString(),
        //     'lastName': PString(),
        //     'age': PInteger(),
        //   },
        // ),
        'address': PPointer(targetClass: '_User'),
        // 'notifications': PSelectBoolean(),
        'linkedAccounts': PRelation(targetClass: '_User'),
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
  version: PVersion(number: 0),
);

final PScript kitchenSinkValidation = PScript(
  name: 'data validation test',
  dataProvider: PDataProvider(
    instanceConfig: PInstance(group: 'fake', instance: 'fake'),
  ),
  pages: [
    PPageStatic(
      routes: ['/test'],
      pageType: Library.simpleKey,
      caption: 'Page 1',
      children: [
        PText(caption: 'Part 1', staticData: 'Part 1'),
        PPanel(
          dataSelectors: [
            PSingleById(
              objectId: 'wVdGK8TDXR',
              tag: 'fixed thing',
            ),
          ],
          caption: 'Panel 2',
          property: '',
          heading: PPanelHeading(),
          children: [
            PText(
              property: 'category',
              id: 'Part 2-1-2',
            ),
          ],
        ),
      ],
    ),
  ],
  schema: validationSchema,
  version: PVersion(number: 0),
);

/// See [developer guide]()
void main() {
  group('Validation process', () {
    setUpAll(() {
      dataProviderLibrary.register(
          type: 'mock', builder: (dp) => MockDataProvider());
      getIt.reset();
      getIt.registerFactory<ThemeLookup>(() => DefaultThemeLookup());
      getIt.registerSingleton<BorderLibrary>(
          BorderLibrary(modules: [PreceptBorderLibraryModule()]));
    });

    tearDownAll(() {});

    setUp(() {
      initialData('mock1');
    });

    tearDown(() {});

    // testWidgets('??? ', (WidgetTester tester) async {
    //   // given
    //   // when
    //   final app = MaterialApp(
    //       home: PreceptPage(
    //     config: kitchenSinkValidation.routes['/test']!, dataConnector: null,
    //   ));
    //
    //   await tester.pumpWidget(app);
    //   await tester.pumpAndSettle(const Duration(seconds: 1));
    //   final testTree = WidgetTestTree(
    //       kitchenSinkValidation, tester.allWidgets.toList(),
    //       pages: 1, panels: 1, parts: 2);
    //   testTree.verify();
    //   // then
    //
    //   final EditAction editAction = testTree.widgets[191] as EditAction;
    //   editAction.doAction(MockBuildContext());
    //   expect(1, 1);
    // });
  });
}
