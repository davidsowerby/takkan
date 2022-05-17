import 'package:dio/dio.dart' as dio;
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_script/data/provider/document_id.dart';

/// A wrapper for a GraphQL / HttpClient, to enable mocking
abstract class ServerConnect {}

/// [ResponseType] defaults to json
abstract class RestServerConnect extends ServerConnect {
  Future<dio.Response> fetch(
    InstanceConfig instanceConfig,
    String relativeUrl,
  );

  Future<dio.Response> create(
    InstanceConfig instanceConfig,
    String relativeUrl,
    Map<String, dynamic> data,
  );

  Future<dio.Response> update(
    InstanceConfig instanceConfig,
    String relativeUrl,
    DocumentId documentId,
    Map<String, dynamic> data,
  );

  Future<dio.Response> delete(
    InstanceConfig instanceConfig,
    String relativeUrl,
  );

  Future<dio.Response> executeFunction(
    InstanceConfig instanceConfig,
    String function, {
    Map<String, dynamic> params = const {},
  });
}

abstract class GraphQLServerConnect extends ServerConnect {}

class DefaultRestServerConnect implements RestServerConnect {
  const DefaultRestServerConnect();

  Future<dio.Response> fetch(
    InstanceConfig instanceConfig,
    String relativeUrl,
  ) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 200,
    );
    return await client(options).get(relativeUrl);
  }

  Future<dio.Response> create(
    InstanceConfig instanceConfig,
    String relativeUrl,
    Map<String, dynamic> data,
  ) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 201,
    );

    return await client(options).post(relativeUrl, data: data);
  }

  Future<dio.Response> update(
    InstanceConfig instanceConfig,
    String relativeUrl,
    DocumentId documentId,
    Map<String, dynamic> data,
  ) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 200,
    );

    return await client(options)
        .put('$relativeUrl/${documentId.objectId}', data: data);
  }

  Future<dio.Response> executeFunction(
    InstanceConfig instanceConfig,
    String function, {
    Map<String, dynamic> params = const {},
  }) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => (c == 200 || c == 201),
    );

    return await client(options).post(
      '${instanceConfig.functionEndpoint}/$function',
      queryParameters: params,
    );
  }

  /// Allow sub-class to mock or modify options
  dio.Dio client(dio.BaseOptions options) {
    return dio.Dio(options);
  }

  @override
  Future<dio.Response> delete(
      InstanceConfig instanceConfig, String relativeUrl) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 200,
    );

    return await client(options).delete(relativeUrl);
  }
}
