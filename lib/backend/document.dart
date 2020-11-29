

import 'package:precept_client/precept/dataModel/documentModel.dart';
import 'package:precept_client/precept/model/modelDocument.dart';

abstract class DocumentIdConverter {
  DocumentId fromModel(DocumentModel model);

  toModel(DocumentModel model, DocumentId documentId);

  DocumentId fromNative(DocumentId documentId);

  DocumentId toNative(DocumentId documentId);
}

enum DocumentType { standard, versioned, formal }