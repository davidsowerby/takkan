import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/server_connect.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/data/provider/rest_delegate.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/rest_query.dart';
import 'package:test/test.dart';

import '../../fixtures/server_connect.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  PDataProvider config = PDataProvider(
    configSource: PConfigSource(
      segment: 'segment',
      instance: 'instance',
    ),
    sessionTokenKey: 'sessionToken',
    restDelegate: PRest(sessionTokenKey: '?'),
  );
  group('Positive tests', () {
    const baseUrl = 'https://example.com';
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: baseUrl));
      dioAdapter = DioAdapter(dio: dio);
      getIt.reset();
      getIt
          .registerFactory<RestServerConnect>(() => MockRestServerConnect(dio));
    });

    tearDown(() {});

    test('fetchList', () async {
      // given
      AppConfig appConfig = AppConfig({
        'segment': {'instance': {}},
      });
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      final route = '${instanceConfig.documentEndpoint}/Person';
      final returnedData = [
        {
          'name': 'Adrian',
          'age': 23,
        }
      ];

      dioAdapter.onGet(
        route,
        (server) => server.reply(200, returnedData),
      );
      DefaultDataProvider provider = DefaultDataProvider(config: config);
      provider.init(appConfig);
      // when
      final result = await provider.fetchList(
          queryConfig: PRestQuery(queryName: 'items', documentSchema: 'Person'),
          pageArguments: {});
      // then

      expect(result.data, returnedData);
      expect(result.queryReturnType, QueryReturnType.futureList);
      expect(result.success, isTrue);
    });

    test('fetchItem', () async {
      // given
      AppConfig appConfig = AppConfig({
        'segment': {'instance': {}},
      });
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      final route = '${instanceConfig.documentEndpoint}/Person';
      final returnedData = [
        {
          'name': 'Adrian',
          'age': 23,
        }
      ];

      dioAdapter.onGet(
        route,
        (server) => server.reply(200, returnedData),
      );
      DefaultDataProvider provider = DefaultDataProvider(config: config);
      provider.init(appConfig);
      // when
      final result = await provider.fetchItem(
          queryConfig: PRestQuery(queryName: 'items', documentSchema: 'Person'),
          pageArguments: {});
      // then

      expect(result.data, returnedData[0]);
      expect(result.queryReturnType, QueryReturnType.futureItem);
      expect(result.success, isTrue);
    });
    test('createDocument', () async {
      // given
      AppConfig appConfig = AppConfig({
        'segment': {'instance': {}},
      });
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      final route = '${instanceConfig.documentEndpoint}/Person';
      final data = {
        'objectId': 'XXxxnnyy',
        'name': 'Adrian',
        'age': 23,
      };
      final encodedLength = json.encode(data).length;
      dioAdapter.onPost(
        route,
        (server) => server.reply(201, data),
        headers: {
          'content-type': 'application/json; charset=utf-8',
          'content-length': '${encodedLength.toString()}'
        },
        data: data,
      );
      DefaultDataProvider provider = DefaultDataProvider(config: config);
      provider.init(appConfig);
      // when
      final result = await provider.createDocument(
        path: 'Person',
        data: data,
        useDelegate: Delegate.rest,
      );
      // then

      expect(result.data, data);
      expect(result.queryReturnType, QueryReturnType.futureItem);
      expect(result.success, isTrue);
    });
    test('updateDocument', () async {
      // given
      AppConfig appConfig = AppConfig({
        'segment': {'instance': {}},
      });
      final updateResponse = {"updatedAt": "2011-08-21T18:02:52.248Z"};
      final objectId = 'XXxxnnyy';
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      final route = '${instanceConfig.documentEndpoint}/Person';
      final data = {
        'objectId': objectId,
        'name': 'Adrian',
        'age': 23,
      };
      final encodedLength = json.encode(data).length;
      dioAdapter.onPut(
        route,
        (server) => server.reply(200, updateResponse),
        headers: {
          'content-type': 'application/json; charset=utf-8',
          'content-length': '${encodedLength.toString()}'
        },
        data: data,
      );
      DefaultDataProvider provider = DefaultDataProvider(config: config);
      provider.init(appConfig);
      // when
      final result = await provider.updateDocument(
        documentId: DocumentId(path: 'Person', itemId: objectId),
        data: data,
        useDelegate: Delegate.rest,
      );
      // then

      expect(result.data, updateResponse);
      expect(result.queryReturnType, QueryReturnType.futureItem);
      expect(result.success, isTrue);
    });

    test('deleteDocument', () async {
      // given
      AppConfig appConfig = AppConfig({
        'segment': {'instance': {}},
      });
      final deleteResponse = {};
      final objectId = 'XXxxnnyy';
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      final route = '${instanceConfig.documentEndpoint}/Person/$objectId';
      dioAdapter.onDelete(
        route,
        (server) => server.reply(200, deleteResponse),
        headers: {
          'content-type': 'application/json; charset=utf-8',
        },
      );
      DefaultDataProvider provider = DefaultDataProvider(config: config);
      provider.init(appConfig);
      // when
      final result = await provider.deleteDocument(
        documentId: DocumentId(path: 'Person', itemId: objectId),
        useDelegate: Delegate.rest,
      );
      // then

      expect(result.data, deleteResponse);
      expect(result.queryReturnType, QueryReturnType.futureItem);
      expect(result.success, isTrue);
    });

    test('executeFunction', () async {
      // given
      AppConfig appConfig = AppConfig({
        'segment': {'instance': {}},
      });
      final String functionName = 'dummyFunction';
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      final route = '${instanceConfig.functionEndpoint}/$functionName';
      final params = {'x': 2, 'y': 7};
      final serverDataResponse = {'data': 14};
      dioAdapter.onPost(
        route,
        (server) => server.reply(201, serverDataResponse),
        headers: {
          'content-type': 'application/json; charset=utf-8',
        },
        queryParameters: params,
      );
      DefaultDataProvider provider = DefaultDataProvider(config: config);
      provider.init(appConfig);
      // when
      final result = await provider.executeFunction(
        functionName: functionName,
        params: params,
      );
      // then

      expect(result.data, serverDataResponse);
      expect(result.queryReturnType, QueryReturnType.futureItem);
      expect(result.success, isTrue);
    });
  });
}
