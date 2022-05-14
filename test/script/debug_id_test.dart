import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/data/select/query.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/panel/static_panel.dart';
import 'package:precept_script/part/list_view.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
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
              documentSchema: '',
            )
          },
        ),
        schemaSource: SchemaSource(group: 'x', instance: 'dev'),
        pages: [
          PageStatic(
            routes: ['home'],
            id: 'Home',
            caption: 'Home',
            children: [
              Text(caption: 'using caption'),
              Text(),
              Text(id: 'using id'),
              PanelStatic(
                  caption: 'Top Panel',
                  heading: PanelHeading(),
                  children: [
                    Text(),
                    Text(caption: 'with caption'),
                    ListView(property: 'eggs', caption: 'Eggs')
                  ])
            ],
          )
        ],
      );
      // when
      InitWalker walker = script.init(useCaptionsAsIds: true).initWalker;
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
        'script.Home.Text:1',
        'script.Home.using id',
        'script.Home.Top Panel',
        'script.Home.Top Panel.PanelHeading',
        'script.Home.Top Panel.Text:0',
        'script.Home.Top Panel.with caption',
        'script.Home.Top Panel.Eggs',
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
        'script.Home.Text:0',
        'script.Home.Text:1',
        'script.Home.using id',
        'script.Home.PanelStatic:3',
        'script.Home.PanelStatic:3.PanelHeading',
        'script.Home.PanelStatic:3.Text:0',
        'script.Home.PanelStatic:3.Text:1',
        'script.Home.PanelStatic:3.ListView:2'
      ]);
    });
  });
}
