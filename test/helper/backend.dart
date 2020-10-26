import 'package:precept/backend/common/document.dart';
import 'package:precept/backend/common/documentId.dart';
import 'package:precept/backend/common/response.dart';
import 'package:precept/common/backend.dart';
import 'package:precept/precept/mutable/model.dart';

/// The [dataStore] must be held externally, as this delegate may get re-created
class MockBackendDelegate implements BackendDelegate {
  Map<String, dynamic> data;
  DocumentId documentId;
  DocumentType documentType;
  bool saveChangesOnly;
  final instance = DateTime.now();

  MockBackendDelegate();

  Future<CloudResponse> saveDocument({
    DocumentId documentId,
    Map<String, dynamic> data,
    DocumentType documentType = DocumentType.standard,
    bool saveChangesOnly = true,
  }) async {
    this.data = Map.from(data);
    this.documentId = documentId ??
        DocumentId(path: data["className"], itemId: data["objectId"]);
    this.documentType = documentType;
    this.saveChangesOnly = saveChangesOnly;

    return CloudResponse(result: [], success: true);
  }

  @override
  Future<CloudResponse> deleteDocument({DocumentId documentId}) {
    // TODO: implement deleteDocument
    throw UnimplementedError();
  }

  @override
  Future<bool> documentExists({DocumentId documentId}) {
    // TODO: implement documentExists
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> executeFunction({String functionName, Map<String, String> params}) {
    // TODO: implement executeFunction
    throw UnimplementedError();
  }

  @override
  Future<DocumentModel> getDocument({DocumentId documentId}) {
    // TODO: implement getDocument
    throw UnimplementedError();
  }

  @override
  Stream<DocumentModel> getDocumentStream({DocumentId documentId}) {
    // TODO: implement getDocumentStream
    throw UnimplementedError();
  }

  @override
  List<DocumentModel> getDocuments({functionName, Map<String, String> params}) {
    // TODO: implement getDocuments
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> selectDistinct({String path, String fieldName, fieldValue}) {
    // TODO: implement selectDistinct
    throw UnimplementedError();
  }
}
