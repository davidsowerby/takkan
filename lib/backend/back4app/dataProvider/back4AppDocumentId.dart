import 'package:precept_backend/backend/document.dart';
import 'package:precept_script/script/documentId.dart';

class Back4AppDocumentIdConverter implements DocumentIdConverter {

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

}


