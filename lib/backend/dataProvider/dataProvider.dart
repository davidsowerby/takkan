import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/dataProvider/restDelegate.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/fieldSelector.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/restQuery.dart';
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
  Future<PScript> latestScript(
      {required Locale locale, required int fromVersion, required String name});

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

  /// Returns the document schema identified within [querySchemaName],
  /// by doing a lookup from [config]
  ///
  /// throws a [PreceptException] if not found
  PDocument documentSchemaFromQuery({required String querySchemaName});

  PDocument documentSchema({required String documentSchemaName});
}

/// Routes all calls to the [graphQLDelegate]
class DefaultDataProvider<CONFIG extends PDataProvider>
    implements DataProvider<CONFIG> {
  final CONFIG config;
  Authenticator? _authenticator;
  late AppConfig _appConfig;
  RestDataProviderDelegate? _restDelegate;
  GraphQLDataProviderDelegate? _graphQLDelegate;

  DefaultDataProvider({
    required this.config,
  });

  List<String> get userRoles => authenticator.userRoles;

  Authenticator get authenticator {
    if (_authenticator == null) {
      throw PreceptException(
          "Authenticator not constructed, has 'createAuthenticator' been set?");
    }
    return _authenticator!;
  }

  AppConfig get appConfig => _appConfig;

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
    this._appConfig = appConfig;
    if (config.restDelegate != null) {
      _restDelegate = createRestDelegate();

      restDelegate.init(appConfig, this);
    }
    if (config.graphQLDelegate != null) {
      _graphQLDelegate = createGraphQLDelegate();
      graphQLDelegate.init(appConfig, this);
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

    switch (queryConfig.runtimeType) {
      case PGraphQLQuery:
        {
          if (config.graphQLDelegate != null) {
            return graphQLDelegate.fetchItem(
                queryConfig as PGraphQLQuery, variables);
          } else {
            String msg =
                'In order to use a ${queryConfig.runtimeType.toString()}, a graphQLDelegate must be specified in PDataProvider';
            logType(this.runtimeType).e(msg);
            throw PreceptException(msg);
          }
        }
      case PRestQuery:
        {
          if (config.restDelegate != null) {
            return restDelegate.fetchItem(queryConfig as PRestQuery, variables);
          } else {
            String msg =
                'In order to use a ${queryConfig.runtimeType.toString()}, a restDelegate must be specified in PDataProvider';
            logType(this.runtimeType).e(msg);
            throw PreceptException(msg);
          }
        }
      // case PGetDocument :
      //   {
      //     return defaultDelegate.readDocument(
      //         documentId: (queryConfig as PGetDocument).documentId)
      //   }
      default:
        String msg =
            'No delegate available to support a ${queryConfig.runtimeType.toString()}';
        logType(this.runtimeType).e(msg);
        throw PreceptException(msg);
    }
  }

  /// Returns a Future of a list of one or more document instances
  Future<ReadResultList> fetchList({
    required PQuery queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final Map<String, dynamic> variables =
        combineVariables(queryConfig, pageArguments);
    if (queryConfig is PGraphQLQuery) {
      if (config.useGraphQLDelegate) {
        return graphQLDelegate.fetchList(queryConfig, variables);
      } else {
        throw PreceptException(
            'In order to use a ${queryConfig.runtimeType.toString()}, a graphQLDelegate must be specified in PDataProvider');
      }
    }
    if (config is PRestQuery) {
      if (config.useRestDelegate) {
        return restDelegate.fetchList(queryConfig as PRestQuery, variables);
      } else {
        throw PreceptException(
            'In order to use a ${queryConfig.runtimeType.toString()}, a restDelegate must be specified in PDataProvider');
      }
    }

    throw PreceptException(
        'No delegate available to support a ${queryConfig.runtimeType.toString()}');
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
  }) {
    if (config.useGraphQLDelegate) {
      return graphQLDelegate.createDocument(
        path: path,
        data: data,
        fieldSelector: fieldSelector,
      );
    } else {
      return restDelegate.createDocument(
        path: path,
        data: data,
        fieldSelector: fieldSelector,
      );
    }
  }

  /// See [DataProvider.updateDocument]
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    required Map<String, dynamic> data,
  }) {
    if (config.useGraphQLDelegate) {
      return graphQLDelegate.updateDocument(
        documentId: documentId,
        data: data,
      );
    } else {
      return restDelegate.updateDocument(
        documentId: documentId,
        data: data,
      );
    }
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

  @override
  Future<PScript> latestScript(
      {required Locale locale,
      required int fromVersion,
      required String name}) async {
    final DataProviderDelegate scriptDelegate = (config.useGraphQLDelegate)
        ? graphQLDelegate
        : restDelegate as DataProviderDelegate;
    final ReadResult result = await scriptDelegate.latestScript(
        locale: locale, fromVersion: fromVersion, name: name);
    return PScript.fromJson(result.data);
  }

  /// If the [restDelegate] available, calls it to delete the document,
  /// otherwise call the [graphQLDelegate] to execute the delete.
  ///
  /// see [DataProvider.deleteDocument]
  @override
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
  }) {
    if (config.useGraphQLDelegate) {
      return graphQLDelegate.deleteDocument(documentId: documentId);
    } else {
      return restDelegate.deleteDocument(documentId: documentId);
    }
  }

  ///
  /// see [DataProvider.readDocument]
  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
  }) {
    final DataProviderDelegate delegate = (config.useGraphQLDelegate)
        ? graphQLDelegate as DataProviderDelegate
        : restDelegate;
    return delegate.readDocument(
      documentId: documentId,
      fieldSelector: fieldSelector,
      fetchPolicy: fetchPolicy,
    );
  }

  PDocument documentSchemaFromQuery({required String querySchemaName}) {
    return config.documentSchemaFromQuery(querySchemaName: querySchemaName);
  }

  PDocument documentSchema({required String documentSchemaName}) {
    return config.documentSchema(documentSchemaName: documentSchemaName);
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
      {required Locale locale,
      required int fromVersion,
      required String name}) {
    throw PreceptException(msg);
  }

  @override
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
    FieldSelector fieldSelector = const FieldSelector(),
  }) {
    throw PreceptException(msg);
  }

  @override
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
  }) {
    throw PreceptException(msg);
  }

  @override
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
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
}
