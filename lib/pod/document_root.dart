import 'package:flutter/widgets.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/page/edit_state.dart';

mixin DocRoot {
  CacheEntry cacheEntry = NullCacheEntry();
  final formKey = GlobalKey<FormState>();
  String? currentObjectId;
  late EditState editState;

  beforeEditStateChange(bool newReadModeState) {
    if (!cacheEntry.isEditable) {
      cacheEntry = cacheEntry.makeEditable();
      (cacheEntry as EditCacheEntry).addForm(formKey);
    }
  }

  /// Validates and flushes form to model if valid
  /// Returns false if not valid
  bool flushFormToModel() {
    final EditCacheEntry editEntry = cacheEntry as EditCacheEntry;
    return editEntry.flushFormToModel();
  }

  /// Check whether there are any unsaved changes
  bool requestNavigateAway() {
    return true;
  }

  void persist() {
    final EditCacheEntry editEntry = cacheEntry as EditCacheEntry;
    cacheEntry.classCache.updateDocument(
      changes: editEntry.mutableDocument.changes,
      cacheEntry: cacheEntry,
      objectId: editEntry.documentId.objectId,
    );
  }
}
