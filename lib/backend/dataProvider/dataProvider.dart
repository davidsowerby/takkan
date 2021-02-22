import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/query.dart';

/// The layer between the client and server.
///
/// It provides a consistent data access interface regardless of the type of data provider used.
/// Most of the work is actually done in specific implementations.
///
/// It is hoped that differences between for example, Firebase and Back4App can be manageed by using
/// the relevant implementation of [PDataProvider].  However, in case that is not possible, it is simple
/// to [registerWithEmail] an alternative implementation of [DataProvider]
///
///
/// Some calls may not be supported by an implementation, in which case it will throw a [APINotSupportedException]

abstract class DataProvider {
  /// ================================================================================================
  /// All 'getXXX' methods use the standard 'database' access of a typical backend SDK
  /// For methods accessing Cloud Functions, use the 'fetchXXXX' methods
  /// ================================================================================================

  /// Returns a single instance of [Data] identified by [documentId]
  ///
  /// Throws an [APIException] if not found
  Future<Data> get({@required PGet query});

  /// Returns a Stream of [Data] identified by [documentId]
  ///
  /// Throws an [APIException] if not found
  Stream<Data> getStream({@required DocumentId documentId});

  /// Returns a list of [Data] instances for the document selected by [query]
  ///
  /// May return an empty list
  /// Throws an [APIException] if the query is not valid
  Future<Data> getList({@required PQuery query});

  /// Returns a Stream of List<Data> instances for the document selected by [query]
  ///
  /// May return an empty list
  /// throws an [APIException] if the query is not valid
  Stream<List<Data>> getListStream({@required PQuery query});

  /// Returns a single instance of [Data] for the [query]
  ///
  /// Throws an [APIException] if the result is not exactly one instance
  Future<Data> getDistinct({@required PQuery query});

  /// Returns a single instance of [Data] for the [query]
  ///
  /// Throws an [APIException] if the result is not exactly one instance
  Stream<Data> getDistinctStream({@required PQuery query});

  /// ================================================================================================
  /// All 'fetchXXX' methods call Cloud Functions
  /// To access the standard 'database' access of a typical backend SDK, use the 'getXXXX' methods
  /// Note there are no Streams returned by these calls
  /// ================================================================================================

  /// Returns a single instance of [Data] identified by [documentId], from a CloudFunction
  ///
  /// Throws an [APIException] if not found
  Future<Data> fetch({@required String functionName, @required DocumentId documentId});

  /// Returns a single instance of [Data] from a Cloud Function.
  ///
  ///
  /// Throws an [APIException] if the result is not exactly one instance, or the function call fails
  Future<Data> fetchDistinct({@required String functionName, Map<String, dynamic> params});

  /// Returns a list of [Data] instances by the cloud function [functionName] when executed wth [params]
  ///
  /// May return an empty list
  /// Throws an APIException if the function call fails
  Future<List<Data>> fetchList({@required functionName, Map<String, String> params});

  /// ================================================================================================
  /// Other calls
  /// ================================================================================================

  /// Returns true if the document exists, false otherwise
  Future<bool> exists({@required DocumentId documentId});

  /// Invokes a Cloud Function
  ///
  /// The result is determined by the Cloud Function, and is return in the [CloudResponse.result]
  Future<CloudResponse> executeFunction(
      {@required String functionName, Map<String, dynamic> params});

  /// Saves a complete document to the data provider
  ///
  /// [documentId] identifies the document to be saved
  ///
  /// [documentType] affects the meta data applied to the document - not yet implemented
  ///
  /// [fullData] contains the data to be saved
  ///
  Future<CloudResponse> save({
    @required DocumentId documentId,
    @required Map<String, dynamic> fullData,
    DocumentType documentType = DocumentType.standard,
    Function() onSuccess,
  });

  /// Creates new document to the data provider
  ///
  /// [documentId.path] must be provided.  [documentId.itemId] is ignored
  ///
  /// [documentType] affects the meta data applied to the document - not yet implemented
  ///
  /// [fullData] provides the data to be saved
  ///
  Future<CloudResponse> create({
    @required DocumentId documentId,
    @required Map<String, dynamic> fullData,
    DocumentType documentType = DocumentType.standard,
    Function() onSuccess,
  });

  /// Updates a document to the data provider.
  ///
  /// [changedData] should contain only those properties which should be updated
  ///
  /// [documentId] identifies the document to be updated
  ///
  /// [documentType] affects the meta data applied to the document - not yet implemented
  ///
  /// [onSuccess] is a callback invoked on successful update
  ///
  /// returns true if successful, throws an [APIException] on failure
  /// see also [save]
  Future<bool> update({
    @required DocumentId documentId,
    @required Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
    Function() onSuccess,
  });

  /// Deletes one or more documents from persistence.
  ///
  /// Nothing happens if the document does not exist
  /// The [CloudResponse.success] will be false, and [CloudResponse.errorMessage] will be set if other failures occur,
  /// for example lack of permissions.
  Future<CloudResponse> delete({@required List<DocumentId> documentIds});


}


