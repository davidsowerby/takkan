import 'package:precept_script/data/provider/documentId.dart';

class QueryResultBase {
  final Map<String, dynamic> data;
  final bool success;
  final String path;

  const QueryResultBase({
    required this.data,
    required this.success,
    required this.path,
  });

  DocumentId get documentId => DocumentId(path: path, itemId: objectId);

  String get objectId => data['objectId'];
}

class CreateResult extends QueryResultBase {
  const CreateResult(
      {required Map<String, dynamic> data,
      required bool success,
      required String path})
      : super(data: data, success: success, path: path);

  DateTime get createdAt => DateTime.parse(data['createdAt']);
}

class ReadResult extends QueryResultBase {
  const ReadResult({
    required Map<String, dynamic> data,
    required bool success,
    required String path,
  }) : super(data: data, success: success, path: path);
}

class UpdateResult extends QueryResultBase {
  const UpdateResult({
    required Map<String, dynamic> data,
    required bool success,
    required String path,
  }) : super(data: data, success: success, path: path);
}

class DeleteResult extends QueryResultBase {
  const DeleteResult({
    required Map<String, dynamic> data,
    required bool success,
    required String path,
  }) : super(data: data, success: success, path: path);
}
