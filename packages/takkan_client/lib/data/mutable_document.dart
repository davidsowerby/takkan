import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/streamed_output.dart';
import 'package:takkan_schema/common/log.dart';
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

/// Used to edit documents.  [_checkpoint] is first populated from the data source.
///
/// A copy is transferred to [_output].  The [_rootBinding] is connected to the
/// [_output], as the first link in a chain down through child [Binding]
/// instances as far as is needed through a document.
///
/// [Binding] instances also feed updates to data back in to the [_output].
///
/// If changes need to be cancelled, [_output] is reverted to [_checkpoint]
///
/// The output can be shared by providing the optional [sharedOutput] constructor
/// parameter.  Be aware however, that if you do this you are responsible for
/// managing any changes which occur directly on the [output]
class MutableDocument with ChangeNotifier {
  final DateTime timestamp;
  late StreamedOutput _output;
  final List<ChangeEntry> _changeList = List.empty(growable: true);
  final Map<String, dynamic> _changes = Map<String, dynamic>();
  final Map<String, dynamic> _checkpoint = Map<String, dynamic>();

  final instance = DateTime.now();

  late DocumentId _documentId;

  MutableDocument({StreamedOutput? sharedOutput}) : timestamp = DateTime.now() {
    _output = sharedOutput ?? StreamedOutput(getEditHost: () => this);
  }

  DocumentId get documentId => _documentId;

  Iterable<String> get keys => _output.data.keys;

  Map<String, dynamic> get changes => Map.from(_changes);

  Map<String, dynamic> get checkpoint => Map.from(_checkpoint);

  StreamedOutput get output => _output;

  RootBinding get rootBinding => _output.rootBinding;

  Object remove(String key) {
    final removed = _output.remove(key);
    _changeList.add(ChangeEntry(type: ChangeType.remove, key: key.toString()));
    _changes.remove(key);
    notifyListeners();
    return removed;
  }

  /// Resets the output to [checkpoint] and cancels all changes made
  void reset() {
    _changeList.clear();
    _changes.clear();
    _output.update(data: _checkpoint);
    notifyListeners();
  }

  void clear() {
    _checkpoint.clear();
    reset();
    _documentId = DocumentId.empty();
  }

  operator []=(String key, dynamic value) {
    _output[key] = value;
    _changeList.add(ChangeEntry(type: ChangeType.update, key: key));
    _changes[key] = value;
    notifyListeners();
  }

  dynamic operator [](Object? key) {
    return _output.data[key];
  }

  /// Updates both [checkpoint] and [output].
  /// - [checkpoint] reflects exactly what is received from the source
  /// - [output] reflects what has been received from the source, but with changes reapplied from the [changeList]
  ///
  /// Updates [_output] by accepting the new source and then overwriting it with any [changes] already made locally.
  ///
  /// By default listeners are not notified of this change because it is expected that the call to this method will be
  /// in the host's build' method - and we cannot call setState during a build.  Set [fireListeners] to true to
  /// override this default
  ///
  /// See also [createNew]
  MutableDocument updateFromSource(
      {required Map<String, dynamic> source,
      required DocumentId documentId,
      bool fireListeners = false}) {
    _checkpoint.clear();
    _checkpoint.addAll(source);

    /// We want to reapply changes before passing to [_output] so that only one stream event is created
    final temp = Map<String, dynamic>.from(source);
    temp.addAll(_changes);

    _output.update(data: temp);
    _documentId = documentId;
    if (fireListeners) notifyListeners();
    return this;
  }

  /// 'Creates' a new document [output], [changes] and [changeList] are cleared, but instances not changed.  This is to
  /// ensure that the [RootBinding] connected to this document remains connected.  All changes are lost.
  ///
  /// If [initialData] is not empty, the new document is populated with this new data
  MutableDocument createNew({Map<String, dynamic> initialData = const {}}) {
    _changeList.clear();
    _changes.clear();
    _checkpoint.clear();
    if (initialData.isNotEmpty) {
      _checkpoint.addAll(initialData);
    }
    _output.update(data: _checkpoint);
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

  /// Callback to reset [checkpoint] to the state of the saved output
  void onSaved() {
    _checkpoint.clear();
    _checkpoint.addAll(_output.data);
    _changes.clear();
    _changeList.clear();
  }

  /// Stores a single result query
  MutableDocument storeQueryResult(
      {required String queryName,
      required Map<String, dynamic> queryResults,
      bool fireListeners = false}) {
    return createNew(initialData: queryResults);
  }
}
