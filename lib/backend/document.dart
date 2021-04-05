
import 'package:precept_script/data/provider/documentId.dart';

abstract class DocumentIdConverter {

  DocumentId fromNative(DocumentId documentId);

  DocumentId toNative(DocumentId documentId);
}

enum DocumentType { standard, versioned, formal }