import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/app/appConfig.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/restDelegate.dart';
import 'package:precept_script/query/restQuery.dart';

class DefaultRestDataProviderDelegate implements RestDataProviderDelegate {
  final PRestDelegate config;
  final PDataProvider providerConfig;
  late AppConfig appConfig;

  DefaultRestDataProviderDelegate({
    required this.config,
    required this.providerConfig,
  });

  @override
  init(AppConfig appConfig) {
    this.appConfig = appConfig;
  }

  @override
  setSessionToken(String token) {
    // TODO: implement addSessionToken
    throw UnimplementedError();
  }

  @override
  String assembleScript(
      PRestQuery queryConfig, Map<String, dynamic> pageArguments) {
    final StringBuffer buf = StringBuffer(config.documentEndpoint);
    if (queryConfig.paramsAsPath) {
      for (var entry in queryConfig.params.entries) {
        buf.write(entry.key);
        buf.write('/');
        buf.write(entry.value);
      }
      logType(this.runtimeType).d("REST URL is: ${buf.toString()}");
      return buf.toString();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<Map<String, dynamic>> fetchItem(
      PRestQuery queryConfig, Map<String, dynamic> variables) async {
    final results = await fetchList(queryConfig, variables);
    if (results.isNotEmpty) {
      return results[0];
    }
    return Map();
  }

  /// Default content type is JSON
  @override
  Future<List<Map<String, dynamic>>> fetchList(
      PRestQuery queryConfig, Map<String, dynamic> variables) async {
    final dio.Response response = await dio.Dio(
            dio.BaseOptions(headers: appConfig.headers(providerConfig)))
        .get("This needs to be replaced");
    final data = response.data;
    List<Map<String, dynamic>> output = List.empty(growable: true);
    for (var entry in data) {
      output.add(entry as Map<String, dynamic>);
    }
    return output;
  }

  @override
  Future<bool> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
  }) async {
    logType(this.runtimeType).d('Updating data provider');
    final dio.Response response = await dio.Dio(
            dio.BaseOptions(headers: appConfig.headers(providerConfig)))
        .put(
      documentUrl(documentId),
      data: changedData,
    );
    if (response.statusCode == HttpStatus.ok) {
      logType(this.runtimeType).d('Data provider updated');
      return true;
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode = -999);
  }

  Authenticator createAuthenticator() {
    throw UnsupportedError(
        "An implementation specific dedicated 'createAuthenticator' method is required for a RestDataProviderDelegate to support authentication");
  }

  String documentUrl(DocumentId documentId) {
    return '${config.documentEndpoint}/${documentId.path}/${documentId.itemId}';
  }
}
