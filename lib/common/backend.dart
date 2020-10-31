import 'package:flutter/foundation.dart';
import 'package:precept/backend/common/response.dart';
import 'package:precept/precept/dataModel/documentModel.dart';
import 'package:precept/precept/model/modelDocument.dart';

/// Converts a response from a cloud provider (currently Back4App) to a standard form.  This enables the Repository layer
/// to decouple from a chosen backend provider
abstract class BackendDelegate<MODEL extends DocumentModel> {
  /// See [Repository.getDocument]
  Future<MODEL> getDocument({@required DocumentId documentId});

  /// See [Repository.getDocumentStream]
  Stream<MODEL> getDocumentStream({@required DocumentId documentId});

  /// See [Repository.getDocuments]
  List<MODEL> getDocuments(
      {@required functionName, Map<String, String> params});

  /// See [Repository.executeFunction]
  Future<CloudResponse> executeFunction(
      {@required String functionName, Map<String, String> params});

  /// [Repository.saveDocument] prepares the data and passes it to this method for a backend-specific save
  Future<CloudResponse> saveDocument({
    DocumentId documentId,
    Map<String, dynamic> data,
  });

  /// See [Repository.deleteDocument]
  Future<CloudResponse> deleteDocument({@required DocumentId documentId});

  /// See [Repository.documentExists]
  Future<bool> documentExists({@required DocumentId documentId});

  /// See [Repository.selectedDistinct]
  Future<CloudResponse> selectDistinct({
    @required String path,
    @required String fieldName,
    @required dynamic fieldValue,
  });
}




