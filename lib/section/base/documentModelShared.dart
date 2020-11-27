import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/backend/common/response.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/common/repository.dart';
import 'package:precept_client/precept/dataModel/documentModel.dart';

/// [readOnlyMode] means the document is read only, but can be changed to edit mode by the user if [_canEdit] is true
/// [documentEditMode] determines whether to use a Form or Wizard when editing.  Ignored if [canChangeEdit] is false
class DocumentModelShared with ChangeNotifier {
  bool _readOnly = true;
  bool _canEdit;
  String _tableInFocus;
  bool tableReadOnly = true;
  DocumentEditMode _documentEditMode = DocumentEditMode.form;
  final List<GlobalKey<FormState>> formKeys = List();
  final DocumentModel model;

  DocumentModelShared(
      {bool readOnlyMode = true, bool canEdit = false, this.model})
      : _readOnly = readOnlyMode,
        _canEdit = canEdit;

  bool get hasTableInFocus {
    return (tableInFocus != null);
  }

  Future<CloudResponse> persist() async {
    flushFormsToModel();
    return await BaseRepository().saveDocument(model: model);
  }

  bool get readMode {
    return _readOnly;
  }

  set readMode(bool value) {
    if (_canEdit) {
      if (_readOnly != value) {
        _readOnly = value;
        notifyListeners();
      }
    }
  }

  String get tableInFocus {
    return _tableInFocus;
  }

  set tableInFocus(value) {
    _tableInFocus = value;
    notifyListeners();
  }

  /// Called by a [Section] creating a Form.  Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  /// Iterates though form keys registered by [Section] instances through [addForm], 'saves' the [Form] - that is, transfers data from
  /// the [Form] back to the [DocumentModel] via [Binding]s - the bindings are provided by [Part] components
  /// within the [Section] (and therefore within the [Form] if the [Section] is in edit mode.)
  /// Calling [persist] will also invoke this.
  flushFormsToModel() {
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState.save();
        logType(this.runtimeType).d("Form saved for $key");
      }
    }
  }

  bool get propertyReadOnly {
    return (hasTableInFocus) ? tableReadOnly : readMode;
  }

  bool get canEdit {
    return _canEdit;
  }

  set canEdit(bool value) {
    _canEdit = value;
    notifyListeners();
  }

  DocumentEditMode get documentEditMode => _documentEditMode;

  set documentEditMode(DocumentEditMode value) {
    _documentEditMode = value;
    notifyListeners();
  }

  /// If the section edit state has changed to [readOnly]==true, persist the document changes made so far
  sectionEditStateChanged(bool readOnly) {
    if (readOnly) {
      persist();
    }
  }
}

enum DocumentEditMode { form, wizard }
