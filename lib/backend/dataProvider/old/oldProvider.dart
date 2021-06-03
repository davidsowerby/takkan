// import 'package:flutter/foundation.dart';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:dio/dio.dart' as dio;
// import 'package:graphql/client.dart';
// import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
// import 'package:precept_backend/backend/document.dart';
// import 'package:precept_backend/backend/exception.dart';
// import 'package:precept_backend/backend/user/authenticator.dart';
// import 'package:precept_backend/backend/user/noAuthenticator.dart';
// import 'package:precept_backend/backend/user/preceptUser.dart';
// import 'package:precept_script/common/log.dart';
// import 'package:precept_script/common/util/string.dart';
// import 'package:precept_script/data/provider/dataProviderBase.dart';
// import 'package:precept_script/data/provider/documentId.dart';
// import 'package:precept_script/query/query.dart';
// import 'package:precept_script/script/script.dart';
//
// /// The layer between the client and server.
// ///
// /// It provides a consistent data access interface regardless of the type of data provider used.
// ///
// /// This default class works on the principle of using GraphQL to specify queries, but uses
// /// a REST call for updates.  This is purely for pragmatic (or possibly lazy) reasons.  Using
// /// GraphQL for queries makes perfect sense as many cloud providers provide a GraphQL interface.
// /// Using REST for updates is pragmatic - it is easier than constructing a GraphQL Mutation.
// ///
// /// Sub-classes may change some elements of how the provider works. To achieve this, an implementation
// /// must register a sub-class of this with with calls to [DataProviderLibrary.register]
// ///
// /// In addition to queries and updates, this class also provides a backend-specific [Authenticator]
// /// implementation, for use where a user is required to authenticate for a particular data provider.
// /// The [Authenticator] also contains a [UserState] object for this data provider, used to hold
// /// basic user information and authentication status.
// ///
// /// If a call is not supported by an implementation, it will throw a [APINotSupportedException]
// ///
// /// Note that the [DataProviderLibrary] acts as a cache, effectively making instances of a particular
// /// [DataProvider] type appear as Singletons.  This means of course that any contained state,
// /// including [UserState], is also effectively of singleton scope.  In theory, this means that a
// /// single client app could actually log in as a different user for each [DataProvider] it uses,
// /// though this does seem an unlikely use case.
//
// abstract class DataProvider<CONFIG extends PDataProviderBase, QUERY extends PQuery> {
//   final CONFIG config;
//   Authenticator? _authenticator;
//
//   DataProvider({required this.config}) : super();
//
//   List<String> get userRoles => authenticator.userRoles;
//
//   Authenticator get authenticator {
//     /// This a late constructor, so null check valid
//     // ignore: unnecessary_null_comparison
//     if (_authenticator == null) {
//       _authenticator = createAuthenticator(config);
//       _authenticator?.init();
//     }
//     return _authenticator!;
//   }
//
//   String get sessionTokenKey;
//
//   Authenticator createAuthenticator(CONFIG config) {
//     return NoAuthenticator();
//   }
//
//   PreceptUser get user => authenticator.user;
//
//   SignInStatus get authStatus => authenticator.status;
//
//   /// returns the latest script of the given [name] and [locale].  [fromVersion] helps to reduce
//   /// the amount of data returned, but can otherwise always be 0.
//   ///
//   /// If somehow there are 2 or more instances with the same version, the most recently
//   /// updated entry is returned
//   Future<PScript> latestScript(
//       {required Locale locale, required int fromVersion, required String name});
//
//   Future<List<Map<String, dynamic>>> pQueryList(
//       {required PPQuery query, Map<String, dynamic> pageArguments = const {}}) async {
//     throw UnimplementedError();
//   }
//
//   Future<Map<String, dynamic>> getDocument(
//       {required DocumentId documentId, Map<String, dynamic> pageArguments = const {}});
//
//   /// Combines variable values from 3 possible sources. Order of precedence is:
//   ///
//   /// 1. [PQuery.variables]
//   /// 1. Values looked up from the properties specified in [PQuery.propertyReferences]
//   /// 1. Values passed as [pageArguments]
//   @protected
//   Map<String, dynamic> combineVariables(QUERY query, Map<String, dynamic> pageArguments) {
//     final variables = Map<String, dynamic>();
//     final propertyVariables = _buildPropertyVariables(query.propertyReferences);
//     variables.addAll(pageArguments);
//     variables.addAll(propertyVariables);
//     variables.addAll(query.variables);
//     return variables;
//   }
//
// // TODO: get variable values from property references
//   Map<String, dynamic> _buildPropertyVariables(List<String> propertyReferences) {
//     return {};
//   }
//
//   /// Creates a database row containing [script] and it associated fields.  Set [incrementVersion]
//   /// to increment the version before saving
//   Future<QueryResult> uploadPreceptScript({
//     required PScript script,
//     required Locale locale,
//     bool incrementVersion = false,
//   });
//

//
//   String documentUrl(DocumentId documentId) {
//     return '${config.documentEndpoint}/${documentId.path}/${documentId.itemId}';
//   }
//
//   /// Returns a Future of a single instance of a document
//   Future<Map<String, dynamic>> query(QUERY queryConfig, Map<String, dynamic> pageArguments) async {
//     final String script = assembleScript(queryConfig, pageArguments);
//     final Map<String, String> headers = assembleHeaders(queryConfig, pageArguments);
//     return executeQuery(headers, script);
//   }
//
//   /// Returns a Future of a single instance of a document
//   Future<List<Map<String, dynamic>>> queryList(
//       QUERY queryConfig, Map<String, dynamic> pageArguments) async {
//     final String script = assembleScript(queryConfig, pageArguments);
//     final Map<String, String> headers = assembleHeaders(queryConfig, pageArguments);
//     return executeQueryList(headers, script);
//   }
//
//   /// ============ Provided by sub-class implementations ==========================================
//
//   /// Overridden by sub-classes to execute the query [script] in the appropriate way for the
//   /// implementation, for example REST or GraphQL
//   Future<Map<String, dynamic>> executeQuery(Map<String, String> headers, String script);
//
//   /// Overridden by sub-classes to execute the query [script] in the appropriate way for the
//   /// implementation, for example REST or GraphQL
//   Future<List<Map<String, dynamic>>> executeQueryList(Map<String, String> headers, String script);
//
//   /// When operating within a session, the addition of a session token is implementation specific
//   addSessionToken();
//
//   /// Once a document has been created, it should be possible to create a unique id for it
//   /// from its data, but the manner ofdoing so is implementation specific.
//   DocumentId documentIdFromData(Map<String, dynamic> data);
//
//   /// The script may be declared in [queryConfig], or composed from [queryConfig] and [pageArguments]
//   /// REST may use params or the URL to identify query targets.
//   String assembleScript(QUERY queryConfig, Map<String, dynamic> pageArguments);
//
//   /// Headers are usually consistent for GraphQL, but for REST an API Key can be carried in a
//   /// header or as a param
//   Map<String, String> assembleHeaders(QUERY queryConfig, Map<String, dynamic> pageArguments);
//
//   ///
//   executeUpdate(
//       String script,
//       Map<String, String> headers,
//       DocumentId documentId,
//       Map<String, dynamic> changedData,
//       DocumentType documentType,
//       );
// }
