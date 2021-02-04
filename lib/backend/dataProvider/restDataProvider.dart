import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/query.dart';

/// The REST implementation of a [DataProvider]
class RestDataProvider implements DataProvider {
  final PRestDataProvider config;

  const RestDataProvider({@required this.config})
      : assert(config != null);

  @override
  Future<CloudResponse> delete({List<DocumentId> documentIds}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> executeFunction({String functionName, Map<String, dynamic> params}) {
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
  Future<List<Data>> fetchList({functionName, Map<String, String> params}) {
    // TODO: implement fetchList
    throw UnimplementedError();
  }

  @override
  Future<Data> get({PGet query}) async {
    final url =
        '${config.baseUrl}/classes/${query.documentId.path}/${query.documentId.itemId}';
    final Response response = await Dio(BaseOptions(headers: config.headers)).get(url);
    if (response.statusCode == HttpStatus.ok) {
      // final Map<String, dynamic> json = jsonDecode(response.data);
      return Data(data: response.data, documentId: query.documentId);
    }
    throw APIException(message: response.statusMessage, statusCode: response.statusCode);
  }

  // curl -X GET \
  // -H "X-Parse-Application-Id: at4dM5dN0oCRryJp7VtTccIKZY9l3GtfHre0Hoow" \
  // -H "X-Parse-REST-API-Key: Em49eaT0rrvEnL1tdH6F4TKyrObO3pNtEjwUAk1u" \
  // https://parseapi.back4app.com/classes/Account/wVdGK8TDXR

  @override
  Future<Data> getDistinct({PQuery query}) {
    // TODO: implement getDistinct
    throw UnimplementedError();
  }

  @override
  Stream<Data> getDistinctStream({PQuery query}) {
    // TODO: implement getDistinctStream
    throw UnimplementedError();
  }

  @override
  Future<Data> getList({PQuery query}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Stream<List<Data>> getListStream({PQuery query}) {
    // TODO: implement getListStream
    throw UnimplementedError();
  }

  @override
  Stream<Data> getStream({DocumentId documentId}) {
    // TODO: implement getStream
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> save(
      {DocumentId documentId,
      Map<String, dynamic> changedData,
      Map<String, dynamic> fullData,
      DocumentType documentType = DocumentType.standard,
      bool saveChangesOnly = true,
      Function() onSuccess}) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
