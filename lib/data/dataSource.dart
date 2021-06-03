import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';

/// The intersection point between application and data.
///
/// Retrieval of data, where required, is specified by a [query] defined within [config].  This query
/// relates to a specific [DataProvider].  A fully static page does not of course require data at all.
///
/// A copy of the retrieved data is held in [_temporaryDocument], and notifies listeners
/// as the retrieval state changes.  The retrieval state mirrors that used by [FutureBuilder] and [StreamBuilder]
/// depending on whether [config] requires a Future or Stream in response.
///
/// [_temporaryDocument] records all changes in its [MutableDocument.changeList]
///
/// Once data has been retrieved, [_temporaryDocument.output] is connected to a [RootBinding],
/// for [DataBinding] instances to connect to.  In this way, [DataBindings] provide a connection chain
/// from the data source to the element which actually displays the data.
///
/// In addition to retrieving data from [query], data may also be passed in [initialData].  This is usually
/// passed from a page displaying a list of query results. A query is then automatically created so that
/// data can be refreshed if required.
///
/// When [readMode] is true, the document and therefore pages using it, are read only.
/// When [canEdit] is true, [readMode] can be changed to false (thus allowing editing) by user action
///
/// Precept potentially creates a number of [Form] instances on one page, as each [Panel]
/// may have its own.  This class just holds the [GlobalKey] for each, so Form content can be pushed
/// to the [_temporaryDocument] prior to saving it.
///
class DataSource {
  late MutableDocument _temporaryDocument;
  late PQuery _query;
  late List<GlobalKey<FormState>> _formKeys;
  late PDocument _documentSchema;
  PContent config;
  final DataProvider dataProvider;
  final bool preloadedData;
  final String dataTableName;

  /// [callback] is usually a setState from a StatefulWidget
  DataSource(
      {required this.config,
      required this.dataProvider,
      required this.preloadedData,
      required this.dataTableName}) {
    init(config);
  }

  RootBinding get rootBinding => _temporaryDocument.rootBinding;

  PDocument get documentSchema => _documentSchema;

  List<GlobalKey<FormState>> get formKeys => _formKeys;

  init(PContent config) {
    this.config = config;
    if (config.queryIsDeclared || preloadedData) {
      _temporaryDocument = inject<MutableDocument>();
      _formKeys = List.empty(growable: true);
      final providerSchema = config.dataProvider?.schema;
      if (providerSchema == null) throw PreceptException('Schema must be defined');
      if (preloadedData) {
        // TODO: _query is not set, but should we in case of the need to refresh?  Would have to construct query.
        _documentSchema = providerSchema.document(dataTableName);
      } else {
        _query = config.query!;
        _documentSchema = providerSchema.document(_query.table);
      }
    }
  }

  MutableDocument get temporaryDocument => _temporaryDocument;

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
  /// Returns true if validation is successful, and form data is saved back [MutableDocument]
  flushFormsToModel() {
    logType(this.runtimeType).d('Flushing forms data to Temporary Document');
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState!.save();
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
        final bool validated = key.currentState!.validate();
        if (!validated) isValid = false;
      }
    }
    logType(this.runtimeType).d('Changes are valid? :  $isValid');
    return isValid;
  }

  Future<bool> persist() async {
    logType(this.runtimeType).d('Persisting data source');
    final dataProviderConfig=config.dataProvider;
    if (dataProviderConfig==null){
      throw PreceptException('DataProvider config should not be null');
    }
    final DataProvider dataProvider = await dataProviderLibrary.find(config: dataProviderConfig);
    return dataProvider.updateDocument(
      documentId: temporaryDocument.documentId,
      changedData: temporaryDocument.changes,
    );
  }

  reset() {
    temporaryDocument.reset();
  }

  MutableDocument updateDocument(
      {required Map<String, dynamic> source,required  DataProvider dataProvider,required  bool fireListeners}) {
    final DocumentId documentId = dataProvider.documentIdFromData(source);
    return _temporaryDocument.updateFromSource(
      source: source,
      documentId: documentId,
      fireListeners: fireListeners,
    );
  }

  /// Delegate call to [MutableDocument.storeQueryResults]
  MutableDocument storeQueryResults({
    required String queryName,
    required List<Map<String, dynamic>> queryResults,
    bool fireListeners = false,
  }) {
    return _temporaryDocument.storeQueryResults(
      queryName: queryName,
      queryResults: queryResults,
      fireListeners: fireListeners,
    );
  }
}
