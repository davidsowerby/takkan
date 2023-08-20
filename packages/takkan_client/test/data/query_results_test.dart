import 'package:mocktail/mocktail.dart';
import 'package:takkan_client/data/query_results.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:test/test.dart';

import '../helper/mock.dart';

void main() {
  group('Query Cache', () {
    late QueryResultsCache cache;
    late MockDocumentClassCache classCache;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      classCache = MockDocumentClassCache();
      const documentClass = 'Person';
      when(() => classCache.documentClass).thenReturn(documentClass);
      cache = QueryResultsCache(documentClass: documentClass);
    });

    tearDown(() {});

    test('add and return a function result', () {
      // given
      const id1 = 'objectId1';
      const queryName = 'favourite';
      const Map<String, dynamic> doc1 = {'a': 1, 'objectId': id1};
      const inputSelector = DocByFunction(cloudFunctionName: queryName);

      // when
      cache.addResult(selector: inputSelector, result: doc1);
      // then
      final actual = cache.resultFor(
        selector: DocByQuery(queryName: queryName),
      );

      expect(actual, id1);
    });

    test('add and return a single filter result', () {
      // given
      const id1 = 'objectId1';
      const queryName = 'favourite';
      const Map<String, dynamic> doc1 = {'a': 1, 'objectId': id1};
      const inputSelector = DocByQuery(queryName: queryName);

      // when
      cache.addResult(selector: inputSelector, result: doc1);
      // then
      final actual = cache.resultFor(
          selector: DocByQuery(
        queryName: queryName,
      ));
      expect(
        actual,
        id1,
      );
    });

    test('add and return a single GQL result', () {
      // given
      const id1 = 'objectId1';
      const queryName = 'favourite';
      const Map<String, dynamic> doc1 = {'a': 1, 'objectId': id1};
      const inputSelector = DocByGQL(name: queryName, script: '');

      // when
      cache.addResult(selector: inputSelector, result: doc1);

      // then
      final actual = cache.resultFor(
          selector: DocByQuery(
        queryName: queryName,
      ));
      expect(actual, id1);
    });
    test('add and return a GQL list result', () {
      // given
      const id1 = 'objectId1';
      const id2 = 'objectId2';
      const queryName = 'favourite';
      const Map<String, dynamic> doc1 = {'a': 1, 'objectId': id1};
      const Map<String, dynamic> doc2 = {'a': 2, 'objectId': id2};
      const inputSelector = DocListByGQL(name: queryName, script: '');

      // when
      cache.addResults(selector: inputSelector, results: [doc1, doc2], page: 0);
      // then
      final actual = cache.resultsFor(
        selector: DocListByGQL(
          name: queryName,
          script: 'xx',
        ),
        page: 0,
      );

      expect(actual, [id1, id2]);
    });
  });
}
