import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/panel/static_panel.dart';
import 'package:precept_script/part/list_view.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/data/select/data.dart';
import 'package:precept_script/data/select/query.dart';
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
      final script = PScript(
        name: 'script',
        version: PVersion(number: 0),
        schema: PSchema(
          version: PVersion(number: 0),
          name: 'schema',
          documents: {'Person': PDocument(fields: {})},
          namedQueries: {
            'A person': PGetDocument(
              queryName: 'GetPerson',
              documentId: DocumentId(documentClass: 'x', objectId: 'x'),
              documentSchema: '',
            )
          },
        ),
        schemaSource: PSchemaSource(group: 'x', instance: 'dev'),
        pages: [
          PPageStatic(routes: ['home'],
            id: 'Home',
            caption: 'Home',
            children: [
              PText(caption: 'using caption'),
              PText(),
              PText(id: 'using id'),
              PPanelStatic(
                  caption: 'Top Panel',
                  heading: PPanelHeading(),
                  children: [
                    PText(),
                    PText(caption: 'with caption'),
                    PListView(property: 'eggs', caption: 'Eggs')
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
        'script.PSchemaSource',
        'script.PNoDataProvider',
        'script.Home',
        'script.Home.using caption',
        'script.Home.PText:1',
        'script.Home.using id',
        'script.Home.Top Panel',
        'script.Home.Top Panel.PPanelHeading',
        'script.Home.Top Panel.PText:0',
        'script.Home.Top Panel.with caption',
        'script.Home.Top Panel.Eggs',
      ]);

      // when
      walker = script.init(useCaptionsAsIds: false).initWalker;

      expect(walker.tracker, [
        'script',
        'script.PSchema',
        'script.PSchema.PDocument',
        'script.PSchema.PGetDocument',
        'script.PSchemaSource',
        'script.PNoDataProvider',
        'script.Home',
        'script.Home.PText:0',
        'script.Home.PText:1',
        'script.Home.using id',
        'script.Home.PPanelStatic:3',
        'script.Home.PPanelStatic:3.PPanelHeading',
        'script.Home.PPanelStatic:3.PText:0',
        'script.Home.PPanelStatic:3.PText:1',
        'script.Home.PPanelStatic:3.PListView:2'
      ]);
    });
  });
}
