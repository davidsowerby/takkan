import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/data/select/query.dart';

abstract class QueryResults<DATA> {
  final DATA data;
  final bool success;
  final String documentClass;
  final QueryReturnType queryReturnType;

  const QueryResults({
    required this.data,
    required this.success,
    required this.documentClass,
    required this.queryReturnType,
  });
}

class QueryResultItem extends QueryResults<Map<String, dynamic>> {
  final String objectId;

  const QueryResultItem({
    required this.objectId,
    required Map<String, dynamic> data,
    required bool success,
    required String documentClass,
  }) : super(
          documentClass: documentClass,
          success: success,
          data: data,
          queryReturnType: QueryReturnType.futureItem,
        );

  DocumentId get documentId =>
      DocumentId(documentClass: documentClass, objectId: objectId);
}

class CreateResult extends UpdateResult {
  const CreateResult({
    required Map<String, dynamic> data,
    required bool success,
    required String documentClass,
    required String objectId,
  }) : super(
            data: data,
            success: success,
            documentClass: documentClass,
            objectId: objectId);

  DateTime get createdAt => DateTime.parse(data['createdAt']);
}

abstract class ReadResult<DATA> extends QueryResults<DATA> {
  const ReadResult({
    required QueryReturnType queryReturnType,
    required DATA data,
    required bool success,
    required String documentClass,
  }) : super(
    data: data,
          success: success,
          documentClass: documentClass,
          queryReturnType: queryReturnType,
        );
}

class ReadResultItem extends ReadResult<Map<String, dynamic>> {
  const ReadResultItem({
    required Map<String, dynamic> data,
    required bool success,
    required QueryReturnType queryReturnType,
    required String documentClass,
  }) : super(
    success: success,
          data: data,
          documentClass: documentClass,
          queryReturnType: queryReturnType,
        );

  DocumentId get documentId =>
      DocumentId(documentClass: documentClass, objectId: objectId);

  /// This relies on 'objectId' being included in all queries that return this result type.
  /// This is enforced in the DataProviderDelegate, to avoid a lot of
  /// repetitive checking.  Check for success before invoking
  ///
  /// TODO: use DataProvider.itemIdKey
  String get objectId => data['objectId'] ?? '?';
}

class ReadResultList extends ReadResult<List<Map<String, dynamic>>> {
  const ReadResultList({
    required List<Map<String, dynamic>> data,
    required bool success,
    required QueryReturnType queryReturnType,
    required String documentClass,
  }) : super(
    success: success,
          data: data,
          documentClass: documentClass,
          queryReturnType: queryReturnType,
        );

  bool get isNotEmpty => data.isNotEmpty;

  bool get isEmpty => data.isEmpty;
}

class UpdateResult extends QueryResultItem {
  const UpdateResult({
    required Map<String, dynamic> data,
    required bool success,
    required String documentClass,
    required String objectId,
  }) : super(
    data: data,
          success: success,
          documentClass: documentClass,
          objectId: objectId,
        );
}

class DeleteResult extends QueryResultItem {
  const DeleteResult({
    required Map<String, dynamic> data,
    required bool success,
    required String documentClass,
    required String objectId,
  }) : super(
    data: data,
          success: success,
          documentClass: documentClass,
          objectId: objectId,
        );
}
