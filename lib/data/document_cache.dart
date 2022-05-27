import 'package:takkan_client/app/takkan.dart';
import 'package:takkan_client/pod/pod_state.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_client/data/query_results.dart';
import 'package:takkan_client/pod/data_root.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/data_provider_library.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/schema/schema.dart';

/// A document based cache.
///
/// It controls all interactions with [DataProvider] (within Takkan) instances
/// to ensure the cache remains consistent.  Direct use of a [DataProvider]
/// instance is generally discouraged, but there are some valid use cases for doing so.
///
///  When [PodState] is building [TakkanPage] or [Panel], unless it is
///  using only static data, it requests a [DocumentRoot] from this cache.
///
/// The cache keeps track of which [PodState] is using which [DocumentRoot], and
/// therefore, which documents.  This allows the cache to release unused documents.
///
/// As part of this process, the [PodState.close] method notifies the cache
/// of its disposal.
///
/// Much of the work is done by [DocumentClassCache].  It is expected that a user
/// would generally work within a small number of document classes at any given time,
/// helping to keep the size of the cache down.

class DocumentCache {
  final Map<String, DocumentClassCache> _classCaches = {};

  DocumentCache();

  /// Gets a [DocumentClassCache] for [documentSchema].name.  [itemKeyId] is passed to the
  /// [DocumentClassCache] for use in identifying documents
  ///
  /// If there is no [DocumentClassCache], one is created
  DocumentClassCache getClassCache({
    required Pod config,
  }) {
    if (config.documentClass == null) {
      String msg =
          'config.documentClass cannot be null.  Have you run script.validate()?';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
    final documentClass = config.documentClass!;

    if (!_classCaches.containsKey(config.documentClass)) {
      final classCache = DocumentClassCache(
          documentClass: documentClass,
          dataProvider: _lookupDataProvider(config.dataProvider));
      classCache.init();
      _classCaches[config.documentClass!] = classCache;
    }
    final DocumentClassCache classCache = _classCaches[config.documentClass]!;
    return classCache;
  }

  IDataProvider _lookupDataProvider(DataProvider? config) {
    if (config != null) {
      return dataProviderLibrary.find(providerConfig: config);
    }
    String msg = 'Cannot look up a dataProvider class';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  /// TODO: This would cause the loss of consumer list. Needs to be smarter
  flush() {
    _classCaches.clear();
  }

  /// Returns the appropriate type of [DataContext], configured according to it [parentDataContext] and
  /// [config]
  ///
  /// | parent              | PData  | produces                                                                 |
  /// |---------------------|--------|--------------------------------------------------------------------------|
  /// | NullDataConnector   | static | static with NullDataConnector parent                                     |
  /// |                     | root   | DataRoot                                                                 |
  /// |                     | other  | fails - no root                                                          |
  /// | StaticDataConnector | static | StaticDataConnector with StaticDataConnector parent                      |
  /// |                     | root   | DataRoot                                                                 |
  /// |                     | other  | fails, unless an ancestor is DataRoot                                    |
  /// | DataRoot            | static | StaticDataConnector with DataRoot parent                                 |
  /// |                     | root   | DataRoot from PData.  New branch                                         |
  /// |                     | other  | DefaultDataConnector with dataRoot pointing to parent                    |
  /// | Other               | static | StaticDataConnector with DefaultDataConnector parent                     |
  /// |                     | root   | DataRoot from PData.  New branch                                         |
  /// |                     | other  | DefaultDataConnector, root from parent, binding from parent modelBinding |
  ///
  /// [requester] is usually a [PodState], so either a [TakkanPage] or [Panel]
  DataContext dataContext({
    required DataContext parentDataContext,
    required Pod config,
    required Data dataSelector,
  }) {
    if (parentDataContext is NullDataContext) {
      if (config.isStatic) {
        return StaticDataContext(
          parentDataContext: parentDataContext,
        );
      }
      // if (config.isDataRoot) {
      //   final classCache = getClassCache(config: config);
      //   return classCache.dataConnector(
      //     dataSelector: dataSelector,
      //     parentDataConnector: parentDataContext,
      //     config: config,
      //   );
      // }
      String msg =
          'A ${config.runtimeType.toString()} requires a data root above it in the Script';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
    // if (contentContainer.isStatic) {}
    // final PData pData = contentContainer.data!;
    throw UnimplementedError();
  }
}

/// Holds all the cached documents for a particular [documentClass], as specified
/// in a [Schema].  After [init] has been called, [documentSchema] is populated
/// from [Schema].
///
/// [dataProvider] describes the source (usually a cloud provider)
/// of the data.
///
///
/// The [_cache] holds the data wrapped in a [CacheEntry], keyed by objectId. A
/// [CacheEntry] may be a read only [ReadCacheEntry], or an editable [EditCacheEntry].
/// The latter contains a [MutableDocument] to manage the editing process.
///
/// [queryResults] hold the results of queries, but as a list of objectIds.  The
/// data for those objectIds is actually held in [_cache]
///
class DocumentClassCache {
  late Document documentSchema;
  final IDataProvider dataProvider;
  final Map<String, CacheEntry> _cache = Map();
  final QueryResultsCache queryResults = QueryResultsCache();
  final String documentClass;

  DocumentClassCache({required this.documentClass, required this.dataProvider});

  init() {
    documentSchema = _lookupDocumentSchema(documentClass);
  }

  bool cacheContains(String itemId) {
    return _cache.containsKey(itemId);
  }

  /// Gets a document from the server, and either updates the existing [CacheEntry],
  /// or creates one if none exists.
  Future<CacheEntry> readDocumentFromServer({
    required String objectId,
    bool makeEditable = false,
  }) async {
    final documentId = DocumentId(
      documentClass: documentClass,
      objectId: objectId,
    );
    final result = await dataProvider.readDocument(documentId: documentId);
    if (result.success) {
      if (_cache.containsKey(documentId.objectId)) {
        final CacheEntry existingCacheEntry = _cache[documentId.objectId]!;
        existingCacheEntry.updateFromServer(
            data: result.data, documentId: documentId);
        return existingCacheEntry;
      } else {
        if (makeEditable) {
          final EditCacheEntry entry = EditCacheEntry(
            data: result.data,
            classCache: this,
            documentId: documentId,
          );

          _cache[documentId.objectId] = entry;
          return entry;
        } else {
          final ReadCacheEntry readEntry = ReadCacheEntry(
            classCache: this,
            data: result.data,
            documentId: documentId,
          );
          _cache[documentId.objectId] = readEntry;
          return readEntry;
        }
      }
    }
    String msg='Unsuccessful read';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg); // TODO: handle properly
  }

  Document _lookupDocumentSchema(String? documentClass) {
    if (documentClass != null) {
      final schema = script.schema.documents[documentClass];
      if (schema != null) return schema;
      String msg = 'Schema is not defined for document class $documentClass';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
    String msg = 'Cannot look up a null document class';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  /// TODO: use this to set up consumers
  /// There should not generally be a need to use this method directly, it is here primarily for testing
  void addToCache(CacheEntry cacheEntry) {
    _cache[dataProvider.objectIdKey] = cacheEntry;
  }

  Map<String, dynamic>? fromCacheOnly({required Data dataSpec}) {
    final expectSingle = dataSpec is DataItem;
    if (expectSingle) {
      final DataItem pSingle = dataSpec;
      return _documentFromCache(pSingle);
    } else {
      final DataList pMulti = dataSpec as DataList;
      return _listFromCache(pMulti);
    }
  }

  Map<String, dynamic>? _listFromCache(DataList pMulti) {
    return null;
  }

  Map<String, dynamic>? _documentFromCache(DataItem pSingle) {
    return null;
  }

  /// Assumes static data has already been dealt with by [DocumentCache]
  ///
  /// Returns an appropriately configured [DataContext] based on
  /// [Pod.data] of [pod].
  // DataContext dataConnector({
  //   required DataContext parentDataConnector,
  //   required Pod config,
  //   required PData dataSelector,
  // }) {
  //   if (dataSelector.isSingle) {
  //     return _singleDataConnector(
  //       parentDataConnector: parentDataConnector,
  //       config: config,
  //       dataConfig: dataSelector,
  //     );
  //   }
  //   return _multiDataConnector(
  //     parentDataConnector: parentDataConnector,
  //     config: config,
  //     dataConfig: dataSelector,
  //   );
  // }

  DataContext _singleDataConnector({
    required DataContext parentDataConnector,
    required Pod config,
    required Data dataConfig,
  }) {
    // if (config.isDataRoot) {
    //   return dataRoot(config, listener);
    // }
    throw UnimplementedError();
  }

  // DataContext _multiDataConnector({
  //   required DataContext parentDataConnector,
  //   required Pod config,
  //   required PData dataConfig,
  // }) {
  //   /// TODO: replace - this is just getting rid of compile errors
  //   return StaticDataContext(
  //       parentDataContext: parentDataConnector, config: config);
  //   // if (config.isDataRoot) {
  //   //   return dataRoot(config, listener);
  //   // }
  //   // final root = SingleDataRoot(
  //   //     objectId: objectId, classCache: this, dataListener: listener);
  //   // _roots[objectId] = root;
  //   // requestDocument(dataRoot: root, objectId: objectId);
  //   // return root;
  // }

  // DocumentRoot singleRootFor({required String objectId}) {
  //   if (_roots.containsKey(objectId)) {
  //     return _roots[objectId]!;
  //   }
  //   final root = DocumentRoot(objectId: objectId, classCache: this);
  //   _roots[objectId] = root;
  //   requestDocument(dataRoot: root, objectId: objectId);
  //   return root;
  // }

  /// Returns cached data if it is present, then makes a call
  /// to [readDocumentFromServer] to retrieve or refresh the cache data from
  /// the server.
  ///
  /// Always returns an [EditCacheEntry], converting an existing [ReadCacheEntry]
  /// if necessary.
  ///
  ///
  /// This approach may be sub-optimal, see: https://gitlab.com/takkan_/takkan_client/-/issues/115
  Future<EditCacheEntry> requestDocument({required String objectId}) async {
    final CacheEntry? existingEntry = _cache[objectId];
    final EditCacheEntry editable;
    if (existingEntry != null) {
      if (existingEntry.isEditable) {
        editable = existingEntry as EditCacheEntry;
      } else {
        editable = existingEntry.makeEditable();
        _cache[objectId] = editable;
      }
      readDocumentFromServer(objectId: objectId, makeEditable: true);
      return editable;
    } else {
      editable =
          await readDocumentFromServer(objectId: objectId, makeEditable: true)
              as EditCacheEntry;
      return editable;
    }
  }

  /// Returns true if the update is accepted - it may not yet have reached
  /// the server.
  ///
  /// Confirmation that the change has been applied to the server is made via
  /// one of the callbacks, [DocumentRoot.onCreateDocument] or [DocumentRoot.onUpdateDocument].
  ///
  /// A new document is created if [objectId] is null, otherwise the [objectId]
  /// identifies the document to update.
  Future<bool> updateDocument({
    required String? objectId,
    required Map<String, dynamic> changes,
    required CacheEntry cacheEntry,
  }) async {
    if (objectId == null) {
      _doCreateDocument(
        onCreate: (cacheEntry as CacheListener).onCreateDocument,
        changes: changes,
      );
      return true;
    } else {
      _doUpdateDocument(
        objectId: objectId,
        changes: changes,
        onUpdate: (cacheEntry as CacheListener).onUpdateDocument,
      );
      return true;
    }
  }

  _doCreateDocument({
    required Function(CreateResult) onCreate,
    required Map<String, dynamic> changes,
  }) async {
    final CreateResult createResult = await dataProvider.createDocument(
        documentClass: documentClass, data: changes);
    onCreate(createResult);
  }

  _doUpdateDocument({
    required String objectId,
    required Map<String, dynamic> changes,
    required Function(UpdateResult) onUpdate,
  }) async {
    final UpdateResult updateResult = await dataProvider.updateDocument(
        documentId: DocumentId(
          documentClass: documentClass,
          objectId: objectId,
        ),
        data: changes);
    onUpdate(updateResult);
  }
}

abstract class CacheListener {
  /// Called when a document has been updated on the server
  onUpdateDocument(UpdateResult result);

  /// Called when a document has been create on the server
  onCreateDocument(CreateResult result);
}
