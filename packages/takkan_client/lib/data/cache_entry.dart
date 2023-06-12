import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_client/data/streamed_output.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/data/provider/document_id.dart';

import 'cache_consumer.dart';

/// Holds a cached single document, or a list of documents.
///
/// ** Single Document **
///
/// Holds the data for a specific document within a [DocumentClassCache] instance.
/// It may initially be empty of data, which can be tested through [dataIsLoaded]
///
///
/// When [editMode] is *first* set to true, a [_mutableDocument] is created with
/// a copy of the cache data to support editing. At the same time, [_formKeys]
/// is also created.  This recognises that many instances will never be put into
/// edit mode, and thus avoids the creation of a large number of redundant
/// collections.
///
/// Once created, both [mutableDocument] and [formKeys] are then cleared when
/// reverting back to [readMode]. It is believed that clearing will be more
/// performant than releasing and re-creating them, although no profiling has
/// been done to prove this.
///
/// [_formKeys] is used to track Forms which are connected to the [mutableDocument].
/// These keys allow [flushFormsToModel] to validate and push data from active
/// forms into the [mutableDocument], prior to persisting the data.
///
/// [addForm] adds a form to [formKeys]
///
/// When a data update arrives, [externalUpdate] is invoked.
///
/// ** List of Documents **
///
/// A list of documents is held as a list for a notional root property of
/// [listRootProperty].  This allows most of the [CacheEntry] structure to remain
/// unchanged from that holding a single document.
///
const String listRootProperty='--listRoot--';

class CacheEntry implements CacheListener {
  bool _editMode = false;
  bool _dataIsLoaded = false;
  DateTime _lastUpdate;
  MutableDocument? _mutableDocument;
  late StreamedOutput _sharedOutput;
  Set<GlobalKey<FormState>>? _formKeys;
  final DocumentClassCache classCache;
  final List<CacheConsumer> consumers = List.empty(growable: true);
  final DocumentId documentId;

  CacheEntry({
    required Map<String, dynamic> data,
    required this.classCache,
    required this.documentId,
  }) : _lastUpdate = DateTime.now() {
    _sharedOutput = StreamedOutput(getEditHost: getEditHost);
    classCache.addListener(documentId, this);
    externalUpdate(data: data, documentId: documentId);
  }

  CacheEntry.forList({
    required List<Map<String, dynamic>> dataList,
    required this.classCache,
    required this.documentId,
  }) : _lastUpdate = DateTime.now() {
    _sharedOutput = StreamedOutput(getEditHost: getEditHost);
    classCache.addListener(documentId, this);
    externalUpdate(data: {listRootProperty:dataList}, documentId: documentId);
  }

  MutableDocument? getEditHost() {
    return _mutableDocument;
  }

  bool get editMode => _editMode;

  bool get isEmpty => documentId.isEmpty;

  bool get readMode => !_editMode;

  bool get dataIsLoaded => _dataIsLoaded;

  bool get dataIsNotLoaded => !_dataIsLoaded;

  StreamedOutput get output => _sharedOutput;

  DateTime get lastUpdate => _lastUpdate;

  /// True when the data is 'stale'
  bool get requiresRefresh => throw UnimplementedError();

  MutableDocument get mutableDocument {
    if (_mutableDocument != null) {
      return _mutableDocument!;
    }
    throw TakkanException('Cannot access mutable document');
  }

  setReadMode() {
    _editMode = false;
  }

  setEditMode() {
    if (_mutableDocument == null) {
      _mutableDocument = MutableDocument(sharedOutput: _sharedOutput);
    }
    if (_formKeys == null) {
      _formKeys = {};
    }
    _editMode = true;
  }

  /// Data in the cache has been updated
  void externalUpdate({
    required Map<String, dynamic> data,
    required DocumentId documentId,
  }) {
    _lastUpdate = DateTime.now();
    if (editMode) {
      mutableDocument.updateFromSource(source: data, documentId: documentId);
    } else {
      _sharedOutput.update(data: data);
    }
    _dataIsLoaded = true;
  }

  Stream<Map<String, dynamic>> get stream => _sharedOutput.stream;

  Map<String, dynamic> get data => _sharedOutput.data;

  Set<GlobalKey<FormState>> get formKeys {
    final fKeys = _formKeys;
    if (fKeys != null) {
      return fKeys;
    }
    final String msg = '_formKeys should not be null';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  close() {
    _sharedOutput.close();
    final md = _mutableDocument;
    if (md != null) {
      md.clear();
    }
    classCache.removeListener(documentId, this);
  }

  bool get streamIsActive => _sharedOutput.streamIsActive;

  onCreateDocument(CreateResult result) {
    // TODO: implement onCreateDocument
    throw UnimplementedError();
  }

  /// TODO: Seemed like a good idea, but now seems redundant
  onUpdateDocument(UpdateResult result) {}

  ModelBinding get modelBinding =>
      (editMode) ? mutableDocument.rootBinding : output.rootBinding;

  bool get isEditable => true;

  /// Iterates though form keys registered by Pages, Panels or Parts using the same [mutableDocument].
  /// Keys are added through [addForm. This method 'saves' the [Form] data -
  /// that is, it transfers data from the [Form] back to the [mutableDocument] via [Binding]s.
  bool flushFormsToModel() {
    logType(this.runtimeType).d('Flushing forms data to Mutable Document');
    bool validationResult = true;
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        final state = key.currentState!;
        bool valid = state.validate();
        if (valid) {
          state.save();
          logType(this.runtimeType).d("Form saved for $key");
        } else {
          validationResult = false;
          logType(this.runtimeType).d("Form failed validation");
        }
      }
    }
    // TODO: purge those with null current state
    return validationResult;
  }

  addConsumer(CacheConsumer consumer) {
    consumers.add(consumer);
  }

  removeConsumer(CacheConsumer consumer) {
    consumers.remove(consumer);
  }

  /// Stores a key for a Form.
  /// Forms are 'flushed' to the backing data in [mutableDocument] by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    if (_formKeys == null) {
      _formKeys = {};
    }
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  removeForm(GlobalKey<FormState> formKey) {
    if (_formKeys != null) {
      formKeys.remove(formKey);
    }
  }

  Future<bool> save() async {
    bool validationResult = flushFormsToModel();
    if (validationResult) {
      return classCache.updateDocumentOnServer(
        changes: mutableDocument.changes,
        cacheEntry: this,
        objectId: documentId.objectId,
      );
    }
    return false;
  }

  cancelChanges() {
    if (editMode) {
      _mutableDocument?.reset();
    }
  }

  @override
  onReadDocument(ReadResult<dynamic> result) {
    // TODO: implement onReadDocument
    logType(this.runtimeType).i("onReadDocument");
    // throw UnimplementedError();
  }
}

abstract class DataBinding {
  ModelBinding get modelBinding;
}

class DefaultDataBinding implements DataBinding {
  final ModelBinding modelBinding;

  const DefaultDataBinding(this.modelBinding);
}

class NullDataBinding implements DataBinding {
  @override
  ModelBinding get modelBinding => throw UnimplementedError();
}
