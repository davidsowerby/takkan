import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart' as dio;
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/dataProvider/fieldSelector.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/restDelegate.dart';
import 'package:precept_script/query/restQuery.dart';
import 'package:precept_script/script/script.dart';

class DefaultRestDataProviderDelegate implements RestDataProviderDelegate {
  late AppConfig appConfig;
  late Authenticator _authenticator;
  final DataProvider parent;

  DefaultRestDataProviderDelegate(
    this.parent,
  );

  @override
  init(AppConfig appConfig) async {
    if (parent.config.authenticatorDelegate == CloudInterface.rest) {
      _authenticator = await createAuthenticator();
    }
    this.appConfig = appConfig;
    if (parent.config.restDelegate == null) {
      throw PreceptException(
          'RestDelegate cannot be used with no configuration');
    }
  }

  @override
  setSessionToken(String token) {
    // TODO: implement addSessionToken
    throw UnimplementedError();
  }

  PreceptUser get user => _authenticator.user;

  Authenticator get authenticator => _authenticator;

  PRest get config =>
      parent.config.restDelegate as PRest; // safe after init called

  @override
  String assembleScript(
      PRestQuery queryConfig, Map<String, dynamic> pageArguments) {
    final StringBuffer buf = StringBuffer(documentEndpoint);
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
            dio.BaseOptions(headers: appConfig.headers(parent.config, config)))
        .get("This needs to be replaced");
    final data = response.data;
    List<Map<String, dynamic>> output = List.empty(growable: true);
    for (var entry in data) {
      output.add(entry as Map<String, dynamic>);
    }
    return output;
  }

  /// See [PDataProvider.updateDocument]
  @override
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> data,
  }) async {
    logType(this.runtimeType).d('Updating data provider');
    final dio.Response response = await dio.Dio(
            dio.BaseOptions(headers: appConfig.headers(parent.config, config)))
        .put(
      documentUrl(documentId),
      data: data,
    );
    if (response.statusCode == HttpStatus.ok) {
      logType(this.runtimeType).d('Data provider updated document');
      return UpdateResult(
        data: response.data,
        success: true,
        path: documentId.path,
      );
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode ?? -999);
  }

  Future<Authenticator> createAuthenticator() {
    throw UnsupportedError(
        "An implementation specific dedicated 'createAuthenticator' method is required for a RestDataProviderDelegate to support authentication");
  }

  String documentUrl(DocumentId documentId) {
    return '$documentEndpoint/${documentId.path}/${documentId.itemId}';
  }

  String get documentEndpoint =>
      '${appConfig.serverUrl(parent.config)}${config.documentEndpoint}';

  @override
  Future<ReadResult> latestScript(
      {required Locale locale,
      required int fromVersion,
      required String name}) {
    throw UnimplementedError();
  }

  @override
  Future<UpdateResult> uploadPreceptScript(
      {required PScript script,
      required Locale locale,
      bool incrementVersion = false}) {
    throw UnimplementedError();
  }

  @override
  Future<DeleteResult> deleteDocument({required DocumentId documentId}) {
    // TODO: implement deleteDocument
    throw UnimplementedError();
  }

  /// see [DataProvider.createDocument]
  @override
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    logType(this.runtimeType).d('Creating new document');
    final dio.Response response = await dio.Dio(
            dio.BaseOptions(headers: appConfig.headers(parent.config, config)))
        .post(
      '$documentEndpoint/$path',
      data: data,
    );
    if (response.statusCode == HttpStatus.created) {
      logType(this.runtimeType).d('Document created');
      return CreateResult(
        path: path,
        data: response.data,
        success: true,
      );
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode ?? -999);
  }

  @override
  Future<ReadResult> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
  }) async {
    logType(this.runtimeType).d('Reading document');
    // GET \
    // -H "X-Parse-Application-Id: xLWKrOqVNy3O1u3z9ovoalO2XFuKQn0NlHPksJV6" \
    // -H "X-Parse-REST-API-Key: hgRclD9aBr3BL1Tz8hw3G1LSoeI84QahWdSRPuu1" \
    // -G \
    // --data-urlencode "where={\"objectId\":\"HQCxFeKXK9\"}" \
    // https://parseapi.back4app.com/classes/PreceptScript

    final dio.Response response = await dio.Dio(
            dio.BaseOptions(headers: appConfig.headers(parent.config, config)))
        .get(
      '$documentEndpoint/${documentId.path}',
      queryParameters: {'objectId': documentId.itemId},
    );
    if (response.statusCode == HttpStatus.ok) {
      logType(this.runtimeType).d('Document created');
      return ReadResult(
        data: response.data,
        success: true,
        path: documentId.path,
      );
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode ?? -999);
  }
}
