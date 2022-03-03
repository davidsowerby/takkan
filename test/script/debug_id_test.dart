import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/list_view.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/query/query.dart';
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
              documentId: DocumentId(path: 'x', itemId: 'x'),
              documentSchema: '',
            )
          },
        ),
        schemaSource: PSchemaSource(group: 'x', instance: 'dev'),
        routes: {
          'home': PPage(
            title: 'Home',
            content: [
              PText(caption: 'using caption'),
              PText(),
              PText(id: 'using id'),
              PPanel(caption: 'Top Panel', heading: PPanelHeading(), content: [
                PText(),
                PText(caption: 'with caption'),
                PListView(property: 'eggs', caption: 'Eggs')
              ])
            ],
          )
        },
      );
      // when
      InitWalker walker = script.init(useCaptionsAsIds: true);
      // then
      expect(walker.tracker, [
        'script',
        'script.schema',
        'script.schema.Person',
        'script.schema.GetPerson',
        'script.PSchemaSource',
        'script.PNoDataProvider',
        'script.home',
        'script.home.using caption',
        'script.home.PText:1',
        'script.home.using id',
        'script.home.Top Panel',
        'script.home.Top Panel.PPanelHeading',
        'script.home.Top Panel.PText:0',
        'script.home.Top Panel.with caption',
        'script.home.Top Panel.Eggs',
      ]);

      // when
      walker = script.init(useCaptionsAsIds: false);

      expect(walker.tracker, [
        'script',
        'script.PSchema',
        'script.PSchema.PDocument',
        'script.PSchema.PGetDocument',
        'script.PSchemaSource',
        'script.PNoDataProvider',
        'script.home',
        'script.home.PText:0',
        'script.home.PText:1',
        'script.home.using id',
        'script.home.PPanel:3',
        'script.home.PPanel:3.PPanelHeading',
        'script.home.PPanel:3.PText:0',
        'script.home.PPanel:3.PText:1',
        'script.home.PPanel:3.PListView:2',
      ]);
    });
  });
}
