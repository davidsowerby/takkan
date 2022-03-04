import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_backend/backend/data_provider/delegate.dart';
import 'package:precept_backend/backend/data_provider/rest_delegate.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/precept_user.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/query/field_selector.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/rest_query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

/// The layer between the client and server.
///
/// It provides a consistent data access interface regardless of the type of data provider used.
///
/// The default implementation [DefaultDataProvider] uses the GraphQL delegate if available, falling
/// back to the REST delegate if there is no GraphQL delegate.
///
/// An implementation could, however, use GraphQL queries but REST for updates, though
/// that may not be a good idea if a cache is used.
///
/// However it is implemented, the delegate used should transparent to the app.
///
/// An implementation of this interface must be registered with a call to [DataProviderLibrary.register]
///
/// Note that the [DataProviderLibrary] acts as a cache. Multiple instances of the same DataProvider
/// class are identified by the [PConfigSource], but each such instance is cached to ensure
/// consistency of state.
///
/// In addition to CRUD calls, a [DataProvider] provides a backend-specific [Authenticator]
/// implementation, for use where a user is required to authenticate for a particular data provider.
/// The [Authenticator] also contains a [UserState] object for this data provider, holding
/// basic user information and authentication status.
///
/// This means that a client app can log in as a different user for each [DataProvider]
/// it uses.
///
/// If a call is not supported by an implementation, it will throw a [APINotSupportedException]
///

abstract class DataProvider<CONFIG extends PDataProvider> {
  init(AppConfig appConfig);

  CONFIG get config;

  Authenticator get authenticator;

  /// Fetch exactly one item (document) from the database.  The [Delegate] used
  /// is determined by the runtime type of [queryConfig]
  ///
  /// [ReadResult.success] is false if there is not exactly one result
  Future<ReadResultItem> fetchItem({
    required PQuery queryConfig,
    required Map<String, dynamic> pageArguments,
  });

  /// Fetch 0..n items from the database, matching the [queryConfig]
  ///
  /// [ReadResult.success] is false the query fails
  Future<ReadResultList> fetchList({
    required PQuery queryConfig,
    required Map<String, dynamic> pageArguments,
  });

  /// Updates a document according the document type declared in its [schema].
  ///
  /// A [DocumentType.versioned] document is actually saved as a complete copy,
  /// with its version number incremented.  [data] must therefore contain
  /// the entire document
  ///
  /// A [DocumentType.standard] simply updates the existing document
  ///
  /// There are occasions where it is necessary to explicitly select which delegate
  /// to use, and this is done with [useDelegate].  If [useDelegate] is null,
  /// the [PDataProvider.defaultDelegate] is used.
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    Delegate? useDelegate,
    required Map<String, dynamic> data,
  });

  ///  Deletes the document identified by [documentId], according to the
  ///  document type declared in its [schema].
  ///
  /// A [DocumentType.versioned] has its 'status' field set to 'deleted'
  ///
  /// A [DocumentType.standard] simply deletes the existing document
  ///
  /// No exceptions are thrown if the document does not exist
  ///
  /// There are occasions where it is necessary to explicitly select which delegate
  /// to use, and this is done with [useDelegate].  If [useDelegate] is null,
  /// the [PDataProvider.defaultDelegate] is used.
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
  });

  /// Executes a server-side function [functionName], with [params]
  ///
  /// The REST delegate is always used
  Future<ReadResult> executeFunction({
    required String functionName,
    Map<String, dynamic> params = const {},
  });

  /// Reads the document identified by [documentId]
  ///
  /// [fieldSelector] is used only by the [GraphQLDataProviderDelegate], to limit the
  /// fields returned, rather than return the whole document
  ///
  /// There are occasions where it is necessary to explicitly select which delegate
  /// to use, and this is done with [useDelegate].  If [useDelegate] is null,
  /// the [PDataProvider.defaultDelegate] is used.
  ///
  /// throws an [APIException] if the document is not found
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
  });

  /// Used only to create a completely new document.  The document is created
  /// in a way that is consistent with the document type declared in its [schema].
  ///
  /// Subsequent updates, whether [DocumentType.standard] or [DocumentType.versioned],
  /// should be amended via a call to [updateDocument]
  ///
  /// [path] is the equivalent of [DocumentId.path], so will be something like
  ///  the class / table name used by the [DataProvider]
  ///
  /// There are occasions where it is necessary to explicitly select which delegate
  /// to use, and this is done with [useDelegate].  If [useDelegate] is null,
  /// the [PDataProvider.defaultDelegate] is used.
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
  });

  /// Returns the latest [PScript] from this provider.
  ///
  /// A [PScript] is identified by [name] and [locale]
  ///
  /// [fromVersion] is used to limit the number of scripts returned.  If there are
  /// multiple scripts with the same version (which should not actually happen),
  /// the one with the most recent 'updatedAt' field is returned
  ///
  /// If required, [useDelegate] may select a specific delegate, otherwise it will
  /// default to [PDataProvider.defaultDelegate]
  ///
  Future<PScript> latestScript({
    required String locale,
    required int fromVersion,
    required String name,
    Delegate? useDelegate,
  });

  /// Returns a [DocumentId] from a document's data.  This is likely to be backend
  /// specific
  DocumentId documentIdFromData(Map<String, dynamic> data);

  /// The roles held by the user currently logged in to this provider.
  ///
  /// This will currently fail if no user logged in see https://gitlab.com/precept1/precept_backend/-/issues/9
  List<String> get userRoles;

  /// The currently identified user of this provider.  If no user is signed in,
  /// returns a user instance created with [PreceptUser.unknownUser]
  PreceptUser get user;

  PDocument documentSchema({required String documentSchemaName});
}

/// Routes all calls to the [graphQLDelegate]
class DefaultDataProvider<CONFIG extends PDataProvider>
    implements DataProvider<CONFIG> {
  final CONFIG config;
  Authenticator? _authenticator;
  RestDataProviderDelegate? _restDelegate;
  GraphQLDataProviderDelegate? _graphQLDelegate;
  late InstanceConfig _instanceConfig;

  DefaultDataProvider({
    required this.config,
  });

  List<String> get userRoles => authenticator.userRoles;

  InstanceConfig get instanceConfig => _instanceConfig;

  /// The key to look up the item id of a document
  /// Back4App for example, uses 'objectId'
  String get itemIdKey => 'objectId';

  Authenticator get authenticator {
    if (_authenticator == null) {
      throw PreceptException(
          "Authenticator not constructed, has 'createAuthenticator' been set?");
    }
    return _authenticator!;
  }

  RestDataProviderDelegate get restDelegate {
    if (_restDelegate != null) {
      return _restDelegate!;
    }
    throw PreceptException(
        'You have used a PRestQuery but no REST delegate Make sure you have set config.restQLDelegate');
  }

  GraphQLDataProviderDelegate get graphQLDelegate {
    if (_graphQLDelegate != null) {
      return _graphQLDelegate!;
    }
    throw PreceptException(
        'No GraphQL delegate has been constructed.  Make sure you have set config.graphQLDelegate');
  }

  /// If overriding this make sure you call super()
  init(AppConfig appConfig) async {
    final instanceConfig = appConfig.instanceConfig(config);
    this._instanceConfig = instanceConfig;
    if (config.restDelegate != null) {
      _restDelegate = createRestDelegate();

      restDelegate.init(instanceConfig, this);
    }
    if (config.graphQLDelegate != null) {
      _graphQLDelegate = createGraphQLDelegate();
      graphQLDelegate.init(instanceConfig, this);
    }

    if (config.useAuthenticator) {
      _authenticator = await createAuthenticator();
      authenticator.init(this);
    }
  }

  PreceptUser get user => authenticator.user;

  SignInStatus get authStatus => authenticator.status;

  DataProviderDelegate get defaultDelegate {
    switch (config.defaultDelegate) {
      case Delegate.graphQl:
        return graphQLDelegate;
      case Delegate.rest:
        return restDelegate;
    }
  }

  /// see [DataProvider.fetchItem]
  Future<ReadResultItem> fetchItem({
    required PQuery queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final Map<String, dynamic> variables =
    combineVariables(queryConfig, pageArguments);
    return _delegateFromQueryType(queryConfig: queryConfig)
        .fetchItem(queryConfig, variables);
  }

  /// Returns a Future of a list of one or more document instances
  Future<ReadResultList> fetchList({
    required PQuery queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final Map<String, dynamic> variables =
    combineVariables(queryConfig, pageArguments);
    return _delegateFromQueryType(queryConfig: queryConfig)
        .fetchList(queryConfig, variables);
  }

  /// Returns a stream of document
  Future<Stream<Map<String, dynamic>>> connectItem() {
    throw UnimplementedError();
  }

  /// Returns a stream of document list
  Future<Stream<List<Map<String, dynamic>>>> connectList() {
    throw UnimplementedError();
  }

  /// See [DataProvider.createDocument]
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
  }) async {
    return await _selectDelegate(useDelegate)
        .createDocument(path: path, data: data, documentIdKey: itemIdKey);
  }

  Future<ReadResult> executeFunction({
    required String functionName,
    Map<String, dynamic> params = const {},
  }) async {
    return await restDelegate.executeFunction(
      functionName: functionName,
      params: params,
    );
  }

  /// See [DataProvider.updateDocument]
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
    required Map<String, dynamic> data,
  }) async {
    return await _selectDelegate(useDelegate)
        .updateDocument(documentId: documentId, data: data);
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
  Map<String, dynamic> combineVariables(PQuery query, Map<String, dynamic> pageArguments) {
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

  @override
  Future<PScript> latestScript({required String locale,
    required int fromVersion,
    Delegate? useDelegate,
    required String name}) async {
    final ReadResultItem result = await _selectDelegate(useDelegate)
        .latestScript(locale: locale, fromVersion: fromVersion, name: name);
    return PScript.fromJson(result.data);
  }

  /// If the [restDelegate] available, calls it to delete the document,
  /// otherwise call the [graphQLDelegate] to execute the delete.
  ///
  /// see [DataProvider.deleteDocument]
  @override
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
  }) async {
    return await _selectDelegate(useDelegate)
        .deleteDocument(documentId: documentId);
  }

  ///
  /// see [DataProvider.readDocument]
  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    Delegate? useDelegate,
    FetchPolicy? fetchPolicy,
  }) async {
    return await _selectDelegate(useDelegate)
        .readDocument(documentId: documentId);
  }

  PDocument documentSchema({required String documentSchemaName}) {
    return config.script.documentSchema(documentSchemaName: documentSchemaName);
  }

  DataProviderDelegate _delegateFromQueryType({
    required PQuery queryConfig,
  }) {
    if (queryConfig is PGraphQLQuery) {
      if (_graphQLDelegate != null) {
        return graphQLDelegate;
      } else {
        throw PreceptException(
            'In order to use a ${queryConfig.runtimeType.toString()}, a graphQLDelegate must be specified in PDataProvider');
      }
    }
    if (queryConfig is PRestQuery) {
      if (_restDelegate != null) {
        return restDelegate;
      } else {
        throw PreceptException(
            'In order to use a ${queryConfig.runtimeType.toString()}, a restDelegate must be specified in PDataProvider');
      }
    }
    throw PreceptException(
        'No delegate available to support a ${queryConfig.runtimeType.toString()}');
  }

  DataProviderDelegate _selectDelegate(Delegate? selectedDelegate) {
    final Delegate selection = selectedDelegate ?? config.defaultDelegate;
    switch (selection) {
      case Delegate.graphQl:
        return graphQLDelegate;
      case Delegate.rest:
        return restDelegate;
    }
  }

  /// ============ Provided by sub-class implementations ==========================================

  Future<Authenticator> createAuthenticator() {
    throw PreceptException(
        'Config specifies the use of authentication, but createAuthenticator has not been implemented');
  }

  GraphQLDataProviderDelegate createGraphQLDelegate() {
    throw PreceptException(
        'Config specifies the use of GraphQLDelegate, but createGraphQLDelegate has not been implemented');
  }

  RestDataProviderDelegate createRestDelegate() {
    return DefaultRestDataProviderDelegate(this);
  }
}

/// When operating within a session, the addition of a session token is implementation specific
// addSessionToken();

/// The script may be declared in [queryConfig], or composed from [queryConfig] and [pageArguments]
/// REST may use params or the URL to identify query targets.
// String assembleScript(PQuery queryConfig, Map<String, dynamic> pageArguments);

///

class NoDataProvider implements DataProvider {
  static const String msg =
      'A NoDataProvider represents a condition where no data provider is available, and invoking this method is an error condition';

  const NoDataProvider();

  AppConfig get appConfig => throw PreceptException(msg);

  DataProviderDelegate<PQuery> get authenticatorDelegate =>
      throw PreceptException(msg);

  GraphQLDataProviderDelegate get graphQLDelegate =>
      throw PreceptException(msg);

  RestDataProviderDelegate get restDelegate => throw PreceptException(msg);

  SignInStatus get authStatus => throw PreceptException(msg);

  Authenticator<PDataProvider, dynamic, NoDataProvider> get authenticator =>
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

  /// See [DataProvider.fetchItem]
  Future<ReadResultItem> fetchItem(
      {required PQuery queryConfig,
      required Map<String, dynamic> pageArguments}) {
    throw PreceptException(msg);
  }

  /// See [DataProvider.fetchList]
  Future<ReadResultList> fetchList(
      {required PQuery queryConfig,
      required Map<String, dynamic> pageArguments}) {
    throw PreceptException(msg);
  }

  init(AppConfig appConfig) {
    throw PreceptException(msg);
  }

  PreceptUser get user => throw PreceptException(msg);

  List<String> get userRoles => throw PreceptException(msg);

  @override
  Future<PScript> latestScript(
      {required String locale,
      required int fromVersion,
      Delegate? useDelegate,
      required String name}) {
    throw PreceptException(msg);
  }

  @override
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
  }) {
    throw PreceptException(msg);
  }

  @override
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
  }) {
    throw PreceptException(msg);
  }

  @override
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
    required Map<String, dynamic> data,
  }) {
    throw PreceptException(msg);
  }

  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
    Delegate? useDelegate,
  }) {
    throw PreceptException(msg);
  }

  PDocument documentSchemaFromQuery({required String querySchemaName}) {
    throw PreceptException(msg);
  }

  @override
  PDocument documentSchema({required String documentSchemaName}) {
    throw PreceptException(msg);
  }

  @override
  Future<ReadResult> executeFunction(
      {required String functionName, Map<String, dynamic> params = const {}}) {
    // TODO: implement executeFunction
    throw UnimplementedError();
  }
}
