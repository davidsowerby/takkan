import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_client/binding/map_binding.dart';
import 'package:precept_client/data/document_cache.dart';
import 'package:precept_client/data/mutable_document.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/document_id.dart';

abstract class CacheEntry {
  Map<String, dynamic> get data;

  DateTime get lastUpdate;

  Stream<Map<String, dynamic>> get stream;

  DocumentId get documentId;

  ModelBinding get modelBinding;

  DocumentClassCache get classCache;

  void updateFromServer({
    required Map<String, dynamic> data,
    required DocumentId documentId,
  });

  /// Call before disposing of a CacheEntry completely, it needs to release
  /// resources used by StreamController
  close();

  bool get streamIsActive;

  bool get isEditable;

  EditCacheEntry makeEditable();
}

class ReadCacheEntry implements CacheEntry, CacheListener {
  final Map<String, dynamic> data;
  DateTime lastUpdate;
  final DocumentId documentId;
  late StreamController<Map<String, dynamic>> streamController;
  bool _streamIsActive = false;
  final RootBinding modelBinding;
  final DocumentClassCache classCache;

  ReadCacheEntry({
    required this.data,
    required this.documentId,
    required this.classCache,
  })  : lastUpdate = DateTime.now(),
        modelBinding = RootBinding(data: data, id: documentId.objectId) {
    streamController = StreamController<Map<String, dynamic>>.broadcast(
      onCancel: () => {_streamIsActive = false},
      onListen: () => {_streamIsActive = true},
    );
  }

  @override
  void updateFromServer({
    required Map<String, dynamic> data,
    required DocumentId documentId,
  }) {
    this.data.clear();
    this.data.addAll(data);
    lastUpdate = DateTime.now();
  }

  @override
  // TODO: implement stream
  Stream<Map<String, dynamic>> get stream => streamController.stream;

  close() {
    streamController.close();
  }

  bool get streamIsActive => _streamIsActive;

  @override
  onCreateDocument(CreateResult result) {
    // TODO: implement onCreateDocument
    throw UnimplementedError();
  }

  @override
  onUpdateDocument(UpdateResult result) {
    // TODO: implement onUpdateDocument
    throw UnimplementedError();
  }

  @override
  bool get isEditable => false;

  @override
  EditCacheEntry makeEditable() {
    return EditCacheEntry.fromReadEntry(this);
  }
}

class EditCacheEntry implements CacheEntry, CacheListener {
  DateTime lastUpdate;
  final MutableDocument mutableDocument = MutableDocument();
  final Set<GlobalKey<FormState>> _formKeys = Set();
  final DocumentClassCache classCache;

  EditCacheEntry({
    required Map<String, dynamic> data,
    required this.classCache,
    required DocumentId documentId,
  }) : lastUpdate = DateTime.now() {
    updateFromServer(data: data, documentId: documentId);
  }

  EditCacheEntry.fromReadEntry(ReadCacheEntry readEntry)
      : lastUpdate = DateTime.now(),
        classCache = readEntry.classCache {
    updateFromServer(data: readEntry.data, documentId: readEntry.documentId);
  }

  @override
  void updateFromServer({
    required Map<String, dynamic> data,
    required DocumentId documentId,
  }) {
    mutableDocument.updateFromSource(source: data, documentId: documentId);
    this.data.clear();
    this.data.addAll(data);
    lastUpdate = DateTime.now();
  }

  Stream<Map<String, dynamic>> get stream => mutableDocument.stream;

  DocumentId get documentId => mutableDocument.documentId;

  Map<String, dynamic> get data => mutableDocument.output;

  Set<GlobalKey<FormState>> get formKeys => _formKeys;

  @override
  close() {
    mutableDocument.close();
  }

  bool get streamIsActive => mutableDocument.streamIsActive;

  @override
  onCreateDocument(CreateResult result) {
    // TODO: implement onCreateDocument
    throw UnimplementedError();
  }

  /// TODO: Seemed like a good idea, but now seems redundant
  @override
  onUpdateDocument(UpdateResult result) {}

  @override
  ModelBinding get modelBinding => mutableDocument.rootBinding;

  @override
  bool get isEditable => true;

  @override
  EditCacheEntry makeEditable() {
    return this;
  }

  /// Iterates though form keys registered by Pages, Panels or Parts using the same [mutableDocument].
  /// Keys are added through [addForm], this method 'saves' the [Form] data -
  /// that is, it transfers data from the [Form] back to the [mutableDocument] via [Binding]s.
  bool flushFormToModel() {
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

  /// Stores a key for a Form.
  /// Forms are 'flushed' to the backing data in [mutableDocument] by [flushFormToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  removeForm(GlobalKey<FormState> formKey) {
    formKeys.remove(formKey);
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

class NullCacheEntry implements CacheEntry {
  final msg =
      'This class represents a null.  A real CacheEntry must ne provided';

  throwException() {
    throw PreceptException(msg);
  }

  @override
  close() {
    throwException();
  }

  @override
  Map<String, dynamic> get data => throwException();

  @override
  DocumentId get documentId => throwException();

  @override
  DateTime get lastUpdate => throwException();

  @override
  ModelBinding get modelBinding => throwException();

  @override
  Stream<Map<String, dynamic>> get stream => throwException();

  @override
  bool get streamIsActive => throwException();

  @override
  void updateFromServer(
      {required Map<String, dynamic> data, required DocumentId documentId}) {
    throwException();
  }

  @override
  bool get isEditable => false;

  @override
  EditCacheEntry makeEditable() {
    throw PreceptException(msg);
  }

  @override
  // TODO: implement classCache
  DocumentClassCache get classCache => throwException();
}
