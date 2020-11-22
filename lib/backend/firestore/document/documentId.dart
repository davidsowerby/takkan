import 'package:precept_client/backend/common/documentIdConverter.dart';
import 'package:precept_client/precept/dataModel/documentModel.dart';
import 'package:precept_client/precept/model/modelDocument.dart';

class FirebaseDocumentIdConverter implements DocumentIdConverter {
  @override
  DocumentId fromModel(DocumentModel model) {
    // TODO: implement fromModel
    throw UnimplementedError();
  }

  @override
  DocumentId fromNative(DocumentId native) {
    // TODO: implement fromNative
    throw UnimplementedError();
  }

  @override
  DocumentId toNative(DocumentId documentId) {
    // TODO: implement toNative
    throw UnimplementedError();
  }

  @override
  toModel(DocumentModel model, DocumentId native) {
    // TODO: implement toModel
    throw UnimplementedError();
  }
}
