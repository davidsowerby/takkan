import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/graphqlDelegate.dart';
import 'package:precept_backend/backend/dataProvider/fieldSelector.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/script/script.dart';

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
          DocumentId(path: 'PreceptScript', itemId: 'test'),
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
          DocumentId(path: 'PreceptScript', itemId: 'test'),
          FieldSelector(fields: ['locale']),
          pScriptSchema0);
      // then

      expect(actual?.replaceAll(' ', ''), expected.replaceAll(' ', ''));
    });
  });
}
