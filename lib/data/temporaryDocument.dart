import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/documentId.dart';

enum ChangeType { update, remove, add, clear, createNew }

class ChangeEntry {
  final ChangeType type;
  final String key;

  ChangeEntry({@required this.type, @required this.key});
}

/// Provides a copy of document data for isolation while editing).
///
/// - [output] holds the current, up to date set of data, with edits applied,
/// - [changes] holds only those entries which have changed since the last [save],
/// - [changeList] holds a chronological list of changes made, each represented by a [ChangeEntry]
/// - [initialData] holds the data as it was before editing commenced.  This is updated when [saveDocument] is called
///
/// An instance is usually held within a [DocumentModel] to retain a local copy
/// of data while editing, and before persisting.  To support streams, call [updateFromSource] when the stream emit an event.
///
/// Sets meta data of the copy data before saving, according to the [DocumentType]
///
/// Notifies listeners when a data change is made.  This is usually monitored by the editor to call setState.
///
/// Presents a Map interface to users. When a change to data is made, the first level key that has changed value
/// is captured in the [changeList].  When a nested change is made (for example to a collection deeper into the document structure),
/// the [Binding] notifies the [TemporaryDocument] so that the change is recorded.
///
/// Data is set by calling [createNew] and externally modified by [updateFromSource]
///
///

abstract class TemporaryDocument with ChangeNotifier {
  static const String documentTypeProperty = "documentType";
  static const String updatedByUserIdProperty = "updatedByUserId";
  static const String updatedByUserTimestampProperty = "updatedByUserTimestamp";
  static const String updatedByUserNameProperty = "updatedByUserName";
  static const String versionKeyProperty = "versionKey";

  static const String updatedByServerProperty = "updatedByServer";
  static const String eventIdProperty = "eventId";

  static const String fromVersionKeyProperty = "fromVersionKey";
  static const String fromUpdatedByUserNameProperty = "fromUpdatedByUserName";
  static const String metaProperty = "metax";

  Iterable<String> get keys => output.keys;

  Map<String, dynamic> get output;

  Map<String, dynamic> get changes;

  Map<String, dynamic> get initialData;

  RootBinding get rootBinding;

  Object remove(Object key);

  /// Resets the output to [initialData] and cancels all changes made
  void reset();

  /// Used as a callback by [Repository] to enable resetting of [initialData].  There should otherwise be no need to call
  /// this method
  void saved();

  operator []=(String key, dynamic value);

  dynamic operator [](Object key);

  /// Updates both [initialData] and [output].
  /// - [initialData] reflects exactly what is received from the source
  /// - [output] reflects what has been received from the source, but with changes reapplied from the [changeList]
  TemporaryDocument updateFromSource(
      {@required Map<String, dynamic> source,
      @required DocumentId documentId,
      bool fireListeners = false});

  /// Creates a "new" document from [initialData], clearing any existing data
  TemporaryDocument createNew({Map<String, dynamic> initialData = const {}});

  void nestedChange(String firstLevelKey);

  Map get metaData;

//  void prepareMetaData(UserState user, {DocumentType documentType = DocumentType.standard});

  List<ChangeEntry> get changeList;

  DocumentId get documentId;
}

class DefaultTemporaryDocument extends MapBase<String, dynamic>
    with ChangeNotifier
    implements TemporaryDocument {
  final DateTime timestamp;
  final Map<String, dynamic> _output = Map<String, dynamic>();
  final List<ChangeEntry> _changeList = List.empty(growable: true);
  final Map<String, dynamic> _changes = Map<String, dynamic>();
  final Map<String, dynamic> _initialData = Map<String, dynamic>();
  final instance = DateTime.now();
  RootBinding _rootBinding;
  DocumentId _documentId;

  DefaultTemporaryDocument() : timestamp = DateTime.now() {
    _rootBinding = RootBinding(data: _output, editHost: this, id: "not used");
  }

  DocumentId get documentId => _documentId;

  @override
  Iterable<String> get keys => _output.keys;

  Map<String, dynamic> get changes => Map.from(_changes);

  Map<String, dynamic> get initialData => Map.from(_initialData);

  Map<String, dynamic> get output => Map.from(_output);

  RootBinding get rootBinding => _rootBinding;

  @override
  Object remove(Object key) {
    final removed = _output.remove(key);
    _changeList.add(ChangeEntry(type: ChangeType.remove, key: key.toString()));
    _changes.remove(key);
    notifyListeners();
    return removed;
  }

  @override
  void reset() {
    _output.clear();
    _changeList.clear();
    _changes.clear();
    _output.addAll(_initialData);
    notifyListeners();
  }

  @override
  void clear() {
    reset();
    _documentId = null;
    _initialData.clear();
  }

  @override
  operator []=(String key, dynamic value) {
    _output[key] = value;
    _changeList.add(ChangeEntry(type: ChangeType.update, key: key));
    _changes[key] = value;
    notifyListeners();
  }

  @override
  dynamic operator [](Object key) {
    return _output[key];
  }

  /// Updates [_output] by accepting the new source and then overwriting it with any [changes] already made locally.
  ///
  /// By default listeners are not notified of this change because it is expected that the call to this method will be
  /// in the host's build' method - and we cannot call setState during a build.  Set [fireListeners] to true to
  /// override this default
  ///
  /// See also [createNew]
  TemporaryDocument updateFromSource(
      {@required Map<String, dynamic> source,
      @required DocumentId documentId,
      bool fireListeners = false}) {
    assert(source != null);
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
  TemporaryDocument createNew({Map<String, dynamic> initialData = const {}}) {
    reset();
    _initialData.clear();
    _initialData.addAll(initialData);
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
    logType(this.runtimeType).d("nested change notification received for '$firstLevelKey'");
    _changeList.add(ChangeEntry(type: ChangeType.update, key: firstLevelKey));
    _changes[firstLevelKey] = _output[firstLevelKey];
    notifyListeners();
  }

  Map get metaData {
    return _output[TemporaryDocument.metaProperty];
  }

  @override
  void saved() {
    _initialData.clear();
    _initialData.addAll(_output);
    _changes.clear();
    _changeList.clear();
  }
}
