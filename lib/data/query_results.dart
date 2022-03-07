import 'package:precept_client/data/document_cache.dart';
import 'package:precept_script/common/exception.dart';

/// Holds all the query results for a [DocumentClassCache] instance.
///
/// Queries with potentially multiple results are assumed to be paged, and are held in [_multiples]
/// Queries which must return a single document are held separately, in [_singles]
class QueryResultsCache {
  // final DataProvider dataProvider;
  final Map<String, QueryResultsSet> _multiples = Map();
  final Map<String, Map<String, dynamic>> _singles = Map();

  QueryResultsCache();

  addResults({
    required String queryName,
    required int page,
    required List<Map<String, dynamic>> results,
  }) {
    if (!(_multiples.containsKey(queryName))) {
      _multiples[queryName] = QueryResultsSet();
    }
    final QueryResultsSet set = _multiples[queryName]!;
    set.addPage(page: page, results: results);
  }

  addResult({
    required String queryName,
    required Map<String, dynamic> result,
  }) {
    _singles[queryName] = result;
  }
}

/// All the results for one named query in a [QueryResults] instance, potentially
/// containing multiple pages
class QueryResultsSet {
  final Map<int, QueryResultsPage> _data = Map();
  int _selectedPage = -1;

  QueryResultsSet();

  addPage({
    required int page,
    required List<Map<String, dynamic>> results,
  }) {
    if (!(_data.containsKey(page))) {
      _data[page] = QueryResultsPage();
    }
    final QueryResultsPage resultsPage = _data[page]!;
    resultsPage.results = results;
  }

  selectPage(int page) {
    _selectedPage = page;
  }

  QueryResultsPage get currentPage {
    if (_data.containsKey(_selectedPage)) {
      return _data[_selectedPage]!;
    }
    throw PreceptException('There is no page $_selectedPage');
  }

  QueryResultsPage get nextPage {
    final targetPage = _selectedPage++;
    if (_data.containsKey(targetPage)) {
      selectPage(targetPage);
      return _data[targetPage]!;
    }
    throw PreceptException('There is no page $targetPage');
  }

  QueryResultsPage get previousPage {
    final targetPage = _selectedPage--;
    if (_data.containsKey(targetPage)) {
      selectPage(targetPage);
      return _data[targetPage]!;
    }
    throw PreceptException('There is no page $targetPage');
  }
}

/// One page of query results, a member of a  [QueryResultsSet]
class QueryResultsPage {
  List<Map<String, dynamic>> results = [];
}
