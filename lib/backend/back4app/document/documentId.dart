import 'package:precept/backend/common/documentId.dart';
import 'package:precept/precept/dataModel/documentModel.dart';

class Back4AppDocumentIdConverter implements DocumentIdConverter {
  @override
  DocumentId fromModel(DocumentModel model) {
    return (DocumentId(
        path: model.rootBinding.read()["className"],
        itemId: model.rootBinding.read()["objectId"]));
  }

  /// Back4App doesn't actually have a native document reference, unlike Firebase, so this is just to satisfy the interface
  @override
  DocumentId fromNative(DocumentId native) {
    return native;
  }

  /// Back4App doesn't actually have a native document reference, unlike Firebase, so this is just to satisfy the interface
  @override
  DocumentId toNative(DocumentId documentId) {
    return documentId;
  }

  @override
  toModel(DocumentModel model, DocumentId native) {
    model.rootBinding.read()["className"] = native.path;
    model.rootBinding.read()["objectId"] = native.itemId;
  }
}
