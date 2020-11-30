import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/mutable/temporaryDocument.dart';
import 'package:precept_client/precept/script/script.dart';

/// Represents the current editing state of a document, and holds a temporary copy of the document
/// for editing purposes, in [_temporaryDocument]
///
/// When [readOnlyMode] is true, the document and therefore pages using it, are read only.
/// When [canEdit] is true, [readOnlyMode] can be changed to false (thus allowing editing) by user action
///
/// Precept potentially creates a number of [Form] instances on one page, as each [Section]
/// may have its own.  This class just holds the [GlobalKey] for each, so that all can be saved
/// when a document save is executed.
class DocumentState with ChangeNotifier {
  final PDocument config;
  TemporaryDocument _temporaryDocument;
  bool _readOnlyMode = true;
  bool _canEdit;

  DocumentState({bool canEdit = true, bool readOnlyMode = true, @required this.config})
      : _readOnlyMode = readOnlyMode,
        _canEdit = canEdit {
    _temporaryDocument = inject<TemporaryDocument>();
  }

  RootBinding get rootBinding => _temporaryDocument.rootBinding;

  bool get readOnlyMode => _readOnlyMode;

  bool get canEdit => _canEdit;

  set readOnlyMode(bool value) {
    _readOnlyMode = value;
    notifyListeners();
  }

  updateData(Map<String, dynamic> data) {
    _temporaryDocument.updateFromSource(source: data);
  }

  Future<bool> persist(BuildContext context, bool readOnly) async {
    if(readOnly){
      return false;
    }
    flushFormsToModel();
    await _doPersist();
    return true;
  }

  _doPersist(){
    return Future.value(true);  // TODO: save it through the Repo layer
  }

  final List<GlobalKey<FormState>> formKeys = List();

  /// Called by a [Section] creating a Form.  Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  /// Iterates though form keys registered by [Section] instances through [addForm], 'saves' the [Form] - that is, transfers data from
  /// the [Form] back to the [DocumentState] via [Binding]s - the bindings are provided by [Part] components
  /// within the [Section] (and therefore within the [Form] if the [Section] is in edit mode.)
  flushFormsToModel() {
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState.save();
        logType(this.runtimeType).d("Form saved for $key");
      }
    }
    // TODO: purge those with null current state
  }
}
