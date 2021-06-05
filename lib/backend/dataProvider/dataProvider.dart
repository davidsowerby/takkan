
import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/app/appConfig.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';

/// The layer between the client and server.
///
/// It provides a consistent data access interface regardless of the type of data provider used.
///
/// This default class works on the principle of using GraphQL to specify queries, but uses
/// a REST call for some updates.  This is purely for pragmatic (or possibly lazy) reasons.  Using
/// GraphQL for queries makes perfect sense as many cloud providers provide a GraphQL interface.
/// Using REST for updates is pragmatic - if its easier, do it that way!
///
/// Sub-classes may change some elements of how the provider works. To achieve this, an implementation
/// must register a sub-class of this with calls to [DataProviderLibrary.register]
///
/// In addition to CRUD calls, this class also provides a backend-specific [Authenticator]
/// implementation, for use where a user is required to authenticate for a particular data provider.
/// The [Authenticator] also contains a [UserState] object for this data provider, holding
/// basic user information and authentication status.
///
/// If a call is not supported by an implementation, it will throw a [APINotSupportedException]
///
/// Note that the [DataProviderLibrary] acts as a cache. Multiple instances of the same DataProvider
/// class are identified by the [PConfigSource], but each such instance is effectively cached to ensure
/// consistency of state.
///
/// This means in theory, (as yet untested) that a client app could actually log in as a different
/// user for each [DataProvider] it uses.

abstract class DataProvider<CONFIG extends PDataProviderBase, QUERY extends PQuery> {
  final CONFIG config;
  Authenticator? _authenticator;
  late AppConfig appConfig;

  DataProvider({required this.config}) : super();

  List<String> get userRoles => authenticator.userRoles;

  Authenticator get authenticator => _authenticator!;

  /// If overriding this make sure you call super()
  init(AppConfig appConfig) {
    this.appConfig = appConfig;
  }

  createAuthenticator() {
    if (_authenticator == null) {
      _authenticator = doCreateAuthenticator();
    }
  }

  Authenticator doCreateAuthenticator();

  PreceptUser get user => authenticator.user;

  SignInStatus get authStatus => authenticator.status;

  /// Returns a Future of a single instance of a document
  Future<Map<String, dynamic>> query({
    required QUERY queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final String script = assembleScript(queryConfig, pageArguments);
    final Map<String, dynamic> variables = combineVariables(queryConfig, pageArguments);
    return executeQuery(script, variables);
  }

  /// Returns a Future of a list of one or more document instances
  Future<List<Map<String, dynamic>>> queryList({
    required QUERY queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final String script = assembleScript(queryConfig, pageArguments);
    final Map<String, dynamic> variables = combineVariables(queryConfig, pageArguments);
    return executeQueryList(script,variables);
  }

  /// Combines variable values from 3 possible sources. Order of precedence is:
  ///
  /// 1. [PQuery.variables]
  /// 1. Values looked up from the properties specified in [PQuery.propertyReferences]
  /// 1. Values passed as [pageArguments]
  @protected
  Map<String, dynamic> combineVariables(QUERY query, Map<String, dynamic> pageArguments) {
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

  /// ============ Provided by sub-class implementations ==========================================

  /// Overridden by sub-classes to execute the query [script] in the appropriate way for the
  /// implementation, for example REST or GraphQL
  Future<Map<String, dynamic>> executeQuery( String script,Map<String, dynamic> variables);

  /// Overridden by sub-classes to execute the query [script] in the appropriate way for the
  /// implementation, for example REST or GraphQL
  Future<List<Map<String, dynamic>>> executeQueryList( String script,Map<String, dynamic> variables);

  /// When operating within a session, the addition of a session token is implementation specific
  addSessionToken();

  /// Once a document has been created, it should be possible to create a unique id for it
  /// from its data, but the manner of doing so is implementation specific.
  DocumentId documentIdFromData(Map<String, dynamic> data);

  /// The script may be declared in [queryConfig], or composed from [queryConfig] and [pageArguments]
  /// REST may use params or the URL to identify query targets.
  String assembleScript(QUERY queryConfig, Map<String, dynamic> pageArguments);

  ///
  executeUpdate(String script,
      DocumentId documentId,
      Map<String, dynamic> changedData,
      DocumentType documentType,);

  Future<bool> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
  });


}
