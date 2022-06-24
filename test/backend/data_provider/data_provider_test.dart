import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/base_data_provider.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/delegate.dart';
import 'package:takkan_backend/backend/data_provider/query_selector.dart';
import 'package:takkan_backend/backend/data_provider/rest_delegate.dart';
import 'package:takkan_backend/backend/data_provider/server_connect.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/no_authenticator.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/delegate.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/provider/rest_delegate.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/data/select/rest_query.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:test/test.dart';

import '../../fixtures/server_connect.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  DataProvider config = DataProvider(
    instanceConfig: AppInstance(
      group: 'group',
      instance: 'instance',
    ),
    restDelegate: Rest(),
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
      final AppConfig appConfig = createAppConfig();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      getItBindings(instanceConfig.uniqueName);

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
      IDataProvider provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(appConfig: appConfig, config: config);
      // when
      final result = await provider.fetchList(
          queryConfig: RestQuery(queryName: 'items', documentSchema: 'Person'),
          pageArguments: {});
      // then

      expect(result.data, returnedData);
      expect(result.queryReturnType, QueryReturnType.futureList);
      expect(result.success, isTrue);
    });

    test('fetchItem', () async {
      // given
      final AppConfig appConfig = createAppConfig();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      getItBindings(instanceConfig.uniqueName);
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
      IDataProvider provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(appConfig: appConfig, config: config);
      // when
      final result = await provider.fetchItem(
          queryConfig: RestQuery(queryName: 'items', documentSchema: 'Person'),
          pageArguments: {});
      // then

      expect(result.data, returnedData[0]);
      expect(result.queryReturnType, QueryReturnType.futureItem);
      expect(result.success, isTrue);
    });
    test('createDocument', () async {
      // given
      final AppConfig appConfig = createAppConfig();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      getItBindings(instanceConfig.uniqueName);
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
      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(appConfig: appConfig, config: config);
      // when
      final result = await provider.createDocument(
        documentClass: 'Person',
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
      final AppConfig appConfig = createAppConfig();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      getItBindings(instanceConfig.uniqueName);
      final updateResponse = {"updatedAt": "2011-08-21T18:02:52.248Z"};
      final objectId = 'XXxxnnyy';
      final route = '${instanceConfig.documentEndpoint}/Person/$objectId';
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
      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(appConfig: appConfig, config: config);
      // when
      final result = await provider.updateDocument(
        documentId: DocumentId(documentClass: 'Person', objectId: objectId),
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
      final AppConfig appConfig = createAppConfig();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      getItBindings(instanceConfig.uniqueName);
      final deleteResponse = {};
      final objectId = 'XXxxnnyy';
      final route = '${instanceConfig.documentEndpoint}/Person/$objectId';
      dioAdapter.onDelete(
        route,
        (server) => server.reply(200, deleteResponse),
        headers: {
          'content-type': 'application/json; charset=utf-8',
        },
      );
      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(appConfig: appConfig, config: config);
      // when
      final result = await provider.deleteDocument(
        documentId: DocumentId(documentClass: 'Person', objectId: objectId),
        useDelegate: Delegate.rest,
      );
      // then

      expect(result.data, deleteResponse);
      expect(result.queryReturnType, QueryReturnType.futureItem);
      expect(result.success, isTrue);
    });

    test('executeFunction', () async {
      // given
      final AppConfig appConfig = createAppConfig();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      getItBindings(instanceConfig.uniqueName);
      final String functionName = 'dummyFunction';
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
      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(appConfig: appConfig, config: config);
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
    test('executeItemFunction', () async {
      // given
      const documentClass = 'Person';
      final AppConfig appConfig = createAppConfig();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      getItBindings(instanceConfig.uniqueName);
      final String functionName = 'dummyFunction';
      final route = '${instanceConfig.functionEndpoint}/$functionName';
      final params = {'x': 2, 'y': 7};
      final serverDataResponse = {'data': 14, 'objectId':'xxxyyy'};
      dioAdapter.onPost(
        route,
        (server) => server.reply(201, serverDataResponse),
        headers: {
          'content-type': 'application/json; charset=utf-8',
        },
        queryParameters: params,
      );
      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(appConfig: appConfig, config: config);
      // when
      final result = await provider.executeItemFunction(
        functionName: functionName,
        params: params,
        documentClass: documentClass,
      );
      // then

      expect(result.data, serverDataResponse);
      expect(result.queryReturnType, QueryReturnType.futureItem);
      expect(result.success, isTrue);
    });
    test('executeListFunction', () async {
      // given
      const documentClass = 'Person';
      final AppConfig appConfig = createAppConfig();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      getItBindings(instanceConfig.uniqueName);
      final String functionName = 'dummyFunction';
      final route = '${instanceConfig.functionEndpoint}/$functionName';
      final params = {'x': 2, 'y': 7};
      final serverDataResponse = [
        {'data': 14, 'objectId': 'ante'},
        {'data': 15, 'objectId': 'blue'},
      ];
      dioAdapter.onPost(
        route,
        (server) => server.reply(201, serverDataResponse),
        headers: {
          'content-type': 'application/json; charset=utf-8',
        },
        queryParameters: params,
      );
      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(appConfig: appConfig, config: config);
      // when
      final result = await provider.executeListFunction(
        functionName: functionName,
        documentClass: documentClass,
        params: params,
      );
      // then

      expect(result.data, serverDataResponse);
      expect(result.queryReturnType, QueryReturnType.futureList);
      expect(result.success, isTrue);
    });
  });
}

getItBindings(String instanceName) {
  final provider = BaseDataProvider();
  getIt.registerSingleton<IDataProvider>(
    provider,
    instanceName: instanceName,
  );
  getIt.registerSingleton<RestDataProviderDelegate>(
    DefaultRestDataProviderDelegate(),
    instanceName: instanceName,
  );
  getIt.registerFactory<QuerySelector>(
    () => DefaultQuerySelector(dataProvider: provider),
    instanceName: instanceName,
  );
  getIt.registerFactory<Authenticator>(
    () => NoAuthenticator(provider),
    instanceName: instanceName,
  );
}

AppConfig createAppConfig() {
  AppConfig appConfig = AppConfig(
    data: {
      'group': {'instance': {}},
    },
  );
  return appConfig;
}
