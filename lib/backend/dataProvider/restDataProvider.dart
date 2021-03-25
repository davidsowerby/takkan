import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/query.dart';

/// The REST implementation of a [DataProvider]
class RestDataProvider<T extends PRestDataProvider> extends DataProvider<T> {

   RestDataProvider({@required T config}) : assert(config != null), super(config: config);

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
  Future<Data> getDocument({DocumentId documentId, Map<String, dynamic> pageArguments = const {}}) async {
    final Response response =
        await Dio(BaseOptions(headers: config.headers)).get(config.documentUrl(documentId));
    if (response.statusCode == HttpStatus.ok) {
      return Data(data: response.data, documentId: documentId);
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
  Future<CloudResponse> save(
      {DocumentId documentId,
      Map<String, dynamic> fullData,
      DocumentType documentType = DocumentType.standard,
      Function() onSuccess}) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> create({
    DocumentId documentId,
    Map<String, dynamic> fullData,
    DocumentType documentType = DocumentType.standard,
    Function() onSuccess,
  }) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> update({
    DocumentId documentId,
    Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
    Function() onSuccess,
  }) async {
    final Response response = await Dio(BaseOptions(headers: config.headers)).put(
      config.documentUrl(documentId),
      data: changedData,
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    throw APIException(message: response.statusMessage, statusCode: response.statusCode);
    // # Don't forget to set the OBJECT_ID parameter
    // curl -X PUT \
    // -H "X-Parse-Application-Id: at4dM5dN0oCRryJp7VtTccIKZY9l3GtfHre0Hoow" \
    // -H "X-Parse-REST-API-Key: Em49eaT0rrvEnL1tdH6F4TKyrObO3pNtEjwUAk1u" \
    // -H "Content-Type: application/json" \
    // -d "{ \"category\": \"A string\",\"accountNumber\": \"A string\" }" \
    // https://parseapi.back4app.com/classes/Account/<OBJECT_ID>
  }

  @override
  Authenticator<T> createAuthenticator(T config) => throw UnimplementedError();

  @override
  Stream<Data> getStream({PGet query, Map<String, dynamic> pageArguments = const {}}) {
    // TODO: implement getStream
    throw UnimplementedError();
  }

  @override
  Future<Data> query({PQuery query, String script, Map<String, dynamic> pageArguments = const {}}) {
    // TODO: implement query
    throw UnimplementedError();
  }
}
