
import 'package:graphql/client.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/app/appConfig.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/graphqlDelegate.dart';
import 'package:precept_script/query/query.dart';

/// GraphQL implementations can vary considerably, and need provider-specific implementations
/// See the 'precept-back4app' package for an example
class DefaultGraphQLDataProviderDelegate
    implements GraphQLDataProviderDelegate {
  late GraphQLClient _client;
  final PGraphQLDelegate config;
  final PDataProvider providerConfig;
  final PreceptUser user;
  final Authenticator authenticator;

  DefaultGraphQLDataProviderDelegate({
    required this.config,
    required this.providerConfig,
    required this.user,
    required this.authenticator,
  });

  @override
  init(AppConfig appConfig) {
    HttpLink _httpLink = HttpLink(
      config.graphqlEndpoint,
      defaultHeaders: appConfig.headers(providerConfig),
    );

    _client = GraphQLClient(
      /// TODO: The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: _httpLink,
    );
  }

  GraphQLClient get client => _client;

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

  @override
  Future<Map<String, dynamic>> fetchItem(
      PGraphQLQuery queryConfig, Map<String, dynamic> variables) {
    // TODO: implement executeQuery
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchList(
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
    return results;
  }

  /// Uses REST API because it is easier than constructing a GraphQL mutation
  Future<bool> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
  }) {
    throw UnsupportedError('UpdateDocument not supported');
  }

  @override
  Authenticator createAuthenticator() {
    throw UnsupportedError(
        "An implementation specific dedicated 'createAuthenticator' method is required for a GraphQLDataProviderDelegate to support authentication");
  }
}
