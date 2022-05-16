import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:takkan_client/binding/map_binding.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/provider/document_id.dart';

enum ChangeType { update, remove, add, clear, createNew }

class ChangeEntry {
  final ChangeType type;
  final String key;

  ChangeEntry({required this.type, required this.key});
}

const String documentTypeProperty = "documentType";
const String updatedByUserIdProperty = "updatedByUserId";
const String updatedByUserTimestampProperty = "updatedByUserTimestamp";
const String updatedByUserNameProperty = "updatedByUserName";
const String versionKeyProperty = "versionKey";

const String updatedByServerProperty = "updatedByServer";
const String eventIdProperty = "eventId";

const String fromVersionKeyProperty = "fromVersionKey";
const String fromUpdatedByUserNameProperty = "fromUpdatedByUserName";
const String metaProperty = "metax";

class MutableDocument extends MapBase<String, dynamic> with ChangeNotifier {
  final DateTime timestamp;
  final Map<String, dynamic> _output = Map<String, dynamic>();
  final List<ChangeEntry> _changeList = List.empty(growable: true);
  final Map<String, dynamic> _changes = Map<String, dynamic>();
  final Map<String, dynamic> _initialData = Map<String, dynamic>();
  late StreamController<Map<String, dynamic>> streamController;

  final instance = DateTime.now();
  bool _streamIsActive = false;
  late RootBinding _rootBinding;

  late DocumentId _documentId;

  /// Adds an event listener to itself.  This is to ensure [outputStream]
  /// and listeners get the same events
  ///
  /// Sets up [StreamController] for [stream]
  MutableDocument() : timestamp = DateTime.now() {
    _rootBinding = RootBinding(data: _output, editHost: this, id: "not used");
    addListener(_fireStreamEvent);
    streamController = StreamController<Map<String, dynamic>>.broadcast(
      onCancel: () => {_streamIsActive = false},
      onListen: () => {_streamIsActive = true},
    );
  }

  close() {
    streamController.close();
    removeListener(_fireStreamEvent);
    super.dispose();
  }

  DocumentId get documentId => _documentId;

  @override
  Iterable<String> get keys => _output.keys;

  Map<String, dynamic> get changes => Map.from(_changes);

  Map<String, dynamic> get initialData => Map.from(_initialData);

  Map<String, dynamic> get output => Map.from(_output);

  RootBinding get rootBinding => _rootBinding;

  Stream<Map<String, dynamic>> get stream => streamController.stream;

  @override
  Object remove(Object? key) {
    final removed = _output.remove(key);
    _changeList.add(ChangeEntry(type: ChangeType.remove, key: key.toString()));
    _changes.remove(key);
    notifyListeners();
    return removed;
  }

  /// We take a copy of [_output] to post onto the stream, because [_output]
  /// may change before the event is actioned
  _fireStreamEvent() {
    if (_streamIsActive) {
      streamController.add(Map.from(_output));
    }
  }

  /// Resets the output to [initialData] and cancels all changes made
  void reset() {
    _output.clear();
    _changeList.clear();
    _changes.clear();
    _output.addAll(_initialData);
    notifyListeners();
  }

  @override
  void clear() {
    _initialData.clear();
    reset();
    _documentId = const DocumentId(documentClass: '', objectId: '?');
  }

  @override
  operator []=(String key, dynamic value) {
    _output[key] = value;
    _changeList.add(ChangeEntry(type: ChangeType.update, key: key));
    _changes[key] = value;
    notifyListeners();
  }

  @override
  dynamic operator [](Object? key) {
    return _output[key];
  }

  /// Updates both [initialData] and [output].
  /// - [initialData] reflects exactly what is received from the source
  /// - [output] reflects what has been received from the source, but with changes reapplied from the [changeList]
  ///
  /// Updates [_output] by accepting the new source and then overwriting it with any [changes] already made locally.
  ///
  /// By default listeners are not notified of this change because it is expected that the call to this method will be
  /// in the host's build' method - and we cannot call setState during a build.  Set [fireListeners] to true to
  /// override this default
  ///
  /// See also [createNew]
  MutableDocument updateFromSource({required Map<String, dynamic> source,
    required DocumentId documentId,
    bool fireListeners = false}) {
    _initialData.clear();
    _initialData.addAll(source);
    _output.clear(); // we have to clear - keys may have been deleted
    _output.addAll(source); // output is now a copy of the source
    _output.addAll(_changes); // re-apply changes
    _documentId = documentId;
    return this;
  }

  /// 'Creates' a new document [output], [changes] and [changeList] are cleared, but instances not changed.  This is to
  /// ensure that the [RootBinding] connected to this document remains connected.  All changes are lost.
  MutableDocument createNew({Map<String, dynamic> initialData = const {}}) {
    _output.clear();
    _changeList.clear();
    _changes.clear();
    _initialData.clear();
    _initialData.addAll(initialData);
    _output.addAll(_initialData);
    notifyListeners();
    return this;
  }

  List<ChangeEntry> get changeList {
    return List.from(_changeList);
  }

//  /// Sets up meta meta prior to saving (updating) the document.  [documentType] is only used when there is no previously
//  /// defined metaData
//  /// If no [documentType] is specified either by parameter or previous document content, a default of [DocumentType.standard]
//  /// is used.
//  void prepareMetaData(UserState user, {DocumentType documentType = DocumentType.standard}) {
//    assert(documentType != null);
//    if (metaData == null || metaData.isEmpty) {
//      output[TemporaryDocument.metaProperty] = Map<String, dynamic>();
//    }
//    if (metaData[TemporaryDocument.documentTypeProperty] == null) {
//      metaData[TemporaryDocument.documentTypeProperty] = documentType.toString();
//    }
//
//    metaData[TemporaryDocument.updatedByUserNameProperty] = user.displayName;
//    metaData[TemporaryDocument.updatedByUserIdProperty] = user.userId;
//    final timestamp = Timestamp.now();
//    metaData[TemporaryDocument.updatedByUserTimestampProperty] = timestamp;
//
//    final actualDocumentType = DocumentType.values
//        .firstWhere((f) => f.toString() == metaData[TemporaryDocument.documentTypeProperty], orElse: () => null);
//
//    switch (actualDocumentType) {
//      case DocumentType.standard:
//      // We don't need anything else for standard
//        break;
//      case DocumentType.versioned:
//        final String dateStr = timestamp.toDate().toString();
//        metaData[TemporaryDocument.versionKeyProperty] =
//        "${metaData[TemporaryDocument.updatedByUserIdProperty]}:$dateStr";
//        break;
//      case DocumentType.formal:
//        break;
//    }
//  }

  /// Called by bindings to indicate a change below the first level of keys.
  void nestedChange(String firstLevelKey) {
    logType(this.runtimeType)
        .d("nested change notification received for '$firstLevelKey'");
    _changeList.add(ChangeEntry(type: ChangeType.update, key: firstLevelKey));
    _changes[firstLevelKey] = _output[firstLevelKey];
    notifyListeners();
  }

  Map get metaData {
    return _output[metaProperty];
  }

  bool get streamIsActive => _streamIsActive;

  /// Used as a callback to enable resetting of [initialData].  There should otherwise be no need to call
  /// this method
  void saved() {
    _initialData.clear();
    _initialData.addAll(_output);
    _changes.clear();
    _changeList.clear();
  }

  /// Stores a single result query
  MutableDocument storeQueryResult({required String queryName,
    required Map<String, dynamic> queryResults,
    bool fireListeners = false}) {
    return createNew(initialData: queryResults);
  }
}
