import 'package:takkan_back4app_client/backend/back4app/provider/graphql_delegate.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/page/page.dart';
import 'package:test/test.dart';

void main() {
  group('GraphQLScriptBuilder', () {
    GraphQLScriptBuilder? builder;

    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      builder = GraphQLScriptBuilder();
    });

    tearDown(() {});

    test('create', () {
      // given
      final expected =
          r'''mutation CreateTakkanScript($input: CreateTakkanScriptFieldsInput){
  createTakkanScript(input: {fields: $input}){
    takkanScript{
      objectId
    }
  }
}''';
      // when
      final actual = builder?.buildCreateGQL(
          'TakkanScript', FieldSelector(), pScriptSchema0);
      // then

      expect(actual?.replaceAll(' ', ''), expected.replaceAll(' ', ''));
      expect(builder?.methodName, 'createTakkanScript');
      expect(builder?.selectionSet, 'takkanScript');
    });
    test('read', () {
      // given
      final expected = r'''query GetTakkanScript ($id: ID!){
  takkanScript(id: $id) {
    locale
  }
}''';
      // when
      final actual = builder?.buildReadGQL(
          DocumentId(documentClass: 'TakkanScript', objectId: 'test'),
          FieldSelector(fields: ['locale']),
          pScriptSchema0);
      // then

      expect(actual?.replaceAll(' ', ''), expected.replaceAll(' ', ''));
    });

    test('update', () {
      // given
      final expected =
          r'''mutation UpdateTakkanScript ($input: UpdateTakkanScriptInput!){
  updateTakkanScript(input: $input){
    takkanScript{
      updatedAt
      locale
    }
  }
}''';
      // when
      final actual = builder?.buildUpdateGQL(
          DocumentId(documentClass: 'TakkanScript', objectId: 'test'),
          FieldSelector(fields: ['locale']),
          pScriptSchema0);
      // then

      expect(actual?.replaceAll(' ', ''), expected.replaceAll(' ', ''));
    });
  });
}
