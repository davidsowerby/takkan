import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_backend/backend/user/userState.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/util/string.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';

/// The layer between the client and server.
///
/// It provides a consistent data access interface regardless of the type of data provider used.
///
/// This default class works on the principle of using GraphQL to specify queries, but uses
/// a REST call for updates.  This is purely for pragmatic (or possibly lazy) reasons.  Using
/// GraphQL for queries makes perfect sense as many cloud providers provide a GraphQL interface.
/// Using REST for updates is pragmatic - it is easier than constructing a GraphQL Mutation.
///
/// Sub-classes may change some elements of how the provider works. To achieve this, an implementation
/// must register a sub-class of this with with calls to [DataProviderLibrary.register]
///
/// In addition to queries and updates, this class also provides a backend-specific [Authenticator]
/// implementation, for use where a user is required to authenticate for a particular data provider.
/// The [Authenticator] also contains a [UserState] object for this data provider, used to hold
/// basic user information and authentication status.
///
/// If a call is not supported by an implementation, it will throw a [APINotSupportedException]
///
/// Note that the [DataProviderLibrary] acts as a cache, effectively making instances of a particular
/// [DataProvider] type appear as Singletons.  This means of course that any contained state,
/// including [UserState], is also effectively of singleton scope.  In theory, this means that a
/// single client app could actually log in as a different user for each [DataProvider] it uses,
/// though this does seem an unlikely use case.

abstract class DataProvider<CONFIG extends PDataProvider> {
  final CONFIG config;
  Authenticator _authenticator;
  GraphQLClient _client;

  DataProvider({@required this.config})
      : assert(config != null),
        super() {
    HttpLink _httpLink = HttpLink(
      config.graphqlEndpoint,
      defaultHeaders: config.headers,
    );

    _client = GraphQLClient(
      /// TODO: The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: _httpLink,
    );
  }

  Authenticator get authenticator {
    if (_authenticator == null) {
      _authenticator = createAuthenticator(config);
    }
    return _authenticator;
  }

  Authenticator createAuthenticator(CONFIG config) {
    return NoAuthenticator();
  }

  UserState get userState => authenticator.userState;

  Future<Map<String, dynamic>> query(
      {PQuery query, String script, Map<String, dynamic> pageArguments = const {}}) async {
    return (query is PGQuery)
        ? gQuery(query: query, pageArguments: pageArguments)
        : pQuery(query: query, pageArguments: pageArguments);
  }

  Future<List<Map<String, dynamic>>> queryList(
      {PQuery query, String script, Map<String, dynamic> pageArguments = const {}}) async {
    return (query is PGQuery)
        ? gQueryList(query: query, pageArguments: pageArguments)
        : pQueryList(query: query, pageArguments: pageArguments);
  }

  Future<Map<String, dynamic>> gQuery(
      {PGQuery query, Map<String, dynamic> pageArguments = const {}}) async {
    return _query(query: query, script: query.script, pageArguments: pageArguments);
  }

  Future<List<Map<String, dynamic>>> gQueryList(
      {PGQuery query, Map<String, dynamic> pageArguments = const {}}) async {
    return _queryList(query: query, script: query.script, pageArguments: pageArguments);
  }

  Future<Map<String, dynamic>> _query(
      {PQuery query, String script, Map<String, dynamic> pageArguments = const {}}) async {
    final Map<String, dynamic> variables = _combineVariables(query, pageArguments);
    final queryOptions = QueryOptions(document: gql(script), variables: variables);
    final QueryResult response = await _client.query(queryOptions);
    final String method = decapitalize(query.table);
    final actualData = response.data[method];
    return actualData;
  }

  Future<List<Map<String, dynamic>>> _queryList(
      {PQuery query, String script, Map<String, dynamic> pageArguments = const {}}) async {
    final Map<String, dynamic> variables = _combineVariables(query, pageArguments);
    final queryOptions = QueryOptions(document: gql(script), variables: variables);
    final QueryResult response = await _client.query(queryOptions);

    /// GraphQL uses the plural form for the method name when retrieving a list
    final String method = "${decapitalize(query.table)}s";
    final rawData = response.data[method];
    final List edges = rawData['edges'];
    final List<Map<String, dynamic>> results = List.empty(growable: true);
    for (var e in edges) {
      results.add(e['node']);
    }
    return results;
  }

  Future<Map<String, dynamic>> pQuery(
      {PPQuery query, Map<String, dynamic> pageArguments = const {}}) async {
    final Map<String, dynamic> variables = _combineVariables(query, pageArguments);
    final StringBuffer buf = StringBuffer();
    buf.write('query Get');
    buf.write(query.table);
    buf.write('(');
    bool first = true;
    for (MapEntry<String, String> entry in query.types.entries) {
      if (!first) {
        buf.write(',');
      } else {
        first = false;
      }
      buf.write(' \$${entry.key}: ${entry.value}');
    }
    buf.write(') {');
    buf.write(decapitalize(query.table));
    buf.write('(');
    first = true;
    for (MapEntry<String, dynamic> entry in variables.entries) {
      if (!first) {
        buf.write(',');
      } else {
        first = false;
      }
      buf.write('${entry.key}: \$${entry.key}');
    }
    buf.write(') {');
    buf.write(query.fields);
    buf.write('}}');
    return _query(query: query, script: buf.toString(), pageArguments: pageArguments);
  }

  Future<List<Map<String, dynamic>>> pQueryList(
      {PPQuery query, Map<String, dynamic> pageArguments = const {}}) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getDocument(
      {@required DocumentId documentId, Map<String, dynamic> pageArguments = const {}}) async {
    final PPQuery q = PPQuery(
        table: documentId.path,
        variables: {config.idPropertyName: documentId.itemId},
        types: {config.idPropertyName: 'String!'});
    return pQuery(query: q);
  }

  /// Combines variable values from 3 possible sources. Order of precedence is:
  ///
  /// 1. [PQuery.variables]
  /// 1. Values looked up from the properties specified in [PQuery.propertyReferences]
  /// 1. Values passed as [pageArguments]
  Map<String, dynamic> _combineVariables(PQuery query, Map<String, dynamic> pageArguments) {
    assert(pageArguments != null);
    final variables = Map<String, dynamic>();
    final propertyVariables = _buildPropertyVariables(query.propertyReferences);
    variables.addAll(pageArguments);
    variables.addAll(propertyVariables);
    variables.addAll(query.variables);
    return variables;
  }

// TODO: get variable values from property references
  Map<String, dynamic> _buildPropertyVariables(List<String> propertyReferences) {
    return {};
  }

  Future<bool> update({
    DocumentId documentId,
    Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
    Function() onSuccess,
  }) async {
    assert(documentId != null);
    assert(documentId.path != null);
    assert(documentId.itemId != null);
    logType(this.runtimeType).d('Updating data provider');
    final dio.Response response = await dio.Dio(dio.BaseOptions(headers: config.headers)).put(
      documentUrl(documentId),
      data: changedData,
    );
    if (response.statusCode == HttpStatus.ok) {
      logType(this.runtimeType).d('Data provider updated');
      return true;
    }
    throw APIException(message: response.statusMessage, statusCode: response.statusCode);
  }

  String documentUrl(DocumentId documentId) {
    return '${config.documentEndpoint}/${documentId.path}/${documentId.itemId}';
  }

  DocumentId documentIdFromData(Map<String, dynamic> data);
}

class NoAuthenticator extends Authenticator {
  final String msg =
      'If authentication is required, an authenticator must be provided by a sub-class of DataProvider';

  @override
  Future<bool> doDeRegister(PreceptUser user) {
    throw UnimplementedError(msg);
  }

  @override
  Future<AuthenticationResult> doRegisterWithEmail({String username, String password}) {
    throw UnimplementedError(msg);
  }

  @override
  Future<bool> doRequestPasswordReset(PreceptUser user) {
    throw UnimplementedError(msg);
  }

  @override
  Future<AuthenticationResult> doSignInByEmail({String username, String password}) {
    throw UnimplementedError(msg);
  }

  @override
  Future<bool> doUpdateUser(PreceptUser user) {
    throw UnimplementedError(msg);
  }

  @override
  init() {
    logType(this.runtimeType).i("Authenticator not set");
  }
}
