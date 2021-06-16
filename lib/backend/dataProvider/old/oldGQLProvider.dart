// import 'package:graphql/client.dart';
// import 'package:precept_backend/backend/dataProvider/dataProviderBase.dart';
// import 'package:precept_script/data/provider/graphqlDataProvider.dart';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:dio/dio.dart' as dio;
// import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
// import 'package:precept_backend/backend/document.dart';
// import 'package:precept_backend/backend/exception.dart';
// import 'package:precept_backend/backend/user/authenticator.dart';
// import 'package:precept_backend/backend/user/noAuthenticator.dart';
// import 'package:precept_backend/backend/user/preceptUser.dart';
// import 'package:precept_script/common/exception.dart';
// import 'package:precept_script/common/log.dart';
// import 'package:precept_script/common/util/string.dart';
// import 'package:precept_script/data/provider/dataProviderBase.dart';
// import 'package:precept_script/data/provider/documentId.dart';
// import 'package:precept_script/query/query.dart';
// import 'package:precept_script/script/script.dart';
//
// /// GraphQL implementations can vary considerably, and need provider-specific implementations
// /// See the 'precept-back4app' package for an example
// abstract class GraphQLDataProvider<CONFIG extends PGraphQLDataProvider> extends DataProvider<CONFIG, PGQuery> {
//   late GraphQLClient _client;
//
//
//   GraphQLDataProvider({required CONFIG config}) : super(config: config) {
//     HttpLink _httpLink = HttpLink(
//       config.graphqlEndpoint,
//       defaultHeaders: config.headers,
//     );
//
//     _client = GraphQLClient(
//       /// TODO: The default store is the InMemoryStore, which does NOT persist to disk
//       cache: GraphQLCache(),
//       link: _httpLink,
//     );
//   }
//
//   GraphQLClient get client => _client;
//
//
//
//   _addSessionToken() {
//     if (authenticator.isAuthenticated) {
//       HttpLink link = _client.link as HttpLink;
//       if (user.sessionToken != null) {
//         link.defaultHeaders[sessionTokenKey] = user.sessionToken!;
//       }else{
//         throw PreceptException('Session token should not be null at this stage');
//       }
//     }
//   }
//
//   Future<Map<String, dynamic>> _query(
//       {required PGQuery query,
//         required String script,
//         Map<String, dynamic> pageArguments = const {}}) async {
//     _addSessionToken();
//     final Map<String, dynamic> variables = combineVariables(query, pageArguments);
//     final queryOptions = QueryOptions(document: gql(script), variables: variables);
//     final QueryResult response = await _client.query(queryOptions);
//     final String method = decapitalize(query.table);
//     final actualData = response.data![method];
//     return actualData;
//   }
//
//   Future<List<Map<String, dynamic>>> _queryList(
//       {required PGQuery query,
//         required String script,
//         Map<String, dynamic> pageArguments = const {}}) async {
//     _addSessionToken();
//     final Map<String, dynamic> variables = combineVariables(query, pageArguments);
//     final queryOptions = QueryOptions(document: gql(script), variables: variables);
//     final QueryResult response = await _client.query(queryOptions);
//
//     /// GraphQL uses the plural form for the method name when retrieving a list
//     final String method = "${decapitalize(query.table)}s";
//     final rawData = response.data![method];
//     final List edges = rawData['edges'];
//     final List<Map<String, dynamic>> results = List.empty(growable: true);
//     for (var e in edges) {
//       results.add(e['node']);
//     }
//     return results;
//   }
//
//   Future<Map<String, dynamic>> gQuery(
//       {required PGQuery query, Map<String, dynamic> pageArguments = const {}}) async {
//     return _query(query: query, script: query.script, pageArguments: pageArguments);
//   }
//
//   Future<List<Map<String, dynamic>>> gQueryList(
//       {required PGQuery query, Map<String, dynamic> pageArguments = const {}}) async {
//     return _queryList(query: query, script: query.script, pageArguments: pageArguments);
//   }
//
//   Future<Map<String, dynamic>> pQuery(
//       {required PPQuery query, Map<String, dynamic> pageArguments = const {}}) async {
//     final Map<String, dynamic> variables = combineVariables(query, pageArguments);
//     final StringBuffer buf = StringBuffer();
//     buf.write('query Get');
//     buf.write(query.table);
//     buf.write('(');
//     bool first = true;
//     for (MapEntry<String, String> entry in query.types.entries) {
//       if (!first) {
//         buf.write(',');
//       } else {
//         first = false;
//       }
//       buf.write(' \$${entry.key}: ${entry.value}');
//     }
//     buf.write(') {');
//     buf.write(decapitalize(query.table));
//     buf.write('(');
//     first = true;
//     for (MapEntry<String, dynamic> entry in variables.entries) {
//       if (!first) {
//         buf.write(',');
//       } else {
//         first = false;
//       }
//       buf.write('${entry.key}: \$${entry.key}');
//     }
//     buf.write(') {');
//     buf.write(query.fields);
//     buf.write('}}');
//     return _query(query: query, script: buf.toString(), pageArguments: pageArguments);
//   }
//
//   Future<Map<String, dynamic>> query(
//       {required PQuery query,
//         required String script,
//         Map<String, dynamic> pageArguments = const {}}) async {
//     return (query is PGQuery)
//         ? gQuery(query: query, pageArguments: pageArguments)
//         : pQuery(query: query as PPQuery, pageArguments: pageArguments);
//   }
//
//   Future<List<Map<String, dynamic>>> queryList(
//       {required PQuery query,
//         required String script,
//         Map<String, dynamic> pageArguments = const {}}) async {
//     return (query is PGQuery)
//         ? gQueryList(query: query, pageArguments: pageArguments)
//         : pQueryList(query: query as PPQuery, pageArguments: pageArguments);
//   }
//
//   Future<Map<String, dynamic>> getDocument(
//       {required DocumentId documentId, Map<String, dynamic> pageArguments = const {}}) async {
//     final PPQuery q = PPQuery(
//         name: 'getDocument',
//         table: documentId.path,
//         variables: {config.idPropertyName: documentId.itemId},
//         types: {config.idPropertyName: 'String!'});
//     return pQuery(query: q);
//   }
//
// }
