import 'dart:ui';

import 'package:graphql/client.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/graphqlDelegate.dart';
import 'package:precept_script/query/fieldSelector.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';

/// GraphQL implementations can vary considerably, and may need provider-specific implementations
/// See the 'precept-back4app' package for an example
class DefaultGraphQLDataProviderDelegate
    implements GraphQLDataProviderDelegate {
  late GraphQLClient _client;
  late DataProvider parent;

  DefaultGraphQLDataProviderDelegate();

  @override
  init(AppConfig appConfig, DataProvider parent) async {
    this.parent = parent;
    if (parent.config.graphQLDelegate == null) {
      throw PreceptException(
          'GraphQLDelegate cannot be used without configuration');
    }

    HttpLink _httpLink = HttpLink(
      '${appConfig.serverUrl(parent.config)}${config.graphqlEndpoint}',
      defaultHeaders: appConfig.headers(parent.config, config),
    );

    _client = GraphQLClient(
      /// TODO: The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: _httpLink,
    );
  }

  GraphQLClient get client => _client;

  PreceptUser get user => parent.user; // safe only after init called

  Authenticator get authenticator =>
      parent.authenticator; // safe only after init called

  PGraphQL get config =>
      parent.config.graphQLDelegate as PGraphQL; // safe only after init called

  @override
  setSessionToken(String token) {
    if (authenticator.isAuthenticated) {
      HttpLink link = _client.link as HttpLink;
      if (user.sessionToken != null) {
        link.defaultHeaders[config.sessionTokenKey] = user.sessionToken!;
      } else {
        throw PreceptException(
            'Session token should not be null at this stage');
      }
    }
  }

  @override
  String assembleScript(
      PGraphQLQuery queryConfig, Map<String, dynamic> pageArguments) {
    return queryConfig.script;
  }

  Future<ReadResultItem> latestScript(
      {required Locale locale,
      required int fromVersion,
      required String name}) {
    throw UnimplementedError();
  }

  @override
  Future<ReadResultItem> fetchItem(
      PGraphQLQuery queryConfig, Map<String, dynamic> variables) {
    // TODO: implement executeQuery
    throw UnimplementedError();
  }

  @override
  Future<ReadResultList> fetchList(
      PGraphQLQuery queryConfig, Map<String, dynamic> variables) async {
    final queryOptions =
        QueryOptions(document: gql(queryConfig.script), variables: variables);
    final QueryResult response = await _client.query(queryOptions);

    // TODO: is 'typename' Back4App specific?
    Map? rawData;
    for (var entry in response.data!.entries) {
      if (entry.key != '__typename') {
        rawData = entry.value;
      }
    }

    if (rawData == null) {
      throw PreceptException('data is missing');
    }
    final List edges = rawData['edges'];
    final List<Map<String, dynamic>> results = List.empty(growable: true);
    for (var e in edges) {
      results.add(e['node']);
    }
    final documentSchema = parent.documentSchemaFromQuery(
        querySchemaName: queryConfig.querySchemaName);
    return ReadResultList(
      success: true,
      path: documentSchema.name,
      queryReturnType: QueryReturnType.futureList,
      data: results,
    );
  }

  /// See [PDocument.updateDocument]
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> data,
    FieldSelector fieldSelector = const FieldSelector(),
  }) {
    throw UnsupportedError('UpdateDocument not supported');
  }

  @override
  Future<DeleteResult> deleteDocument({required DocumentId documentId}) {
    throw UnimplementedError();
  }

  /// See [PDocument.createDocument]
  @override
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
    FieldSelector fieldSelector = const FieldSelector(),
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
  }) {
    throw UnimplementedError();
  }
}
