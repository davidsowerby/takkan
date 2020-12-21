import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/query/query.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_script/script/dataSource.dart';

abstract class BackendDelegate {
  /// ================================================================================================
  /// All 'getXXX' methods use the standard 'database' access of a typical backend SDK
  /// For methods accessing Cloud Functions, use the 'fetchXXXX' methods
  /// ================================================================================================

  /// See [BackendHandler.get]
  Future<Data> get({@required DocumentId documentId});

  /// See [BackendHandler.getStream]
  Stream<Data> getStream({@required DocumentId documentId});

  /// See [BackendHandler.getList]
  Future<Data> getList({Query query});

  /// See [BackendHandler.getListStream]
  Stream<List<Data>> getListStream({Query query});

  /// See [BackendHandler.getDistinct]
  Future<Data> getDistinct({Query query});

  /// See [BackendHandler.getDistinctStream]
  Stream<Data> getDistinctStream({Query query});

  /// ================================================================================================
  /// All 'fetchXXX' methods call Cloud Functions
  /// To access the standard 'database' access of a typical backend SDK, use the 'getXXXX' methods
  /// Note there are no Streams returned by these calls
  /// ================================================================================================

  /// See [BackendHandler.fetch]
  Future<Data> fetch({@required String functionName, @required DocumentId documentId});

  /// See [BackendHandler.fetchDistinct]
  Future<Data> fetchDistinct({@required String functionName, Map<String, dynamic> params});

  /// See [BackendHandler.fetchList]
  Future<List<Data>> fetchList({@required String functionName, Map<String, String> params});

  /// ================================================================================================
  /// General calls
  /// ================================================================================================

  /// See [BackendHandler.exists]
  Future<bool> exists({@required DocumentId documentId});

  /// See [BackendHandler.executeFunction]
  Future<CloudResponse> executeFunction(
      {@required String functionName, Map<String, String> params});

  /// [BackendHandler.save] prepares the data and passes it to this method for a backend-specific save
  Future<CloudResponse> save({
    DocumentId documentId,
    Map<String, dynamic> data,
  });

  /// See [BackendHandler.delete]
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

