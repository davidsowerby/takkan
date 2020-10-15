import 'package:flutter/foundation.dart';
import 'package:precept/precept/mutable/model.dart';

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

/// Standardised document reference, which is converted to / from whatever the cloud provider uses, by an implementation of
/// [DocumentIdConverter].
/// For example, Back4App (ParseServer) uses this as path==className and itemId==objectId
class DocumentId {
  /// The path to the document, but not including the [itemId]
  final String path;

  final String itemId;

  const DocumentId({@required this.path, @required this.itemId});
}

class CloudResponse {
  final dynamic result;
  final bool success;

  const CloudResponse({@required this.success, this.result});
}
