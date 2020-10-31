import 'package:flutter/foundation.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';

/// Represents the current editing state of a document, and holds a temporary copy of the document
/// for editing purposes, in [temporaryDocument]
///
/// When [readOnlyMode] is true, the document and therefore pages using it, are read only.
/// When [canEdit] is true, [readOnlyMode] can be changed to false (thus allowing editing) by user action
class DocumentState with ChangeNotifier {
   TemporaryDocument temporaryDocument;
   bool _readOnlyMode=true;
   bool _canEdit;

  DocumentState({bool canEdit=true, bool readOnlyMode=true}) : _readOnlyMode=readOnlyMode, _canEdit=canEdit {
    temporaryDocument = inject<TemporaryDocument>();
  }

  RootBinding get rootBinding=> temporaryDocument.rootBinding;
  bool get readOnlyMode => _readOnlyMode;
  bool get canEdit => _canEdit;

  set readOnlyMode(bool value){
    _readOnlyMode=value;
    notifyListeners();
  }
}
