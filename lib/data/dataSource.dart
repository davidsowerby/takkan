import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/mutable/temporaryDocument.dart';
import 'package:precept_script/common/logger.dart';
import 'package:precept_script/script/dataSource.dart';

/// The intersection point between application and data.
///
/// Retrieval of data is specified by [config], which specifies both the data required (effectively a Query) and the
/// [PBackend] to retrieve it from.
///
/// Holds a copy of the retrieved data in [_temporaryDocument], and notifies listeners
/// as the retrieval state changes.  The retrieval state mirrors that used by [FutureBuilder] and [StreamBuilder]
/// depending on whether [config] requires a Future or Stream in response.
///
/// [_temporaryDocument] records all changes in its [TemporaryDocument.changeList]
///
/// Once data has been retrieved, [_temporaryDocument.output] is connected to a [RootBinding],
/// for [DataBinding] instances to connect to.  In this way, [DataBindings] provide a connection chain
/// from the data source to the element which actually displays the data.
///
/// When [readOnlyMode] is true, the document and therefore pages using it, are read only.
/// When [canEdit] is true, [readOnlyMode] can be changed to false (thus allowing editing) by user action
///
/// Precept potentially creates a number of [Form] instances on one page, as each [Panel]
/// may have its own.  This class just holds the [GlobalKey] for each, so Form content can be pushed
/// to the [_temporaryDocument] prior to saving it.
///
class DataSource with ChangeNotifier {
  final PDataSource config;
  TemporaryDocument _temporaryDocument;
  bool _readOnlyMode = true;
  bool _canEdit;

  DataSource({bool canEdit = true, bool readOnlyMode = true, @required this.config})
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
    if (readOnly) {
      return false;
    }
    flushFormsToModel();
    await _doPersist();
    return true;
  }

  _doPersist() {
    return Future.value(true); // TODO: save it through the Repo layer
  }

  final List<GlobalKey<FormState>> formKeys = List();

  /// Called by a [Section] creating a Form.  Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  /// Iterates though form keys registered by [Section] instances through [addForm], 'saves' the [Form] - that is, transfers data from
  /// the [Form] back to the [DataSource] via [Binding]s - the bindings are provided by [Part] components
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

  /// Uses [config] to connect to the data.  Returns either a Future<Data> or a Stream<Data> depending
  /// on the [config] type
  connectToData() {
    return null;
  }
}
