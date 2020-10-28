import 'package:flutter/foundation.dart';
import 'package:precept/precept/dataModel/documentModel.dart';

abstract class DocumentIdConverter {
  DocumentId fromModel(DocumentModel model);

  toModel(DocumentModel model, DocumentId documentId);

  DocumentId fromNative(DocumentId documentId);

  DocumentId toNative(DocumentId documentId);
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
