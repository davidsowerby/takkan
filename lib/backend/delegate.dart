import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/query/query.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_script/script/documentId.dart';

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
    Map<String, dynamic> changedData,
    Map<String, dynamic> fullData,
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

