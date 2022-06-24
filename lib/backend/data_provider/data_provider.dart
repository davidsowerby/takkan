import 'package:graphql/client.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/delegate.dart';
import 'package:takkan_backend/backend/data_provider/query_selector.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_backend/backend/exception.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/delegate.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';

/// The layer between the client and server.
///
/// It provides a consistent data access interface regardless of the type of data provider used.
///
/// The default implementation [BaseDataProvider] uses the GraphQL delegate if available, falling
/// back to the REST delegate if there is no GraphQL delegate.
///
/// An implementation could, however, use GraphQL queries but REST for updates, though
/// that may not be a good idea if a cache is used.
///
/// However it is implemented, the delegate used should transparent to the app.
///
/// Selection of the active [IDataProvider] is through the use of get_it [scopes](https://pub.dev/packages/get_it#scope-functions).
///
/// Identification of a provider is provided by [config.instanceConfig], as
/// there may be the occasional requirement to work with two instances of the
/// same backend type,
///
/// In addition to CRUD calls, a [IDataProvider] provides a backend-specific [Authenticator]
/// implementation, for use where a user is required to authenticate for a particular data provider.
/// The [Authenticator] also contains a [UserState] object for this data provider, holding
/// basic user information and authentication status.
///
/// This means that a client app can log in as a different user for each [IDataProvider]
/// it uses.
///
/// If a call is not supported by an implementation, it will throw a [APINotSupportedException]
///
/// [init] must always be invoked before use
///

abstract class IDataProvider<CONFIG extends DataProvider>
    extends QuerySelector {
  init({required CONFIG config,required AppConfig appConfig});

  CONFIG get config;

  Authenticator get authenticator;

  /// Fetch exactly one item (document) from the database.  The [Delegate] used
  /// is determined by the runtime type of [queryConfig]
  ///
  /// [ReadResult.success] is false if there is not exactly one result
  Future<ReadResultItem> fetchItem({
    required Query queryConfig,
    required Map<String, dynamic> pageArguments,
  });

  /// The property name for the field which provides a document's unique id
  String get objectIdKey;

  /// Fetch 0..n items from the database, matching the [queryConfig]
  ///
  /// [ReadResult.success] is false the query fails
  Future<ReadResultList> fetchList({
    required Query queryConfig,
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
  /// the [DataProvider.defaultDelegate] is used.
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
  /// the [DataProvider.defaultDelegate] is used.
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
  });

  /// Executes a general server side server-side function [functionName], with [params]
  ///
  /// The REST delegate is always used
  Future<ReadResult> executeFunction({
    required String functionName,
    Map<String, dynamic> params = const {},
  });

  /// Executes a server side server-side function [functionName], with [params]
  /// Always returns a single document unless success==false in the returned result
  Future<ReadResultItem> executeItemFunction({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  });

  /// Executes a server side server-side function [functionName], with [params]
  /// Always returns a list of documents unless success==false in the returned result
  Future<ReadResultList> executeListFunction({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  });

  /// Reads the document identified by [documentId]
  ///
  /// [fieldSelector] is used only by the [GraphQLDataProviderDelegate], to limit the
  /// fields returned, rather than return the whole document
  ///
  /// There are occasions where it is necessary to explicitly select which delegate
  /// to use, and this is done with [useDelegate].  If [useDelegate] is null,
  /// the [DataProvider.defaultDelegate] is used.
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
  /// [documentClass] is the equivalent of [DocumentId.documentClass], so will be something like
  ///  the class / table name used by the [IDataProvider]
  ///
  /// There are occasions where it is necessary to explicitly select which delegate
  /// to use, and this is done with [useDelegate].  If [useDelegate] is null,
  /// the [DataProvider.defaultDelegate] is used.
  Future<CreateResult> createDocument({
    required String documentClass,
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
  /// default to [DataProvider.defaultDelegate]
  ///
  Future<Script> latestScript({
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
  /// This will currently fail if no user logged in see https://gitlab.com/takkan/takkan_backend/-/issues/9
  List<String> get userRoles;

  /// The currently identified user of this provider.  If no user is signed in,
  /// returns a user instance created with [TakkanUser.unknownUser]
  TakkanUser get user;

  Document documentSchema({required String documentSchemaName});

  /// The HTTP header key for the session token
  String get sessionTokenKey;

  bool get userIsAuthenticated;

  bool get userIsNotAuthenticated;
}