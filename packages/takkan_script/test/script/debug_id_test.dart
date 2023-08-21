import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_schema/util/walker.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/panel/static_panel.dart';
import 'package:takkan_script/part/list_view.dart';
import 'package:takkan_script/part/text.dart';
import 'package:takkan_script/script/script.dart';
import 'package:test/test.dart';

void main() {
  group('Debug id structure', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final script = Script(
        name: 'script',
        version: const Version(versionIndex: 0),
        schema: Schema(
          version: const Version(versionIndex: 0),
          documents: {'Person': Document(fields: const {})},
        ),
        schemaSource: SchemaSource(group: 'x', instance: 'dev'),
        pages: [
          Page(
            name: 'home',
            id: 'Home',
            caption: 'Home',
            children: [
              Heading1(caption: 'using caption'),
              Heading2(),
              Heading3(id: 'using id'),
              PanelStatic(
                  caption: 'Top Panel',
                  heading: PanelHeading(),
                  children: [
                    Heading1(),
                    Heading2(caption: 'with caption'),
                    ListView(
                      property: 'eggs',
                      caption: 'Eggs',
                    ),
                  ])
            ],
          )
        ],
      );
      // when
      InitWalker walker = script.init().initWalker;
      // then
      expect(walker.tracker, [
        'script',
        'schema',
        'schema.Person',
        'schema.User',
        'schema.User.email',
        'schema.User.username',
        'schema.User.emailVerified',
        'schema.Role',
        'schema.Role.name',
        'script.SchemaSource',
        'script.NullDataProvider',
        'script.Home',
        'script.Home.using caption',
        'script.Home.Heading2:1',
        'script.Home.using id',
        'script.Home.Top Panel',
        'script.Home.Top Panel.PanelHeading',
        'script.Home.Top Panel.Heading1:0',
        'script.Home.Top Panel.with caption',
        'script.Home.Top Panel.Eggs'
      ]);

      // when
      walker = script.init(useCaptionsAsIds: false).initWalker;

      /// bug: https://gitlab.com/takkan/takkan_script/-/issues/52
      expect(walker.tracker, [
        'script',
        'Schema',
        'Schema.Document',
        'Schema.Document',
        'Schema.Document.FString:0',
        'Schema.Document.FString:1',
        'Schema.Document.FBoolean',
        'Schema.Document',
        'Schema.Document.FString',
        'script.schemaSource',
        'script.NullDataProvider',
        'script.Home',
        'script.Home.Heading1:0',
        'script.Home.Heading2:1',
        'script.Home.using id',
        'script.Home.PanelStatic:3',
        'script.Home.PanelStatic:3.PanelHeading',
        'script.Home.PanelStatic:3.Heading1:0',
        'script.Home.PanelStatic:3.Heading2:1',
        'script.Home.PanelStatic:3.ListView:2'
      ]);
    });
  });
}
