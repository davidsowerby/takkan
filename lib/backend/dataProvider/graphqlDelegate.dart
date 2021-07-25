import 'dart:ui';

import 'package:graphql/client.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/dataProvider/fieldSelector.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/graphqlDelegate.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

/// GraphQL implementations can vary considerably, and may need provider-specific implementations
/// See the 'precept-back4app' package for an example
class DefaultGraphQLDataProviderDelegate
    implements GraphQLDataProviderDelegate {
  late GraphQLClient _client;
  late Authenticator _authenticator;
  final DataProvider parent;

  DefaultGraphQLDataProviderDelegate(this.parent);

  @override
  init(AppConfig appConfig) async {
    if (parent.config.graphQLDelegate == null) {
      throw PreceptException(
          'GraphQLDelegate cannot be used without configuration');
    }

    if (parent.config.authenticatorDelegate == CloudInterface.graphQL) {
      _authenticator = await createAuthenticator();
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

  PreceptUser get user => _authenticator.user;

  Authenticator get authenticator => _authenticator;

  PGraphQL get config =>
      parent.config.graphQLDelegate as PGraphQL; // safe after init called

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
  String assembleScript(PGraphQLQuery queryConfig,
      Map<String, dynamic> pageArguments) {
    return queryConfig.script;
  }

  Future<UpdateResult> uploadPreceptScript({
    required PScript script,
    required Locale locale,
    bool incrementVersion = false,
  }) {
    throw UnimplementedError();
  }

  Future<ReadResult> latestScript({required Locale locale,
    required int fromVersion,
    required String name}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> fetchItem(PGraphQLQuery queryConfig,
      Map<String, dynamic> variables) {
    // TODO: implement executeQuery
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchList(PGraphQLQuery queryConfig, Map<String, dynamic> variables) async {
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
    return results;
  }

  /// See [PDocument.updateDocument]
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> data,
  }) {
    throw UnsupportedError('UpdateDocument not supported');
  }

  @override
  Future<Authenticator> createAuthenticator() {
    throw UnsupportedError(
        "An implementation specific dedicated 'createAuthenticator' method is required for a GraphQLDataProviderDelegate to support authentication");
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
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ReadResult> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
  }) {
    throw UnimplementedError();
  }
}
