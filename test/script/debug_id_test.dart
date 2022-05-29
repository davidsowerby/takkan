import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/script/takkan_item.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/panel/static_panel.dart';
import 'package:takkan_script/part/list_view.dart';
import 'package:takkan_script/part/text.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
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
        version: Version(number: 0),
        schema: Schema(
          version: Version(number: 0),
          name: 'schema',
          documents: {'Person': Document(fields: {})},
          namedQueries: {
            'A person': GetDocument(
              queryName: 'GetPerson',
              documentId: DocumentId(documentClass: 'x', objectId: 'x'),
            )
          },
        ),
        schemaSource: SchemaSource(group: 'x', instance: 'dev'),
        pages: [
          Page(
            dataSelectors: [NoData(tag: 'home')],
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
                    ListView(property: 'eggs', caption: 'Eggs', traitName: 'ListView')
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
        'script.schema',
        'script.schema.Person',
        'script.schema.GetPerson',
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

      expect(walker.tracker, [
        'script',
        'script.Schema',
        'script.Schema.Document',
        'script.Schema.GetDocument',
        'script.SchemaSource',
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
