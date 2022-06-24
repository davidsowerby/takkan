import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/data/select/data_item.dart';

import 'data_provider.dart';

/// Backend specific implementations convert the query 'specification' defined
/// by [Data] instances, and return either a single document (from [dataItem])
/// or a list of documents [dataList]
abstract class QuerySelector {
  Future<ReadResultItem> dataItem({
    required String documentClass,
    required IDataItem selector,
  });

  Future<ReadResultList> dataList({
    required String documentClass,
    required IDataList selector,
  });
}

/// Converts the query 'specification' defined
/// by [Data] instances, and return either a single document (from [dataItem])
/// or a list of documents [dataList]
class DefaultQuerySelector implements QuerySelector {
  final IDataProvider dataProvider;

  DefaultQuerySelector({required this.dataProvider});

  @override
  Future<ReadResultItem> dataItem({
    required String documentClass,
    required IDataItem selector,
  }) {
    switch (selector.runtimeType) {
      case DataItemById:
        {
          final documentId = DocumentId(
              documentClass: documentClass,
              objectId: (selector as DataItemById).objectId);
          return dataProvider.readDocument(documentId: documentId);
        }
      case DataItemByFunction:
        {
          final s = selector as DataItemByFunction;
          return dataProvider.executeItemFunction(
            functionName: s.cloudFunctionName,
            documentClass: documentClass,
            params: s.params,
          );
        }
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<ReadResultList> dataList({
    required String documentClass,
    required IDataList selector,
  }) {
    switch (selector.runtimeType) {
      default:
        throw UnimplementedError();
    }
  }
}
