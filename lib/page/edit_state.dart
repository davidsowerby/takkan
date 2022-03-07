import 'package:flutter/widgets.dart';
import 'package:precept_client/data/cache_entry.dart';
import 'package:precept_client/data/mutable_document.dart';
import 'package:precept_client/pod/document_root.dart';
import 'package:precept_script/common/log.dart';

/// [readMode] determines the display of [Part] elements - for example, [Text] if true, [TextField] if false
/// [canEdit] reflects whether the [readMode] status can be changed, and typically enables / disables the display of an 'edit' icon
/// [documentRoots] are the pages and panels which hold the root of a document.  These are informed
/// of pending state changes to enable actions such as preparing their [CacheEntry] for editing, and
/// flushing forms to a [MutableDocument] prior to saving the document.
class EditState with ChangeNotifier {
  bool _canEdit;
  bool _readMode;
  final List<DocRoot> documentRoots = List.empty(growable: true);

  EditState({bool canEdit = true, bool readMode = true})
      : _readMode = readMode,
        _canEdit = canEdit;

  /// If you want to be sure that you use editMode correctly, do not invert this.  See [editMode]
  bool get readMode {
    return _readMode;
  }

  /// The inverse of [readMode]
  bool get editMode {
    return (!_readMode);
  }

  bool get canEdit {
    return _canEdit;
  }

  set readMode(bool value) {
    if (!canEdit && value) return;
    for (DocRoot documentRoot in documentRoots) {
      documentRoot.beforeEditStateChange(value);
      _readMode = value;
    }
    logType(this.runtimeType).d("EditState changed to readMode: $value");
    notifyListeners();
  }

  set canEdit(bool value) {
    _canEdit = value;
    notifyListeners();
  }

  disableCanEdit() {
    _canEdit = false;
  }

  /// An [EditState] may contain multiple [DocRoot] instances, which need to be notified of
  /// impending state changes
  registerDocumentRoot(DocRoot documentRoot) {
    documentRoots.add(documentRoot);
  }

  /// Removes a [DocRoot] from [documentRoots].  Usually only called from the dispose method
  /// of the Page or Panel
  deRegisterDocumentRoot(DocRoot documentRoot) {
    documentRoots.remove(documentRoot);
  }

  void save() {
    for (DocRoot documentRoot in documentRoots) {
      bool valid = documentRoot.flushFormToModel();
      if (valid) {
        documentRoot.persist();
        readMode = true;
      }
    }
  }
}
