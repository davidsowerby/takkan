import 'package:takkan_script/data/provider/document_id.dart';


abstract class QueryResults<DATA> {

  const QueryResults({
    required this.data,
    required this.success,
    required this.documentClass,
    required this.returnSingle,
  });
  final DATA data;
  final bool success;
  final String documentClass;
  final bool returnSingle;
}

class QueryResultItem extends QueryResults<Map<String, dynamic>> {

  const QueryResultItem({
    required this.objectId,
    required super.data,
    required super.success,
    required super.documentClass,
  }) : super(
    returnSingle: true,
        );
  final String objectId;

  DocumentId get documentId =>
      DocumentId(documentClass: documentClass, objectId: objectId);
}

class CreateResult extends UpdateResult {
  const CreateResult({
    required super.data,
    required super.success,
    required super.documentClass,
    required super.objectId,
  });

  DateTime get createdAt => DateTime.parse(data['createdAt'] as String);
}

abstract class ReadResult<DATA> extends QueryResults<DATA> {
  const ReadResult({
    required super.returnSingle,
    required super.data,
    required super.success,
    required super.documentClass,
  });
}

class ReadResultItem extends ReadResult<Map<String, dynamic>> {
  const ReadResultItem({
    required super.data,
    required super.success,
    required super.returnSingle,
    required super.documentClass,
  });

  DocumentId get documentId =>
      DocumentId(documentClass: documentClass, objectId: objectId);

  /// This relies on 'objectId' being included in all queries that return this result type.
  // TODO:(dsowerby) use DataProvider.itemIdKey, https://gitlab.com/takkan/takkan_backend/-/issues/24
  String get objectId => data['objectId'] as String? ?? '?';
}

class ReadResultList extends ReadResult<List<Map<String, dynamic>>> {
  const ReadResultList({
    required super.data,
    required super.success,
    required super.documentClass,
  }) : super(returnSingle: false);

  bool get isNotEmpty => data.isNotEmpty;

  bool get isEmpty => data.isEmpty;
}


/// Status and data returned from a general cloud function call
class FunctionResult {
  const FunctionResult({required this.data,required this.success});

  final Map<String,dynamic> data;
  final bool success;

}

class UpdateResult extends QueryResultItem {
  const UpdateResult({
    required super.data,
    required super.success,
    required super.documentClass,
    required super.objectId,
  });
}

class DeleteResult extends QueryResultItem {
  const DeleteResult({
    required super.data,
    required super.success,
    required super.documentClass,
    required super.objectId,
  });
}
