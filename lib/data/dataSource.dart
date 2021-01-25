import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/backend.dart';
import 'package:precept_backend/backend/backendLibrary.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/script.dart';

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
/// When [readMode] is true, the document and therefore pages using it, are read only.
/// When [canEdit] is true, [readMode] can be changed to false (thus allowing editing) by user action
///
/// Precept potentially creates a number of [Form] instances on one page, as each [Panel]
/// may have its own.  This class just holds the [GlobalKey] for each, so Form content can be pushed
/// to the [_temporaryDocument] prior to saving it.
///
class DataSource {
  TemporaryDocument _temporaryDocument;
  PDataSource _dataSource;
  List<GlobalKey<FormState>> _formKeys;
  PDocument _documentSchema;
  Backend backend;

  void Function(BackendConnectionState) callback;

  /// [callback] is usually a setState from a StatefulWidget
  DataSource(PContent config, this.callback) {
    init(config);
  }

  RootBinding get rootBinding => _temporaryDocument.rootBinding;

  PDocument get documentSchema => _documentSchema;

  List<GlobalKey<FormState>> get formKeys => _formKeys;

  init(PContent config) {
    if (config.dataSourceIsDeclared) {
      _temporaryDocument = inject<TemporaryDocument>();
      _dataSource = config.dataSource;
      _formKeys = List();
      _documentSchema = config.schema.documents[_dataSource.document];
    }
  }

  TemporaryDocument get temporaryDocument => _temporaryDocument;

  PDataSource get dataSource => _dataSource;

  _backendStateChange(BackendConnectionState state) {
    callback(state);
  }

  /// Stores a key for a Form.
  /// Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  /// Iterates though form keys registered by Pages, Panels or Parts using the same [temporaryDocument].
  /// Keys are added through [addForm], this method 'saves' the [Form] data -
  /// that is, it transfers data from the [Form] back to the [temporaryDocument] via [Binding]s.
  flushFormsToModel(TemporaryDocument temporaryDocument, List<GlobalKey<FormState>> formKeys) {
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState.save();
        logType(this.runtimeType).d("Form saved for $key");
      }
    }
    // TODO: purge those with null current state
  }

  Future<bool> persist(PCommon config) async {
    flushFormsToModel(temporaryDocument, formKeys);
    await _doPersist(config);
    return true;
  }

  _doPersist(PCommon config) async {
    final Backend backend = backendLibrary.find(config: config.backend);
    return backend.save(
      changedData: temporaryDocument.changes,
      fullData: temporaryDocument.output,
      onSuccess: temporaryDocument.saved,
    );
  }
}
