import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_client/app/takkan.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_client/data/query_results.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/data_selector.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_schema/schema/schema.dart';

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
          dataProvider:
              _lookupDataProvider(providerConfig: config.dataProvider!));
      classCache.init();
      _classCaches[config.documentClass!] = classCache;
    }
    final DocumentClassCache classCache = _classCaches[config.documentClass]!;
    return classCache;
  }

  /// Selects the [IDataProvider] identified by [providerConfig]
  IDataProvider _lookupDataProvider({required DataProvider providerConfig}) {
    final AppConfig appConfig = inject<AppConfig>();
    final instanceConfig = appConfig.instanceConfig(providerConfig);
    final IDataProvider provider =
        inject<IDataProvider>(instanceName: instanceConfig.uniqueName);
    provider.init(config: providerConfig);
    return provider;
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
    required DataSelector dataSelector,
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
/// [queryCache] hold the results of queries. See [QueryResultsCache].
class DocumentClassCache {
  late Document documentSchema;
  final IDataProvider dataProvider;
  final Map<String, CacheEntry> _cache = Map();
  late QueryResultsCache queryCache;

  final String documentClass;
  final Map<String, List<CacheListener>> listeners = {};

  DocumentClassCache({required this.documentClass, required this.dataProvider});

  init() {
    queryCache = QueryResultsCache(documentClass: documentClass);
    documentSchema = _lookupDocumentSchema(documentClass);
  }

  void addListener(DocumentId documentId, CacheListener listener) {
    _checkDocId(documentId);
    final e = listeners[documentId.objectId];
    if (e == null) {
      listeners[documentId.objectId] = List.empty(growable: true);
    }
    final f = listeners[documentId.objectId];
    if (f != null) {
      f.add(listener);
    }
  }

  void removeListener(DocumentId documentId, CacheListener listener) {
    _checkDocId(documentId);
    final e = listeners[documentId.objectId];
    if (e != null) {
      e.remove(listener);
    }
  }

  void _checkDocId(DocumentId documentId) {
    if (documentId.isEmpty) {
      final String msg = 'DocumentId cannot be empty';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
    if (documentId.documentClass != documentClass) {
      final String msg =
          'document class of documentId must match document class of this cache';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
  }

  bool cacheContains(String itemId) {
    return _cache.containsKey(itemId);
  }

  /// Reads a document from the server, and either updates the existing [CacheEntry],
  /// or creates one if none exists.
  ///
  /// [listeners] are notified
  ///
  /// Invokes the [callback] with the result
  void readDocumentFromServer({
    required DocumentSelector dataSelector,
    required void Function(CacheEntry newEntry) callback,
  }) async {
    final result = await dataProvider.selectDocument(
      selector: dataSelector,
      documentClass: documentClass,
    );
    if (!result.success) {
      String msg = 'Unsuccessful read';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg); // TODO: handle properly
    }

    /// Use existing entry or create a new one with empty data
    final cacheEntry = _cache.containsKey(result.objectId)
        ? _cache[result.objectId]!
        : CacheEntry(
            classCache: this,
            data: {},
            documentId: result.documentId,
          );

    cacheEntry.externalUpdate(data: result.data, documentId: result.documentId);

    /// This seems redundant, as callback target is also a listener, but it may
    /// not yet have the [cacheEntry]
    callback(cacheEntry);

    final documentListeners = listeners[result.objectId];
    if (documentListeners != null) {
      for (final listener in documentListeners) {
        listener.onReadDocument(result);
      }
    }
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

  Map<String, dynamic>? fromCacheOnly({required DataSelector dataSpec}) {
    final expectSingle = dataSpec is DocumentSelector;
    if (expectSingle) {
      final DocumentSelector pSingle = dataSpec;
      return _documentFromCache(pSingle);
    } else {
      final DocumentListSelector pMulti = dataSpec as DocumentListSelector;
      return _listFromCache(pMulti);
    }
  }

  Map<String, dynamic>? getDocument(String objectId) {
    final ce = _cache[objectId];
    return (ce == null) ? null : ce.data;
  }

  Map<String, dynamic>? _listFromCache(DocumentListSelector pMulti) {
    return null;
  }

  Map<String, dynamic>? _documentFromCache(DocumentSelector pSingle) {
    return null;
  }

  /// If a [CacheEntry] does not exist or needs a refresh, a call is made to
  /// [readDocumentFromServer], which will retrieve data and update the cache.
  ///
  /// If there is an existing entry [callback] is invoked with it, so that the UI
  /// can continue with the cached entry.
  ///
  /// The original approach was probably sub-optimal, see: https://gitlab.com/takkan_/takkan_client/-/issues/115
  /// However, current design may have overcome that issue.  TODO: review
  void requestDocument({
    required DocumentSelector dataSelector,
    required void Function(CacheEntry newEntry) callback,
  }) async {
    final CacheEntry? existingEntry = _cache[dataSelector];
    if (existingEntry == null || existingEntry.requiresRefresh) {
      readDocumentFromServer(dataSelector: dataSelector, callback: callback);
    }
    if (existingEntry != null) {
      callback(existingEntry);
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
  Future<bool> updateDocumentOnServer({
    required String? objectId,
    required Map<String, dynamic> changes,
    required CacheEntry cacheEntry,
  }) async {
    if (objectId == null) {
      _doCreateDocument(
        onCreate: cacheEntry.onCreateDocument,
        changes: changes,
      );
      return true;
    } else {
      _doUpdateDocument(
        objectId: objectId,
        changes: changes,
        onUpdate: cacheEntry.onUpdateDocument,
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

  /// Called when a document has been read from the server
  onReadDocument(ReadResult result);
}
