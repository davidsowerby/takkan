import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_backend/backend/query/query.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/dataSource.dart';


class Back4AppBackendDelegate implements BackendDelegate{
  @override
  Future<CloudResponse> delete({List<DocumentId> documentIds}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> executeFunction({String functionName, Map<String, String> params}) {
    // TODO: implement executeFunction
    throw UnimplementedError();
  }

  @override
  Future<bool> exists({DocumentId documentId}) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  Future<Data> fetch({String functionName, DocumentId documentId}) {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<Data> fetchDistinct({String functionName, Map<String, dynamic> params}) {
    // TODO: implement fetchDistinct
    throw UnimplementedError();
  }

  @override
  Future<List<Data>> fetchList({String functionName, Map<String, String> params}) {
    // TODO: implement fetchList
    throw UnimplementedError();
  }

  @override
  Future<Data> get({DocumentId documentId}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Data> getDistinct({Query query}) {
    // TODO: implement getDistinct
    throw UnimplementedError();
  }

  @override
  Stream<Data> getDistinctStream({Query query}) {
    // TODO: implement getDistinctStream
    throw UnimplementedError();
  }

  @override
  Future<Data> getList({Query query}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Stream<List<Data>> getListStream({Query query}) {
    // TODO: implement getListStream
    throw UnimplementedError();
  }

  @override
  Stream<Data> getStream({DocumentId documentId}) {
    // TODO: implement getStream
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> loadPreceptModel({int minimumVersion}) {
    // TODO: implement loadPreceptModel
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> loadPreceptSchema({int minimumVersion}) {
    // TODO: implement loadPreceptSchema
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> save({DocumentId documentId, Map<String, dynamic> changedData, Map<String, dynamic> fullData}) {
    // TODO: implement save
    throw UnimplementedError();
  }

}