import 'package:graphql/client.dart';
import "package:http/http.dart" as http;
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/delegate.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/provider/graphql_delegate.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/schema/schema.dart';

/// GraphQL implementations can vary considerably, and may need provider-specific implementations
/// See the 'takkan-back4app' package for an example
class DefaultGraphQLDataProviderDelegate
    implements GraphQLDataProviderDelegate {
  late GraphQLClient _client;
  late IDataProvider parent;

  DefaultGraphQLDataProviderDelegate();

  @override
  init(InstanceConfig instanceConfig, IDataProvider parent) async {
    this.parent = parent;
    if (parent.config.graphQLDelegate == null) {
      throw TakkanException(
          'GraphQLDelegate cannot be used without configuration');
    }

    HttpLink _httpLink = HttpLink(
      '${instanceConfig.graphqlEndpoint}',
      defaultHeaders: instanceConfig.headers,
      httpResponseDecoder: httpResponseDecoder,
    );

    _client = GraphQLClient(
      /// TODO: The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: _httpLink,
    );
  }

  GraphQLClient get client => _client;

  TakkanUser get user => parent.user; // safe only after init called

  Authenticator get authenticator =>
      parent.authenticator; // safe only after init called

  GraphQL get config =>
      parent.config.graphQLDelegate as GraphQL; // safe only after init called

  @override
  setSessionToken(String token) {
    if (authenticator.isAuthenticated) {
      HttpLink link = _client.link as HttpLink;
      if (user.sessionToken != null) {
        link.defaultHeaders[parent.sessionTokenKey] = user.sessionToken!;
      } else {
        throw TakkanException('Session token should not be null at this stage');
      }
    }
  }

  @override
  String assembleScript(
      GraphQLQuery queryConfig, Map<String, dynamic> pageArguments) {
    return queryConfig.queryScript;
  }

  Future<ReadResultItem> latestScript(
      {required String locale,
      required int fromVersion,
      required String name}) {
    throw UnimplementedError();
  }

  @override
  Future<ReadResultItem> fetchItem(
      GraphQLQuery queryConfig, Map<String, dynamic> variables) {
    // TODO: implement executeQuery
    throw UnimplementedError();
  }

  @override
  Future<ReadResultList> fetchList(
      GraphQLQuery queryConfig, Map<String, dynamic> variables) async {
    final queryOptions = QueryOptions(
        document: gql(queryConfig.queryScript), variables: variables);
    final QueryResult response = await _client.query(queryOptions);

    // TODO: is 'typename' Back4App specific?
    Map? rawData;
    for (var entry in response.data!.entries) {
      if (entry.key != '__typename') {
        rawData = entry.value;
      }
    }

    if (rawData == null) {
      throw TakkanException('data is missing');
    }
    final List edges = rawData['edges'];
    final List<Map<String, dynamic>> results = List.empty(growable: true);
    for (var e in edges) {
      results.add(e['node']);
    }
    return ReadResultList(
      success: true,
      documentClass: queryConfig.documentSchema,
      queryReturnType: QueryReturnType.futureList,
      data: results,
    );
  }

  /// See [Document.updateDocument]
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

  /// See [Document.createDocument]
  @override
  Future<CreateResult> createDocument({
    required String documentClass,
    required Map<String, dynamic> data,
    required String documentIdKey,
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

Map<String, dynamic>? httpResponseDecoder(http.Response httpResponse) {
  final bits = httpResponse.bodyBytes;
  final b = httpResponse.body;
  print('wait');
  return Map();
}
