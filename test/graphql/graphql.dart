import 'package:flutter_test/flutter_test.dart';
import 'package:precept_backend/backend/dataProvider/graphqlDataProvider.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/query.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () async {
      // given
      final PGraphQLDataProvider config = PGraphQLDataProvider();
      config.appConfig = appConfig;
      final provider = GraphQLDataProvider<PGraphQLDataProvider>(config: config);

      // when
      var s = r'In a raw string, not even $n gets special treatment.';
      final result = await provider.gQuery(
        query: PGQuery(
          variables: {"id": "wVdGK8TDXR"},
          script:
              'query GetAccount(\$id : ID!) {account(id: \$id) {id,objectId,category,accountNumber,createdAt,updatedAt}}',
          // r'query GetAccount($id : ID!) {account(id: $id) {id,objectId,category,accountNumber,createdAt,updatedAt}}',
        ),
      );
      // then
      expect(result.data['account']['category'], 'ue2y');

      final result2 = await provider.pQuery(
        query: PPQuery(
          types: {'id': 'ID!'},
          variables: {"id": "wVdGK8TDXR"},
          table: 'Account',
          fields: 'id,category,accountNumber,createdAt,updatedAt',
        ),
      );
      expect(result2.data['account']['category'], 'ue2y');
    });
  });
}

final appConfig = {
  "X-Parse-Application-Id": "xLWKrOqVNy3O1u3z9ovoalO2XFuKQn0NlHPksJV6",
  "X-Parse-Client-Key": "Ib1NDOh4ph4fkCci0IIxWF01flSxhpJf6FO1gAkQ",
  "serverUrl": "https://parseapi.back4app.com/",
  "graphqlEndpoint": "https://parseapi.back4app.com/graphql/"
};
