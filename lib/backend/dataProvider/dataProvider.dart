import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/app/appConfig.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/restQuery.dart';

/// The layer between the client and server.
///
/// It provides a consistent data access interface regardless of the type of data provider used.
///
/// An implementation could, for example, use GraphQL queries but REST for updates, but that is transparent
/// to the app.
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

abstract class DataProvider<CONFIG extends PDataProvider> {
  init(AppConfig appConfig);
}

class DefaultDataProvider<CONFIG extends PDataProvider>
    implements DataProvider<CONFIG> {
  final CONFIG config;
  late Authenticator? _authenticator;
  late AppConfig _appConfig;
  late RestDataProviderDelegate restDelegate;
  late GraphQLDataProviderDelegate graphQLDelegate;
  late DataProviderDelegate authenticatorDelegate;

  DefaultDataProvider({required this.config});

  List<String> get userRoles => authenticator.userRoles;

  Authenticator get authenticator => _authenticator!;

  AppConfig get appConfig => _appConfig;

  /// If overriding this make sure you call super()
  init(AppConfig appConfig) {
    this._appConfig = appConfig;
    if (config.useRestDelegate) {
      restDelegate = inject<RestDataProviderDelegate>();
    }
    if (config.useGraphQLDelegate) {
      graphQLDelegate = inject<GraphQLDataProviderDelegate>();
    }

    // TODO: report DART bug. ternary operator fails, but works if both branches are set to the same delegate
    //  authenticatorDelegate= (config.authenticatorDelegate == CloudInterface.graphQL) ? graphQLDelegate : graphQLDelegate;
    if (config.authenticatorDelegate == CloudInterface.graphQL) {
      authenticatorDelegate = graphQLDelegate;
    } else {
      authenticatorDelegate = restDelegate;
    }
  }

  createAuthenticator() {
    if (_authenticator == null) {
      _authenticator = authenticatorDelegate.createAuthenticator();
    }
  }

  PreceptUser get user => authenticator.user;

  SignInStatus get authStatus => authenticator.status;

  /// Returns a Future of a single instance of a document
  Future<Map<String, dynamic>> fetchItem({
    required PQuery queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final Map<String, dynamic> variables =
        combineVariables(queryConfig, pageArguments);
    if (queryConfig is PGraphQLQuery) {
      return graphQLDelegate.fetchItem(queryConfig, variables);
    } else {
      return restDelegate.fetchItem(queryConfig as PRestQuery, variables);
    }
  }

  /// Returns a Future of a list of one or more document instances
  Future<List<Map<String, dynamic>>> fetchList({
    required PQuery queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final Map<String, dynamic> variables =
        combineVariables(queryConfig, pageArguments);
    if (queryConfig is PGraphQLQuery) {
      return graphQLDelegate.fetchList(queryConfig, variables);
    } else {
      return restDelegate.fetchList(queryConfig as PRestQuery, variables);
    }
  }

  /// Returns a stream of document
  Future<Stream<Map<String, dynamic>>> connectItem() {
    throw UnimplementedError();
  }

  /// Returns a stream of document list
  Future<Stream<List<Map<String, dynamic>>>> connectList() {
    throw UnimplementedError();
  }

  Future<bool> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
  }) {
    return restDelegate.updateDocument(
      documentId: documentId,
      changedData: changedData,
      documentType: documentType,
    );
  }

  /// Once a document has been created, it should be possible to create a unique id for it
  /// from its data, but the manner of doing so is implementation specific.
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(path: 'unknown', itemId: 'unknown');
  }

  /// Combines variable values from 3 possible sources. Order of precedence is:
  ///
  /// 1. [PQuery.variables]
  /// 1. Values looked up from the properties specified in [PQuery.propertyReferences]
  /// 1. Values passed as [pageArguments]
  @protected
  Map<String, dynamic> combineVariables(
      PQuery query, Map<String, dynamic> pageArguments) {
    final variables = Map<String, dynamic>();
    final propertyVariables = _buildPropertyVariables(query.propertyReferences);
    variables.addAll(pageArguments);
    variables.addAll(propertyVariables);
    variables.addAll(query.variables);
    return variables;
  }

  // TODO: get variable values from property references
  Map<String, dynamic> _buildPropertyVariables(
      List<String> propertyReferences) {
    return {};
  }

  /// ============ Provided by sub-class implementations ==========================================

  /// When operating within a session, the addition of a session token is implementation specific
// addSessionToken();

  /// The script may be declared in [queryConfig], or composed from [queryConfig] and [pageArguments]
  /// REST may use params or the URL to identify query targets.
// String assembleScript(PQuery queryConfig, Map<String, dynamic> pageArguments);

  ///

}

class NoDataProvider implements DataProvider {
  static const String msg =
      'A NoDataProvider represents a condition where no data provider is available, and invoking this method is an error condition';

  NoDataProvider();

  AppConfig get appConfig => throw PreceptException(msg);

  DataProviderDelegate<PQuery> get authenticatorDelegate =>
      throw PreceptException(msg);

  GraphQLDataProviderDelegate get graphQLDelegate =>
      throw PreceptException(msg);

  RestDataProviderDelegate get restDelegate => throw PreceptException(msg);

  SignInStatus get authStatus => throw PreceptException(msg);

  Authenticator<PDataProvider, dynamic> get authenticator =>
      throw PreceptException(msg);

  PDataProvider get config => throw PreceptException(msg);

  Future<Stream<Map<String, dynamic>>> connectItem() {
    throw PreceptException(msg);
  }

  Future<Stream<List<Map<String, dynamic>>>> connectList() {
    throw PreceptException(msg);
  }

  createAuthenticator() {
    throw PreceptException(msg);
  }

  DocumentId documentIdFromData(Map<String, dynamic> data) {
    throw PreceptException(msg);
  }

  Future<Map<String, dynamic>> fetchItem(
      {required PQuery queryConfig,
      required Map<String, dynamic> pageArguments}) {
    throw PreceptException(msg);
  }

  Future<List<Map<String, dynamic>>> fetchList(
      {required PQuery queryConfig,
      required Map<String, dynamic> pageArguments}) {
    throw PreceptException(msg);
  }

  init(AppConfig appConfig) {
    throw PreceptException(msg);
  }

  Future<bool> updateDocument(
      {required DocumentId documentId,
      required Map<String, dynamic> changedData,
      DocumentType documentType = DocumentType.standard}) {
    throw PreceptException(msg);
  }

  PreceptUser get user => throw PreceptException(msg);

  List<String> get userRoles => throw PreceptException(msg);
}
