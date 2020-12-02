import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/backend/data.dart';
import 'package:precept_client/backend/document.dart';
import 'package:precept_client/backend/query.dart';
import 'package:precept_client/backend/response.dart';
import 'package:precept_client/precept/library/backendLibrary.dart';
import 'package:precept_client/precept/mutable/temporaryDocument.dart';
import 'package:precept_client/precept/script/backend.dart';
import 'package:precept_client/precept/script/document.dart';

/// The layer between the client and server.
///
/// It provides a common authentication and data access interface regardless of the backend employed.
/// All the work is delegated to [backendDelegate], for a backend-specific implementation.
///
/// Some calls may not be supported by an implementation, in which case it will throw a [APINotSupportedException]
class Backend {
  final BackendDelegate backendDelegate;

  Backend({ @required PBackend config})
      : backendDelegate = backendLibrary.find(config.backendType, config);

  /// ================================================================================================
  /// All 'getXXX' methods use the standard 'database' access of a typical backend SDK
  /// For methods accessing Cloud Functions, use the 'fetchXXXX' methods
  /// ================================================================================================

  /// Returns a single instance of [Data] identified by [documentId]
  ///
  /// Throws an [APIException] if not found
  Future<Data> get({@required PDocumentGet config}) {
    return backendDelegate.get(documentId: config.id);
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
      data: (saveChangesOnly) ? data.changes : data.output,
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

abstract class BackendDelegate {
  /// ================================================================================================
  /// All 'getXXX' methods use the standard 'database' access of a typical backend SDK
  /// For methods accessing Cloud Functions, use the 'fetchXXXX' methods
  /// ================================================================================================

  /// See [Backend.get]
  Future<Data> get({@required DocumentId documentId});

  /// See [Backend.getStream]
  Stream<Data> getStream({@required DocumentId documentId});

  /// See [Backend.getList]
  Future<Data> getList({Query query});

  /// See [Backend.getListStream]
  Stream<List<Data>> getListStream({Query query});

  /// See [Backend.getDistinct]
  Future<Data> getDistinct({Query query});

  /// See [Backend.getDistinctStream]
  Stream<Data> getDistinctStream({Query query});

  /// ================================================================================================
  /// All 'fetchXXX' methods call Cloud Functions
  /// To access the standard 'database' access of a typical backend SDK, use the 'getXXXX' methods
  /// Note there are no Streams returned by these calls
  /// ================================================================================================

  /// See [Backend.fetch]
  Future<Data> fetch({@required String functionName, @required DocumentId documentId});

  /// See [Backend.fetchDistinct]
  Future<Data> fetchDistinct({@required String functionName, Map<String, dynamic> params});

  /// See [Backend.fetchList]
  Future<List<Data>> fetchList({@required String functionName, Map<String, String> params});

  /// ================================================================================================
  /// General calls
  /// ================================================================================================

  /// See [Backend.exists]
  Future<bool> exists({@required DocumentId documentId});

  /// See [Backend.executeFunction]
  Future<CloudResponse> executeFunction(
      {@required String functionName, Map<String, String> params});

  /// [Backend.save] prepares the data and passes it to this method for a backend-specific save
  Future<CloudResponse> save({
    DocumentId documentId,
    Map<String, dynamic> data,
  });

  /// See [Backend.delete]
  Future<CloudResponse> delete({@required List<DocumentId> documentIds});

  /// ================================================================================================
  /// Precept calls
  /// ================================================================================================

  /// Loads a Precept model
  ///
  /// This call only returns a model if there is a version >= [minimumVersion]
  ///
  /// If [CloudResponse.success] is true, [CloudResponse.result] will contain the model
  /// If [CloudResponse.success] is false, [CloudResponse.result] is a message indicating the reason
  Future<CloudResponse> loadPreceptModel({int minimumVersion});

  /// Loads a Precept Schema
  ///
  /// This call only returns a schema if there is a version >= [minimumVersion]
  ///
  /// If [CloudResponse.success] is true, [CloudResponse.result] will contain the schema
  /// If [CloudResponse.success] is false, [CloudResponse.result] is a message indicating the reason
  Future<CloudResponse> loadPreceptSchema({int minimumVersion});

  /// ================================================================================================
  /// Authorisation calls
  /// ================================================================================================

  /// ================================================================================================
  /// Feature Switch (combine with Precept???????
  /// ================================================================================================
}

class APIException implements Exception {
  final String message;
  final int statusCode;

  const APIException({this.message, this.statusCode});

  String errMsg() => message;
}

class APINotSupportedException implements Exception {
  final String message;
  final int statusCode;

  const APINotSupportedException({this.message, this.statusCode});

  String errMsg() => message;
}
