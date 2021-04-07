import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';

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
  PQuery _query;
  List<GlobalKey<FormState>> _formKeys;
  PDocument _documentSchema;
  PContent config;

  /// [callback] is usually a setState from a StatefulWidget
  DataSource(PContent config) {
    init(config);
  }

  RootBinding get rootBinding => _temporaryDocument.rootBinding;

  PDocument get documentSchema => _documentSchema;

  List<GlobalKey<FormState>> get formKeys => _formKeys;

  init(PContent config) {
    this.config = config;
    if (config.queryIsDeclared) {
      _temporaryDocument = inject<TemporaryDocument>();
      _query = config.query;
      _formKeys = List.empty(growable: true);
      _documentSchema = config.dataProvider.schema.document(_query.table);
    }
  }

  TemporaryDocument get temporaryDocument => _temporaryDocument;

  PQuery get query => _query;

  /// Stores a key for a Form.
  /// Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  /// Iterates though form keys registered by Pages, Panels or Parts using the same [temporaryDocument].
  /// Keys are added through [addForm], this method 'saves' the [Form] data -
  /// that is, it transfers data from the [Form] back to the [temporaryDocument] via [Binding]s.
  ///
  /// Returns true if validation is successful, and form data is saved back [TemporaryDocument]
  flushFormsToModel() {
    logType(this.runtimeType).d('Flushing forms data to Temporary Document');
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState.save();
        logType(this.runtimeType).d("Form saved for $key");
      }
    }
// TODO: purge those with null current state
  }

  bool validate() {
    logType(this.runtimeType).d('Validating data source');
    bool isValid = true;
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        final validated = key.currentState.validate();
        if (!validated) isValid = false;
      }
    }
    logType(this.runtimeType).d('Changes are valid? :  $isValid');
    return isValid;
  }

  Future<bool> persist() async {
    logType(this.runtimeType).d('Persisting data source');
    final DataProvider dataProvider = dataProviderLibrary.find(config: config.dataProvider);
    return dataProvider.update(
      documentId: temporaryDocument.documentId,
      changedData: temporaryDocument.changes,
      onSuccess: temporaryDocument.saved,
    );
  }

  reset() {
    temporaryDocument.reset();
  }

  TemporaryDocument updateData(
      {Map<String, dynamic> source, DocumentId documentId, bool fireListeners}) {
    return _temporaryDocument.updateFromSource(
      source: source,
      documentId: documentId,
      fireListeners: fireListeners,
    );
  }

  /// Delegate call to [TemporaryDocument.storeQueryResults]
  TemporaryDocument storeQueryResults(
      {List<Map<String, dynamic>> queryResults, bool fireListeners = false}){
    return _temporaryDocument.storeQueryResults(queryResults: queryResults,fireListeners: fireListeners);
  }

}
