import 'package:mocktail/mocktail.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/query_selector.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:test/test.dart';

import '../../fixtures/mocks.dart';

void main() {
  late QuerySelector selector;
  late IDataProvider provider;
  const String documentClass = 'Person';
  group('DefaultQuerySelector', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      provider = MockDataProvider();
      selector = DefaultQuerySelector(dataProvider: provider);
    });

    tearDown(() {});

    test('DataItemById', () async {
      // given
      const objectId = 'xxxxx';
      const documentId = DocumentId(
        objectId: objectId,
        documentClass: documentClass,
      );
      when(() => provider.readDocument(documentId: documentId)).thenAnswer(
          (_) => Future.value(ReadResultItem(
              data: {'objectId': objectId, 'number': 3},
              success: true,
              queryReturnType: QueryReturnType.futureItem,
              documentClass: documentClass)));
      // when
      final result = await selector.dataItem(
          documentClass: documentClass,
          selector: DataItemById(
            objectId: objectId,
            name: 'xName',
          ));
      // then

      expect(result.objectId, objectId);
    });
    test('DataItemByFunction', () async {
      // given
      const cloudFunctionName = 'callMe';
      const objectId = 'xxxxx';

      when(() => provider.executeItemFunction(
                functionName: cloudFunctionName,
                params: {'a': 'b'},
                documentClass: 'Person',
              ))
          .thenAnswer((_) => Future.value(ReadResultItem(
              data: {'objectId': objectId, 'number': 3},
              success: true,
              queryReturnType: QueryReturnType.futureItem,
              documentClass: documentClass)));
      // when
      final result = await selector.dataItem(
          documentClass: documentClass,
          selector: DataItemByFunction(
            cloudFunctionName: cloudFunctionName,
            params: {'a': 'b'},
          ));
      // then

      expect(result.objectId, objectId);
    });
  });
}
