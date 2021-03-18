import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () async {
// ...

      final _httpLink = HttpLink(
        'https://parseapi.back4app.com/graphql',defaultHeaders:{
        "X-Parse-Application-Id": "at4dM5dN0oCRryJp7VtTccIKZY9l3GtfHre0Hoow",
        "X-Parse-Master-Key": "W7X6nqPOslfmfAfNRj9VxrMBXh0GvbbjAV900IyX",
        "X-Parse-Client-Key": "DPAF2DQCDVJ9Zmbp8vyaDhfC1XXjDdEveJqIwLYc"
      },
      );

      // final _authLink = AuthLink(
      //   getToken: () async => 'Bearer $YOUR_PERSONAL_ACCESS_TOKEN',
      // );

      Link _link = _httpLink;
      // Link _link = _authLink.concat(_httpLink);

      /// subscriptions must be split otherwise `HttpLink` will. swallow them
      // if (websocketEndpoint != null){
      //   final _wsLink = WebSocketLink(websockeEndpoint);
      //   _link = Link.split((request) => request.isSubscription, _wsLink, _link);
      // }

      final GraphQLClient client = GraphQLClient(
        /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(),
        link: _link,
      );

      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(
            r'''
                 query GetAccount {
  account(id: "wVdGK8TDXR") {
    id,
    category,
    accountNumber,
    createdAt,
    updatedAt
  }
}
               ''',
          ),
          variables: {

          },
        ),
      );

      if (result.hasException) {}
    });
  });
}
