import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:graphql/client.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/delegate.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_backend/backend/data_provider/server_connect.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/precept_user.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/data/provider/rest_delegate.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/query/field_selector.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/rest_query.dart';

class DefaultRestDataProviderDelegate implements RestDataProviderDelegate {
  late InstanceConfig instanceConfig;
  late DataProvider parent;
  late RestServerConnect serverConnect;

  DefaultRestDataProviderDelegate(
    this.parent,
  );

  @override
  init(InstanceConfig instanceConfig, DataProvider parent) async {
    this.parent = parent;
    this.instanceConfig = instanceConfig;
    if (parent.config.restDelegate == null) {
      String msg = 'RestDelegate cannot be used without configuration';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    serverConnect = inject<RestServerConnect>();
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

  /// TODO: For REST this should be called assembleURL
  @override
  String assembleScript(
      PRestQuery queryConfig, Map<String, dynamic> variables) {
    final StringBuffer buf = StringBuffer(instanceConfig.documentEndpoint);
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
    PRestQuery queryConfig,
    Map<String, dynamic> variables,
  ) async {
    final serverConnectResponse = await serverConnect.fetch(
        instanceConfig, assembleScript(queryConfig, variables));
    return ReadResultList(
      data: transformResponseData(serverConnectResponse),
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
    final serverConnectResponse = await serverConnect.update(
        instanceConfig, '$documentEndpoint/${documentId.path}', data);

    return UpdateResult(
      data: transformResponseData(serverConnectResponse),
      success: true,
      path: documentId.path,
      itemId: documentId.itemId,
    );
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

  String get documentEndpoint => instanceConfig.documentEndpoint;

  @override
  Future<ReadResultItem> latestScript(
      {required String locale,
      required int fromVersion,
      required String name}) {
    throw UnimplementedError();
  }

  @override
  Future<DeleteResult> deleteDocument({required DocumentId documentId}) async {
    logType(this.runtimeType).d('Deleting document');
    final serverConnectResponse = await serverConnect.delete(
      instanceConfig,
      '$documentEndpoint/${documentId.path}/${documentId.itemId}',
    );
    return DeleteResult(
      path: documentId.path,
      data: transformResponseData(serverConnectResponse),
      success: true,
      itemId: documentId.itemId,
    );
  }

  /// see [DataProvider.createDocument]
  @override
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
    required String documentIdKey,
    FieldSelector fieldSelector = const FieldSelector(),
  }) async {
    logType(this.runtimeType).d('Creating new document');
    final serverConnectResponse = await serverConnect.create(
        instanceConfig, '$documentEndpoint/$path', data);

    return CreateResult(
      path: path,
      data: transformResponseData(serverConnectResponse),
      success: true,
      itemId: data[documentIdKey],
    );
  }

  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
  }) async {
    logType(this.runtimeType).d('Reading document');
    final dio.Response response =
        await dio.Dio(dio.BaseOptions(headers: instanceConfig.headers)).get(
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

  transformResponseData(dio.Response response) {
    if (response.data is List) {
      final List<Map<String, dynamic>> data = (response.data as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      return data;
    }
    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data);
    }
    throw PreceptException('Not a map or list');
  }

  @override
  Future<ReadResult> executeFunction({
    required String functionName,
    Map<String, dynamic> params = const {},
  }) async {
    print('Calling Cloud Function \'$functionName\'');
    final serverConnectResponse = await serverConnect
        .executeFunction(instanceConfig, functionName, params: params);
    final data = transformResponseData(serverConnectResponse);
    if (data is List) {
      return ReadResultList(
          data: data as List<Map<String, dynamic>>,
          success: true,
          queryReturnType: QueryReturnType.futureList,
          path: 'function');
    } else {
      return ReadResultItem(
        success: true,
        data: data as Map<String, dynamic>,
        queryReturnType: QueryReturnType.futureItem,
        path: 'function',
      );
    }
  }
}
