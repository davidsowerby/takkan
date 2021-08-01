import 'package:precept_script/data/provider/documentId.dart';

class QueryResultBase {
  final Map<String, dynamic> data;
  final bool success;
  final String path;
  final String itemId;

  const QueryResultBase({
    required this.data,
    required this.success,
    required this.path,
    required this.itemId,
  });

  DocumentId get documentId => DocumentId(path: path, itemId: objectId);

  String get objectId => itemId;
}

class CreateResult extends QueryResultBase {
  const CreateResult({
    required Map<String, dynamic> data,
    required bool success,
    required String path,
    required String itemId,
  }) : super(data: data, success: success, path: path, itemId: itemId);

  DateTime get createdAt => DateTime.parse(data['createdAt']);
}

class ReadResult extends QueryResultBase {
  const ReadResult({
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

class UpdateResult extends QueryResultBase {
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

class DeleteResult extends QueryResultBase {
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
