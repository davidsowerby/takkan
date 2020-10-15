import 'package:flutter/foundation.dart';
import 'package:precept/common/backend.dart';
import 'package:precept/common/inject.dart';
import 'package:precept/precept/mutable/model.dart';

abstract class Repository<MODEL extends DocumentModel> {
  final BackendDelegate backendDelegate = injector<BackendDelegate>();

  MODEL modelBuilder({Map<String, dynamic> data, bool canEdit});

  /// Saves a document to the backend database.
  ///
  /// If [saveChangesOnly] is true (the default) only changed properties are passed to the backend.
  ///
  ///
  /// [documentId] is only required if [model] does not contain a valid [documentId], or this is to be saved to a document
  /// different to the one from which the data was taken.  If [documentId] is provided, it takes precedence over that
  /// within the model, effectively making this a "save as" call.
  ///
  /// [documentType] affects the meta data applied to the document - not yet implemented
  ///
  /// [model] contains the data to be saved
  ///
  Future<CloudResponse> saveDocument({
    DocumentId documentId,
    @required DocumentModel model,
    DocumentType documentType = DocumentType.standard,
    bool saveChangesOnly = true,
  }) async {
    CloudResponse response = await backendDelegate.saveDocument(
      documentId: documentId,
      data: (saveChangesOnly) ? model.changes : model.output,
    );
    if (response.success) {
      model.saved();
    }
    return response;
  }
}

class BaseRepository extends Repository<DocumentModel> {
  final instance = DateTime.now();

  @override
  DocumentModel modelBuilder({Map<String, dynamic> data, bool canEdit}) {
    return DocumentModel(data: data, canEdit: canEdit, id: "not used");
  }
}
