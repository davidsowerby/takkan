import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/data/select/data_selector.dart';

/// Holds all the query results for a [DocumentClassCache] instance.
///
/// Queries with potentially multiple results are assumed to be paged, and are held in [_multiples]
/// Queries which must return a single document are held separately, in [_singles]
///
/// This cache holds only the objectIds of the results, thus acting as references to the data.
///
/// The [DocumentClassCache] holds the data, which may be updated from other queries or live
/// streams.
class QueryResultsCache {
  // final DataProvider dataProvider;
  final Map<String, QueryResultsSet> _multiples = {};
  final Map<String, String> _singles = {};
  final String documentClass;

  QueryResultsCache({required this.documentClass});

  /// adds results from a query which may return 0..n entries
  void addResults({
    required DocumentListSelector selector,
    required int page,
    required List<Map<String, dynamic>> results,
  }) {
    final queryName = _queryName(selector);
    final QueryResultsSet set = _multiples.putIfAbsent(
      queryName,
      () => QueryResultsSet(),
    );
    set.addResultsPage(page: page, results: results);
  }

  /// add the result of a query that is required to return a single document
  void addResult({
    required DocumentSelector selector,
    required Map<String, dynamic> result,
  }) {
    _singles[_queryName(selector)] = result['objectId'];
  }

  /// Returns a list of objectIds for a list based [Data] implementation.
  /// For selectors which return a single item, use [resultFor]
  ///
  /// Returns null if the cache does not hold any query results for this selector
  List<String>? resultsFor({required DocumentListSelector selector, required int page}) {
    final resultSet = _multiples[_queryName(selector)];
    if (resultSet == null) {
      return null;
    }
    return resultSet[page];
  }

  /// Returns a single objectId result for [selector], or null if not in the cache
  String? resultFor({required DocumentSelector selector}) {
    return _singles[_queryName(selector)];
  }

  _queryName(DataSelector selector) {
    return '$documentClass-${selector.name}';
  }
}

/// All the results for one named query in a [QueryResults] instance, potentially
/// containing multiple pages
class QueryResultsSet {
  final Map<int, List<String>> _data = Map();

  QueryResultsSet();

  /// Add the results of a query page, keeping only the objectId, as the data
  /// itself may get updated from another query
  void addResultsPage({
    required int page,
    required List<Map<String, dynamic>> results,
  }) {
    final List<String> ids = List.empty(growable: true);
    for (final entry in results) {
      final objectId = entry['objectId'];
      if (objectId == null) {
        logType(this.runtimeType).w(
            'All documents should contain an objectId.  This entry is ignored.');
      }
      ids.add(objectId);
    }
    _data[page]=ids;
  }

  List<String>? operator [](int key) {
    return _data[key];
  }
}
