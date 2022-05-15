import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/binding/map_binding.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/data/document_cache.dart';
import 'package:precept_client/data/mutable_document.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/schema/schema.dart';

/// The data root for a single document.
///
/// It holds a [MutableDocument] to facilitate editing.
///
/// Precept potentially creates a number of [Form] instances on one page, as each
/// [PanelWidget] may have its own.  This class holds the [GlobalKey] for each, in [formKeys],
/// so Form content can be flushed to the [_mutableDocument] prior to saving it.
///
/// As part of that process, validation is carried out as defined by [documentSchema].
///
/// A copy of the retrieved data is held in [_mutableDocument].  In the [classCache], when
/// the data changes, listeners are notified and a [stream] event is posted.
///
/// [_mutableDocument] records all changes in its [MutableDocument.changeList]
///
/// Once data has been retrieved, [_mutableDocument.output] is connected to a [RootBinding],
/// for lower order [Binding] instances to connect to.  In this way, [Binding] provide a connection chain
/// from the data source to the element which actually displays the data.  The [Binding]
/// also provides type conversion where required.
///
/// The ultimate data source is actually the [DocumentClassCache], but the data is copied into
/// [_mutableDocument] for editing and binding as described above.
///
/// [isReady] is true when data has been loaded, or a blank new document prepared.
/// It switches to false if an external update occurs, until the update has completed,
/// when changes back to true.
///
///
///
/// See also [DataContext] description
///
class DocumentRoot implements CacheListener {
  final MutableDocument _mutableDocument = MutableDocument();
  final List<GlobalKey<FormState>> _formKeys = List.empty(growable: true);
  bool _isReady = false;
  final DocumentClassCache classCache;
  final String objectId;

  DocumentRoot({
    required this.classCache,
    required this.objectId,
  }) {
    _requestDataFromCache();
  }

  Map<String, dynamic> get output => _mutableDocument.output;

  Stream<Map<String, dynamic>> get stream => _mutableDocument.stream;

  String get documentClass => classCache.documentClass;

  /// Resets the output to [initialData] and cancels all changes made - essentially
  /// a rollback of changes
  cancelChanges() {
    _mutableDocument.reset();
  }

  /// Requests data - the cache will call [dataChange] when data is available
  _requestDataFromCache() {
    // classCache.requestDocument(dataRoot: this, objectId: objectId);
  }

  Document get documentSchema => classCache.documentSchema;

  IDataProvider get dataProvider => classCache.dataProvider;

  ModelBinding get modelBinding => _mutableDocument.rootBinding;

  DocumentRoot get dataRoot => this;

  bool get isRoot => true;

  bool get isReady => _isReady;

  bool get isStatic => false;

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

  /// Used externally (by the [DocumentClassCache] to advise that the data this
  /// [DocumentRoot] is interested in has changed.
  void dataChange(String objectId, Map<String, dynamic> data) {
    logType(this.runtimeType).d("Data change");
    _mutableDocument.updateFromSource(
      source: data,
      documentId: DocumentId(
        documentClass: classCache.documentClass,
        objectId: objectId,
      ),
    );
    _setReady(true);
  }

  _setReady(bool newState) {
    if (newState != _isReady) {
      _isReady = newState;
    }
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

  Future<bool> save() async {
    if (validate()) {
      logType(this.runtimeType).d('Updating document');
      flushFormsToModel();
      // return classCache.updateDocument(
      //   objectId: _mutableDocument[dataProvider.objectIdKey],
      //   changes: _mutableDocument.changes,
      //   dataRoot: this,
      // );
    }
    return false;
  }

  /// Stores a key for a Form.
  /// Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  List<GlobalKey<FormState>> get formKeys => _formKeys;

  void setSelection({required String objectId}) {
    _setReady(false);
    _requestDataFromCache();
  }

  /// Called when a document has been created on the server
  @override
  onCreateDocument(CreateResult result) {
    // TODO: implement onCreateDocument
    throw UnimplementedError();
  }

  /// Called when a document has been updated on the server
  @override
  onUpdateDocument(UpdateResult result) {
    // TODO: implement onUpdateDocument
    throw UnimplementedError();
  }

}
