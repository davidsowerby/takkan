import 'package:dio/dio.dart' as dio;
import 'package:takkan_script/data/provider/document_id.dart';

import '../app/app_config.dart';
import 'url_builder.dart';

/// A wrapper for a GraphQL / HttpClient, to enable mocking
abstract class ServerConnect {}

/// [ResponseType] defaults to json
abstract class RestServerConnect extends ServerConnect {
  ///
  Future<dio.Response<dynamic>> fetch({
    required InstanceConfig instanceConfig,
    required URLComposition urlComposition,
  });

  Future<dio.Response<dynamic>> create({
    required InstanceConfig instanceConfig,
    required String url,
    required Map<String, dynamic> data,
  });

  Future<dio.Response<dynamic>> update({
    required InstanceConfig instanceConfig,
    required String url,
    required DocumentId documentId,
    required Map<String, dynamic> data,
  });

  Future<dio.Response<dynamic>> delete({
    required InstanceConfig instanceConfig,
    required String url,
  });

  Future<dio.Response<dynamic>> read({
    required InstanceConfig instanceConfig,
    required String url,
  });

  Future<dio.Response<dynamic>> executeFunction({
    required InstanceConfig instanceConfig,
    required String function,
    Map<String, dynamic> params = const {},
  });
}

abstract class GraphQLServerConnect extends ServerConnect {}

class DefaultRestServerConnect implements RestServerConnect {
  const DefaultRestServerConnect();

  /// [fetch] uses cloud functions to retrieve data and hence calls put and not get
  @override
  Future<dio.Response<dynamic>> fetch({
    required InstanceConfig instanceConfig,
    required URLComposition urlComposition,
  }) async {
    final options = dio.BaseOptions(
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 200,
      queryParameters: urlComposition.paramsAsData,
    );
    return client(options).post(urlComposition.url);
  }

  @override
  Future<dio.Response<dynamic>> create({
    required InstanceConfig instanceConfig,
    required String url,
    required Map<String, dynamic> data,
  }) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 201,
    );

    return client(options).post(url, data: data);
  }

  @override
  Future<dio.Response<dynamic>> update({
    required InstanceConfig instanceConfig,
    required String url,
    required DocumentId documentId,
    required Map<String, dynamic> data,
  }) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 200,
    );

    return client(options).put('$url/${documentId.objectId}', data: data);
  }

  @override
  Future<dio.Response<dynamic>> executeFunction({
    required InstanceConfig instanceConfig,
    required String function,
    Map<String, dynamic> params = const {},
  }) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 200 || c == 201,
    );

    return client(options).post(
      '${instanceConfig.functionEndpoint}/$function',
      queryParameters: params,
    );
  }

  /// Allow sub-class to mock or modify options
  dio.Dio client(dio.BaseOptions options) {
    return dio.Dio(options);
  }

  @override
  Future<dio.Response<dynamic>> delete({
    required InstanceConfig instanceConfig,
    required String url,
  }) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 200,
    );

    return client(options).delete(url);
  }

  @override
  Future<dio.Response<dynamic>> read({
    required InstanceConfig instanceConfig,
    required String url,
  }) async {
    final options = dio.BaseOptions(
      baseUrl: instanceConfig.serverUrl,
      headers: instanceConfig.headers,
      validateStatus: (c) => c == 200,
    );

    return client(options).get(url);
  }
}
