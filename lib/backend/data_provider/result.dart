import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/query/query.dart';

abstract class QueryResults<DATA> {
  final DATA data;
  final bool success;
  final String path;
  final QueryReturnType queryReturnType;

  const QueryResults({
    required this.data,
    required this.success,
    required this.path,
    required this.queryReturnType,
  });
}

class QueryResultItem extends QueryResults<Map<String, dynamic>> {
  final String itemId;

  const QueryResultItem({
    required this.itemId,
    required Map<String, dynamic> data,
    required bool success,
    required String path,
  }) : super(
          path: path,
          success: success,
          data: data,
          queryReturnType: QueryReturnType.futureItem,
        );

  DocumentId get documentId => DocumentId(path: path, itemId: objectId);

  String get objectId => itemId;
}

class CreateResult extends QueryResultItem {
  const CreateResult({
    required Map<String, dynamic> data,
    required bool success,
    required String path,
    required String itemId,
  }) : super(data: data, success: success, path: path, itemId: itemId);

  DateTime get createdAt => DateTime.parse(data['createdAt']);
}

abstract class ReadResult<DATA> extends QueryResults<DATA> {
  const ReadResult({
    required QueryReturnType queryReturnType,
    required DATA data,
    required bool success,
    required String path,
  }) : super(
          data: data,
          success: success,
          path: path,
          queryReturnType: queryReturnType,
        );
}

class ReadResultItem extends ReadResult<Map<String, dynamic>> {
  const ReadResultItem({
    required Map<String, dynamic> data,
    required bool success,
    required QueryReturnType queryReturnType,
    required String path,
  }) : super(
          success: success,
          data: data,
          path: path,
          queryReturnType: queryReturnType,
        );

  DocumentId get documentId => DocumentId(path: path, itemId: objectId);

  /// This relies on 'objectId' being included in all queries that return this result type.
  /// This is enforced in the DataProviderDelegate, to avoid a lot of
  /// repetitive checking.  Check for success before invoking
  ///
  /// TODO: This will fail with non-back4app entities, especially public REST APIs
  String get objectId => data['objectId'] ?? '?';
}

class ReadResultList extends ReadResult<List<Map<String, dynamic>>> {
  const ReadResultList({
    required List<Map<String, dynamic>> data,
    required bool success,
    required QueryReturnType queryReturnType,
    required String path,
  }) : super(
          success: success,
          data: data,
          path: path,
          queryReturnType: queryReturnType,
        );

  bool get isNotEmpty => data.isNotEmpty;

  bool get isEmpty => data.isEmpty;
}

class UpdateResult extends QueryResultItem {
  const UpdateResult({
    required Map<String, dynamic> data,
    required bool success,
    required String path,
    required String itemId,
  }) : super(
          data: data,
          success: success,
          path: path,
          itemId: itemId,
        );
}

class DeleteResult extends QueryResultItem {
  const DeleteResult({
    required Map<String, dynamic> data,
    required bool success,
    required String path,
    required String itemId,
  }) : super(
          data: data,
          success: success,
          path: path,
          itemId: itemId,
        );
}
