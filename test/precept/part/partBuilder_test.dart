import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/library/backendLibrary.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/mutable/temporaryDocument.dart';
import 'package:precept_client/precept/panel/panel.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:precept_client/precept/script/themeLookup.dart';
import 'package:precept_mock_backend/pMockBackend.dart';
import 'package:precept_mock_backend/precept_mock_backend.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/part/options.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

import '../../helper/mock.dart';

void main() {
  group('PartBuilder build', () {

    setUp(() {mockBackend.initialData(
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
    );});

    testWidgets('build - static', (WidgetTester tester) async {
      // given
      partLibrary.init();
      final script = PScript(
          backend: PBackend(),
          isStatic: IsStatic.yes,
          dataSource: PDataGet(),
          components: [
            PComponent(
              routes: [
                PRoute(
                  path: null,
                  page: PPage(
                    content: [
                      PPanel(
                        controlEdit: ControlEdit.thisOnly,
                        content: [
                          PString(staticData: "static text", caption:'static'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ]);
      final component = script.components[0];
      final route = component.routes[0];
      final page = route.page;
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;

      BuildContext context = MockBuildContext();
      // when
      script.init();
      // when
      final StringPart b =
          PartBuilder().build(context: context, callingType: PString, config: part);
      // simulate higher level to enable inflate
      final cnp = Directionality(textDirection: TextDirection.ltr, child: b);
      // then

      await tester.pumpWidget(cnp);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(b, isA<StringPart>(),
          reason: "Static, only the Part is generated, should not look for EditState");
      final widgetList = tester.allWidgets.toList();
      expect(widgetList[10], isA<Text>());
      Text t = widgetList[10];
      expect(t.data, "static text");
    });

    testWidgets('data, controlEdit==false', (WidgetTester tester) async {
      // given
      getIt.reset();
      getIt.registerFactory<ThemeLookup>(() => DefaultThemeLookup());
      getIt.registerFactory<TemporaryDocument>(() => DefaultTemporaryDocument());
      partLibrary.init();
      backendLibrary.init();
      final Map<String, dynamic> data = {'name': 'Hugo', 'age': 23};
      final rootBinding = RootBinding(data: data, id: 'test');
      final script = PScript(backend: PMockBackend(instance: 'test'), dataSource: PDataGet(documentId: (DocumentId(path:'Account',itemId: 'objectId1'))), components: [
        PComponent(
          routes: [
            PRoute(
              path: null,
              page: PPage(
                controlEdit: ControlEdit.thisAndBelow,
                content: [
                  PPanel(
                    content: [
                      PString(
                        property: 'name',
                        controlEdit: ControlEdit.noEdit,
                        readModeOptions: PReadModeOptions(showCaption: false),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ]);
      final component = script.components[0];
      final route = component.routes[0];
      final page = route.page;
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;

      BuildContext context = MockBuildContext();
      // when
      script.validate();
      // when
      // final StringPart b = PartBuilder().build(context:context,callingType:PString, config: part);
      // simulate higher level to enable inflate
      final testTree = Directionality(
          textDirection: TextDirection.ltr,
          child: ChangeNotifierProvider<DataSource>(create: (_)=> DataSource(config: script.dataSource, canEdit: true,readOnlyMode: false),
            child: ChangeNotifierProvider<DataBinding>(
              create: (_) => DataBinding(binding: rootBinding),
              child: ChangeNotifierProvider<EditState>(
                create: (_) => EditState(),
                child: ChangeNotifierProvider<PanelState>(
                    create: (_) => PanelState(config: panel),
                    child: Panel(
                      config: panel,
                    )),
              ),
            ),
          ));
      // then

      await tester.pumpWidget(testTree);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      // expect(b, isA<StringPart>(), reason: 'Not controlling edit, refer to higher EditState');
      final widgetList = tester.allWidgets.toList();
      expect(widgetList[15], isA<Text>());
      Text t = widgetList[15];
      expect(t.data, 'Hugo');
    });

    testWidgets('data, controlEdit==true', (WidgetTester tester) async {
      // given
      partLibrary.init();
      final Map<String, dynamic> data = {'name': 'Hugo', 'age': 23};
      final rootBinding = RootBinding(data: data, id: 'test');
      final script = PScript(backend: PBackend(), dataSource: PDataGet(), components: [
        PComponent(
          routes: [
            PRoute(
              path: null,
              page: PPage(
                content: [
                  PPanel(
                    content: [
                      PString(
                        property: 'name',
                        controlEdit: ControlEdit.thisOnly,
                        readModeOptions: PReadModeOptions(showCaption: false),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ]);
      final component = script.components[0];
      final route = component.routes[0];
      final page = route.page;
      final panel = page.content[0] as PPanel;
      final part = panel.content[0] as PPart;
      // when
      script.init();
      // when
      final ChangeNotifierProvider<EditState> b =
          PartBuilder().build(callingType: PString, config: part);
      // simulate higher level to enable inflate
      final testTree = Directionality(
          textDirection: TextDirection.ltr,
          child: ChangeNotifierProvider<DataBinding>(
            create: (_) => DataBinding(binding: rootBinding),
            child: b,
          ));
      // then

      await tester.pumpWidget(testTree);
      expect(b, isA<ChangeNotifierProvider<EditState>>(),
          reason: 'Controlling edit, has its own EditState');
      final widgetList = tester.allWidgets.toList();
      expect(widgetList[7], isA<Text>());
      Text t = widgetList[7];
      expect(t.data, 'Hugo');
    });
  });
}


