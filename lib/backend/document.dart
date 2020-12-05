

import 'package:precept_client/precept/script/data.dart';

abstract class DocumentIdConverter {

  DocumentId fromNative(DocumentId documentId);

  DocumentId toNative(DocumentId documentId);
}

enum DocumentType { standard, versioned, formal }