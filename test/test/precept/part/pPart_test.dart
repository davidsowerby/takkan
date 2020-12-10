import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/part/options/options.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:precept_client/precept/script/backend.dart';
import 'package:precept_client/precept/script/data.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:provider/provider.dart';

void main() {
  group('PartBuilder build', () {
    testWidgets('build - static', (WidgetTester tester) async {
      // given
      partLibrary.init();
      final script =
          PScript(backend: PBackend(), isStatic: Triple.yes, dataSource: PDataSource(), components: [
        PComponent(
          routes: [
            PRoute(
              path: null,
              page: PPage(
                content: [
                  PPanel(
                    controlEdit: ControlEdit.thisOnly,
                    content: [
                      PString(staticData: "static text"),
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
      final StringPart b = PartBuilder().build(callingType: PString,config:part);
      // simulate higher level to enable inflate
      final cnp = Directionality(textDirection: TextDirection.ltr, child: b);
      // then

      await tester.pumpWidget(cnp);
      expect(b, isA<StringPart>(),
          reason: "Static, only the Part is generated, should not look for EditState");
      final widgetList = tester.allWidgets.toList();
      expect(widgetList[3], isA<Text>());
      Text t = widgetList[3];
      expect(t.data, "static text");
    });

    testWidgets('data, controlEdit==false', (WidgetTester tester) async {
      // given
      partLibrary.init();
      final Map<String, dynamic> data = {'name': 'Hugo', 'age': 23};
      final rootBinding = RootBinding(data: data, id: 'test');
      final script = PScript(backend: PBackend(), dataSource: PDataSource(), components: [
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
      // when
      script.init();
      // when
      final StringPart b = PartBuilder().build(callingType:PString, config: part);
      // simulate higher level to enable inflate
      final testTree = Directionality(
          textDirection: TextDirection.ltr,
          child: ChangeNotifierProvider<DataBinding>(
            create: (_) => DataBinding(binding: rootBinding),
            child: ChangeNotifierProvider<EditState>(
              create: (_) => EditState(),
              child: b,
            ),
          ));
      // then

      await tester.pumpWidget(testTree);
      expect(b, isA<StringPart>(), reason: 'Not controlling edit, refer to higher EditState');
      final widgetList = tester.allWidgets.toList();
      expect(widgetList[7], isA<Text>());
      Text t = widgetList[7];
      expect(t.data, 'Hugo');
    });

    testWidgets('data, controlEdit==true', (WidgetTester tester) async {
      // given
      partLibrary.init();
      final Map<String, dynamic> data = {'name': 'Hugo', 'age': 23};
      final rootBinding = RootBinding(data: data, id: 'test');
      final script = PScript(backend: PBackend(), dataSource: PDataSource(), components: [
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
      final ChangeNotifierProvider<EditState> b = PartBuilder().build(callingType:PString, config:part);
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
