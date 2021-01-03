import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/query/query.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/library/backendLibrary.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';

/// The layer between the client and server.
///
/// It provides a common authentication and data access interface regardless of the backend employed.
/// All the work is delegated to [backendDelegate], for a backend-specific implementation.
///
/// Some calls may not be supported by an implementation, in which case it will throw a [APINotSupportedException]
class Backend {
  final BackendDelegate backendDelegate;

  Backend({@required PBackend config})
      : backendDelegate = backendLibrary.find(config.backendType, config);

  /// ================================================================================================
  /// All 'getXXX' methods use the standard 'database' access of a typical backend SDK
  /// For methods accessing Cloud Functions, use the 'fetchXXXX' methods
  /// ================================================================================================

  /// Returns a single instance of [Data] identified by [documentId]
  ///
  /// Throws an [APIException] if not found
  Future<Data> get({@required PDataGet config}) {
    return backendDelegate.get(documentId: config.documentId);
  }

  /// Returns a Stream of [Data] identified by [documentId]
  ///
  /// Throws an [APIException] if not found
  Stream<Data> getStream({@required DocumentId documentId}) {
    return backendDelegate.getStream(documentId: documentId);
  }

  /// Returns a list of [Data] instances for the document selected by [query]
  ///
  /// May return an empty list
  /// Throws an [APIException] if the query is not valid
  Future<Data> getList({@required Query query}) {
    return backendDelegate.getList(query: query);
  }

  /// Returns a Stream of List<Data> instances for the document selected by [query]
  ///
  /// May return an empty list
  /// throws an [APIException] if the query is not valid
  Stream<List<Data>> getListStream({@required Query query}) {
    return backendDelegate.getListStream(query: query);
  }

  /// Returns a single instance of [Data] for the [query]
  ///
  /// Throws an [APIException] if the result is not exactly one instance
  Future<Data> getDistinct({@required Query query}) {
    return backendDelegate.getDistinct(query: query);
  }

  /// Returns a single instance of [Data] for the [query]
  ///
  /// Throws an [APIException] if the result is not exactly one instance
  Stream<Data> getDistinctStream({@required Query query}) {
    return backendDelegate.getDistinctStream(query: query);
  }

  /// ================================================================================================
  /// All 'fetchXXX' methods call Cloud Functions
  /// To access the standard 'database' access of a typical backend SDK, use the 'getXXXX' methods
  /// Note there are no Streams returned by these calls
  /// ================================================================================================

  /// Returns a single instance of [Data] identified by [documentId], from a CloudFunction
  ///
  /// Throws an [APIException] if not found
  Future<Data> fetch({@required String functionName, @required DocumentId documentId}) {
    return backendDelegate.fetch(functionName: functionName, documentId: documentId);
  }

  /// Returns a single instance of [Data] from a Cloud Function.
  ///
  ///
  /// Throws an [APIException] if the result is not exactly one instance, or the function call fails
  Future<Data> fetchDistinct({@required String functionName, Map<String, dynamic> params}) {
    return backendDelegate.fetchDistinct(functionName: functionName, params: params);
  }

  /// Returns a list of [Data] instances by the cloud function [functionName] when executed wth [params]
  ///
  /// May return an empty list
  /// Throws an APIException if the function call fails
  Future<List<Data>> fetchList({@required functionName, Map<String, String> params}) {
    return backendDelegate.fetchList(functionName: functionName, params: params);
  }

  /// ================================================================================================
  /// Other calls
  /// ================================================================================================

  /// Returns true if the document exists, false otherwise
  Future<bool> exists({@required DocumentId documentId}) {
    return backendDelegate.exists(documentId: documentId);
  }

  /// Invokes a Cloud Function
  ///
  /// The result is determined by the Cloud Function, and is return in the [CloudResponse.result]
  Future<CloudResponse> executeFunction(
      {@required String functionName, Map<String, dynamic> params}) {
    return backendDelegate.executeFunction(functionName: functionName, params: params);
  }

  /// Saves a document to the backend database.
  ///
  /// If [saveChangesOnly] is true (the default) only changed properties are passed to the backend.
  ///
  ///
  /// [documentId] is only required if [script] does not contain a valid [documentId], or this is to be saved to a document
  /// different to the one from which the data was taken.  If [documentId] is provided, it takes precedence over that
  /// within the model, effectively making this a "save as" call.
  ///
  /// [documentType] affects the meta data applied to the document - not yet implemented
  ///
  /// [script] contains the data to be saved
  ///
  Future<CloudResponse> save({
    DocumentId documentId,
    @required TemporaryDocument data,
    DocumentType documentType = DocumentType.standard,
    bool saveChangesOnly = true,
  }) async {
    CloudResponse response = await backendDelegate.save(
      documentId: documentId,
      changedData: data.changes,
      fullData: data.output,
    );
    if (response.success) {
      data.saved();
    }
    return response;
  }

  /// Deletes one or more documents from persistence.
  ///
  /// Nothing happens if the document does not exist
  /// The [CloudResponse.success] will be false, and [CloudResponse.errorMessage] will be set if other failures occur,
  /// for example lack of permissions.
  Future<CloudResponse> delete({@required List<DocumentId> documentIds}) {
    return backendDelegate.delete(documentIds: documentIds);
  }
}
