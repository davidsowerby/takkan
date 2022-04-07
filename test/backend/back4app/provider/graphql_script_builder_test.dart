import 'package:precept_back4app_client/backend/back4app/provider/graphql_delegate.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/data/select/field_selector.dart';
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
          r'''mutation CreatePreceptScript($input: CreatePreceptScriptFieldsInput){
  createPreceptScript(input: {fields: $input}){
    preceptScript{
      objectId
    }
  }
}''';
      // when
      final actual = builder?.buildCreateGQL(
          'PreceptScript', FieldSelector(), pScriptSchema0);
      // then

      expect(actual?.replaceAll(' ', ''), expected.replaceAll(' ', ''));
      expect(builder?.methodName, 'createPreceptScript');
      expect(builder?.selectionSet, 'preceptScript');
    });
    test('read', () {
      // given
      final expected = r'''query GetPreceptScript ($id: ID!){
  preceptScript(id: $id) {
    locale
  }
}''';
      // when
      final actual = builder?.buildReadGQL(
          DocumentId(documentClass: 'PreceptScript', objectId: 'test'),
          FieldSelector(fields: ['locale']),
          pScriptSchema0);
      // then

      expect(actual?.replaceAll(' ', ''), expected.replaceAll(' ', ''));
    });

    test('update', () {
      // given
      final expected =
          r'''mutation UpdatePreceptScript ($input: UpdatePreceptScriptInput!){
  updatePreceptScript(input: $input){
    preceptScript{
      updatedAt
      locale
    }
  }
}''';
      // when
      final actual = builder?.buildUpdateGQL(
          DocumentId(documentClass: 'PreceptScript', objectId: 'test'),
          FieldSelector(fields: ['locale']),
          pScriptSchema0);
      // then

      expect(actual?.replaceAll(' ', ''), expected.replaceAll(' ', ''));
    });
  });
}
