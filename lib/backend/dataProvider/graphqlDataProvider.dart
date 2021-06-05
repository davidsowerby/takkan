import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:graphql/client.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/app/appConfig.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/graphqlDataProvider.dart';
import 'package:precept_script/query/query.dart';

/// GraphQL implementations can vary considerably, and need provider-specific implementations
/// See the 'precept-back4app' package for an example
class GraphQLDataProvider<CONFIG extends PGraphQLDataProvider>
    extends DataProvider<CONFIG, PGQuery> {
  late GraphQLClient _client;

  GraphQLDataProvider({required CONFIG config}) : super(config: config);

  @override
  init(AppConfig appConfig) {
    super.init(appConfig);
    HttpLink _httpLink = HttpLink(
      config.graphqlEndpoint,
      defaultHeaders: appConfig.headers(config),
    );

    _client = GraphQLClient(
      /// TODO: The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: _httpLink,
    );
  }

  GraphQLClient get client => _client;

  @override
  addSessionToken() {
    if (authenticator.isAuthenticated) {
      HttpLink link = _client.link as HttpLink;
      if (user.sessionToken != null) {
        link.defaultHeaders[config.sessionTokenKey] = user.sessionToken!;
      } else {
        throw PreceptException('Session token should not be null at this stage');
      }
    }
  }

  @override
  String assembleScript(PGQuery queryConfig, Map<String, dynamic> pageArguments) {
    return queryConfig.script;
  }

  @override
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    // TODO: implement documentIdFromData
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> executeQuery( String script,Map<String, dynamic> variables) {
    // TODO: implement executeQuery
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> executeQueryList(String script, Map<String, dynamic> variables) async {
    addSessionToken();

    final queryOptions = QueryOptions(document: gql(script), variables: variables);
    final QueryResult response = await _client.query(queryOptions);

    // TODO: is 'typename' Back4App specific?
    Map? rawData;
    for(var entry in response.data!.entries){
      if (entry.key != '__typename'){
        rawData=entry.value;
      }
    }

    if (rawData==null){
      throw PreceptException('data is missing');
    }
    final List edges = rawData['edges'];
    final List<Map<String, dynamic>> results = List.empty(growable: true);
    for (var e in edges) {
      results.add(e['node']);
    }
    return results;
  }

  @override
  executeUpdate(String script, DocumentId documentId, Map<String, dynamic> changedData,
      DocumentType documentType) {
    // TODO: implement executeUpdate
    throw UnimplementedError();
  }

  /// Uses REST API because it is easier than constructing a GraphQL mutation
  Future<bool> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
  }) async {
    logType(this.runtimeType).d('Updating data provider');
    addSessionToken();
    HttpLink link = _client.link as HttpLink;
    final dio.Response response = await dio.Dio(dio.BaseOptions(headers: link.defaultHeaders)).put(
      documentUrl(documentId),
      data: changedData,
    );
    if (response.statusCode == HttpStatus.ok) {
      logType(this.runtimeType).d('Data provider updated');
      return true;
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown', statusCode: response.statusCode = -999);
  }

  @override
  Authenticator<PDataProviderBase, dynamic> doCreateAuthenticator() {
    throw UnimplementedError(
        'If you need to authenticate, use a backend specific implementation of RestDataProvider');
  }

  String documentUrl(DocumentId documentId) {
    return '${config.documentEndpoint}/${documentId.path}/${documentId.itemId}';
  }
}
