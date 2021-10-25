import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart' as dio;
import 'package:graphql/client.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/restDelegate.dart';
import 'package:precept_script/query/fieldSelector.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/restQuery.dart';

class DefaultRestDataProviderDelegate implements RestDataProviderDelegate {
  late AppConfig appConfig;
  late DataProvider parent;

  DefaultRestDataProviderDelegate(
    this.parent,
  );

  @override
  init(AppConfig appConfig, DataProvider parent) async {
    this.parent = parent;
    this.appConfig = appConfig;
    if (parent.config.restDelegate == null) {
      String msg = 'RestDelegate cannot be used with no configuration';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
  }

  @override
  setSessionToken(String token) {
    // TODO: implement addSessionToken
    throw UnimplementedError();
  }

  PreceptUser get user => parent.user; // safe only after init called
  Authenticator get authenticator =>
      parent.authenticator; // safe only after init called

  PRest get config =>
      parent.config.restDelegate as PRest; // safe only after init called

  @override
  String assembleScript(
      PRestQuery queryConfig, Map<String, dynamic> variables) {
    final StringBuffer buf = StringBuffer(documentEndpoint);
    buf.write('/');
    buf.write(queryConfig.path);
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
  Future<ReadResultItem> fetchItem(
      PRestQuery queryConfig, Map<String, dynamic> variables) async {
    final results = await fetchList(queryConfig, variables);
    final firstResult =
        (results.isNotEmpty) ? results.data[0] : <String, dynamic>{};
    final success = results.isNotEmpty;
    return ReadResultItem(
      data: firstResult,
      success: success,
      queryReturnType: QueryReturnType.futureItem,
      path: queryConfig.documentSchema,
    );
  }

  /// Default content type is JSON
  @override
  Future<ReadResultList> fetchList(
      PRestQuery queryConfig, Map<String, dynamic> variables) async {
    final dio.Response response = await dio.Dio(
            dio.BaseOptions(headers: appConfig.headers(parent.config, config)))
        .get(assembleScript(queryConfig, variables));
    final data = List<Map<String, dynamic>>.from(response.data['results']);
    // List<Map<String, dynamic>> output = List.empty(growable: true);
    // for (var entry in data) {
    //   output.add(entry as Map<String, dynamic>);
    // }
    return ReadResultList(
      data: data,
      path: queryConfig.documentSchema,
      queryReturnType: QueryReturnType.futureList,
      success: true,
    );
  }

  /// See [PDataProvider.updateDocument]
  @override
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> data,
    FieldSelector fieldSelector = const FieldSelector(),
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
        itemId: documentId.itemId,
      );
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode ?? -999);
  }

  Future<Authenticator> createAuthenticator() {
    String msg =
        "An implementation specific dedicated 'createAuthenticator' method is required for a RestDataProviderDelegate to support authentication";
    logType(this.runtimeType).e(msg);
    throw PreceptException(msg);
  }

  String documentUrl(DocumentId documentId) {
    return '$documentEndpoint/${documentId.path}/${documentId.itemId}';
  }

  String get documentEndpoint =>
      '${appConfig.serverUrl(parent.config)}${config.documentEndpoint}';

  @override
  Future<ReadResultItem> latestScript(
      {required Locale locale,
      required int fromVersion,
      required String name}) {
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
    FieldSelector fieldSelector = const FieldSelector(),
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
        itemId: response.data['objectId'],
      );
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode ?? -999);
  }

  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
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
      return ReadResultItem(
        data: response.data,
        success: true,
        path: documentId.path,
        queryReturnType: QueryReturnType.futureItem,
      );
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode ?? -999);
  }
}
