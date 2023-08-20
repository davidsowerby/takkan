import 'package:graphql/client.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/data_selector.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/script/script.dart';

import '../exception.dart';
import '../user/authenticator.dart';
import '../user/takkan_user.dart';
import 'result.dart';

/// The layer between the client and server.
///
/// It provides a consistent data access interface regardless of the type of data provider used.
///
/// Selection of the active [IDataProvider] is through the use of [getIt] named
/// instances
///
/// Identification of a provider is provided by [config.instanceConfig], as
/// there may be the occasional requirement to work with two instances of the
/// same backend type,
///
/// If a call is not supported by an implementation, it will throw a [APINotSupportedException]
///
/// [init] must always be invoked before use
///
/// [fetchDocument] and [fetchDocumentList] call cloud functions known to return a
/// single document or list of documents respectively.  These cloud functions are
/// usually generated from the [Schema] by the *takkan_server_code_generator* but
/// could be user provided.
///
/// These are also used by [selectDocument] and [selectDocumentList], which use a
/// [DocumentSelector] to identify the query (and therefore cloud function) to
/// use to select a document or documents
///
/// [executeFunction] is used to executes any other cloud function, usually
/// user-provided.
///
/// Document CRUD functionality is provided by [createDocument], [readDocument],
/// [updateDocument] and [deleteDocument].  With the exception of creating a new document
/// all require a [DocumentId] to operate on a specific document.  A GraphQL script
/// can be executed using [executeGraphQL]
///
/// [documentIdFromData] returns a [DocumentId] from a document's data, and is
/// a backend-specific implementation
///
/// [latestScript] retrieves the latest Takkan [Script]
///
/// In addition to CRUD and function calls, an [IDataProvider] implementation
/// provides a backend-specific [Authenticator], where a user is required to authenticate.
/// The [Authenticator] contains a [user] object for this data provider, holding
/// basic user information and authentication status.  Shortcuts status calls
/// are available in [userIsAuthenticated] and [userIsNotAuthenticated].
///
/// A [userRoles] call invokes a cloud function provided by the Takkan framework
/// to returns roles for the authenticated [user].
///
/// This structure means that a client app can log in as a different user
/// for each [IDataProvider] it uses.
///
/// Different implementations will provide their own [objectIdKey] and
/// [sessionTokenKey]:
///
///  - [objectIdKey] The property of a document unique id ('objectId' in Back4App)
///  - [sessionTokenKey] the HTTP header key for the session token
///
abstract class IDataProvider<CONFIG extends DataProvider> {
  Future<void> init({required CONFIG config});

  CONFIG get config;

  Authenticator<CONFIG, dynamic> get authenticator;

  /// Uses the [selector] to identify the cloud function to call via
  /// [fetchDocumentList]
  Future<ReadResultList> selectDocumentList({
    required DocumentListSelector selector,
    required String documentClass,
    Map<String, dynamic> pageArguments = const {},
  });

  /// Uses the [selector] to identify the cloud function to call via
  /// [fetchDocument]
  Future<ReadResultItem> selectDocument({
    required DocumentSelector selector,
    required String documentClass,
    Map<String, dynamic> pageArguments = const {},
  });

  /// Fetch exactly one document from the database, using the cloud function
  /// identified by [functionName].  This is usually a cloud function automatically
  /// generated from the [Schema] by the takkan_server_code_generator.
  /// It could, however, be a user-provided function as long as it meets
  /// the requirement of providing exactly one document.
  ///
  /// - [functionName] is the name of the cloud function to call
  /// - [params] are the params to pass with the call
  /// - [documentClass] is required only to pass back in the result
  ///
  /// [ReadResult.success] is false if there is not exactly one result
  Future<ReadResultItem> fetchDocument({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  });

  /// Fetch 0..n documents from the database, using the cloud function
  /// identified by [functionName].  This is usually a cloud function automatically
  /// generated from the [Schema] by the takkan_server_code_generator.
  /// It could, however, be a user-provided function as long as it meets
  /// the requirement of providing 0..n documents.
  ///
  /// - [functionName] is the name of the cloud function to call
  /// - [params] are the params to pass with the call
  /// - [documentClass] is required only to pass back in the result
  ///
  /// [ReadResult.success] is false the query fails
  Future<ReadResultList> fetchDocumentList({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  });

  /// Executes a general server side server-side function [functionName], with [params]
  Future<FunctionResult> executeFunction({
    required String functionName,
    Map<String, dynamic> params = const {},
  });

  /// Updates a document according the document type declared in its [schema].
  ///
  /// A [DocumentType.versioned] document is actually saved as a complete copy,
  /// with its version number incremented.  [data] must therefore contain
  /// the entire document
  ///
  /// A [DocumentType.standard] simply updates the existing document
  ///
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
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
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
  });

  /// Reads the document identified by [documentId]
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
  });

  /// Used only to create a completely new document.  The document is created
  /// in a way that is consistent with the document type declared in its [schema].
  ///
  /// Subsequent updates, whether [DocumentType.standard] or [DocumentType.versioned],
  /// should be amended via a call to [updateDocument]
  ///
  /// [documentClass] is the equivalent of [DocumentId.documentClass].  For Back4App
  /// this is the Class name
  Future<CreateResult> createDocument({
    required String documentClass,
    required Map<String, dynamic> data,
  });

  /// Executes the supplied GraphQL [script], optionally restricting returned fields
  /// with [fieldSelector]
  Future<ReadResult<dynamic>> executeGraphQL({
    required String script,
    FetchPolicy? fetchPolicy,
    FieldSelector? fieldSelector,
  });

  /// Returns the latest [Script] from this provider.
  ///
  /// A [Script] is identified by [name] and [locale]
  ///
  /// [fromVersion] is used to limit the number of scripts returned.  If there are
  /// multiple scripts with the same version (which should not actually happen),
  /// the one with the most recent 'updatedAt' field is returned
  ///
  ///
  Future<Script> latestScript({
    required String locale,
    required int fromVersion,
    required String name,
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

  bool get userIsAuthenticated;

  bool get userIsNotAuthenticated;

  /// The HTTP header key for the session token
  String get sessionTokenKey;

  /// The property name for the field which provides a document's unique id
  /// For example 'objectId' in Back4App
  String get objectIdKey;
}
