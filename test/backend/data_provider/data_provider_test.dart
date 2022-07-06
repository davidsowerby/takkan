import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/app/app_config_loader.dart';
import 'package:takkan_backend/backend/data_provider/base_data_provider.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/result_transformer.dart';
import 'package:takkan_backend/backend/data_provider/server_connect.dart';
import 'package:takkan_backend/backend/data_provider/url_builder.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/no_authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:test/test.dart';

import '../../fixtures/server_connect.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  final DataProvider config = DataProvider(
    instanceConfig: const AppInstance(
      group: 'main',
      instance: 'instance',
    ),
  );
  group('Positive tests', () {
    const baseUrl = 'https://example.com';
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      const instanceName = 'main:instance';
      dio = Dio(BaseOptions(baseUrl: baseUrl));
      dioAdapter = DioAdapter(dio: dio);
      getIt.registerFactory<RestServerConnect>(
        () => MockRestServerConnect(dio),
        instanceName: instanceName,
      );
      final provider = BaseDataProvider();
      getIt.registerFactory<Authenticator<DataProvider, TakkanUser>>(
        () => NoAuthenticator(provider),
        instanceName: instanceName,
      );
      getIt.registerFactory<URLBuilder>(
        () => DefaultURLBuilder(),
        instanceName: instanceName,
      );
      getIt.registerFactory<ResultTransformer>(
        () => DefaultResultTransformer(),
        instanceName: instanceName,
      );

      getIt.registerSingleton<IDataProvider>(
        provider,
        instanceName: instanceName,
      );
      getIt.registerFactory<JsonFileLoader>(() => const DirectFileLoader(
            data: {
              'main': {
                'selectedInstance': 'instance',
                'instance': {'headers': {}}
              },
            },
          ));
      getIt.registerSingletonAsync<AppConfig>(() {
        final AppConfig appConfig = AppConfig();
        return appConfig.load();
      });
    });

    tearDown(() {});

    test('fetchList', () async {
      // given

      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);
      final route = '${instanceConfig.functionEndpoint}/items';
      final returnedData = {
        'result': [
          {
            'title': 'Wrong colour again',
            'description': 'I like pink best',
            'weight': 1,
            'createdAt': '2022-04-27T12:51:29.378Z',
            'updatedAt': '2022-06-29T16:56:20.940Z',
            'state': 'open',
            'objectId': 'JJoGIErtzn',
            '__type': 'Object',
            'className': 'Issue'
          },
          {
            'title': 'Wrong way up',
            'description': 'When I picked it up it was upside down',
            'weight': 1,
            'createdAt': '2022-04-27T12:52:10.892Z',
            'updatedAt': '2022-07-10T15:40:21.029Z',
            'state': 'open',
            'objectId': 'MElJxXb7uM',
            '__type': 'Object',
            'className': 'Issue'
          }
        ]
      };
      // Mock the response
      dioAdapter.onPost(
        route,
        (server) => server.reply(200, returnedData),
      );
      final IDataProvider provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(config: config);
      // when
      final result = await provider.fetchDocumentList(
          functionName: 'items', documentClass: 'Person');
      // then

      expect(result.data, returnedData['result']);
      expect(result.returnSingle, false);
      expect(result.success, isTrue);
    });

    test('fetchItem', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);

      final route = '${instanceConfig.functionEndpoint}/item';
      final returnedData = {
        'result': [
          {
            'name': 'Adrian',
            'age': 23,
          }
        ]
      };

      dioAdapter.onPost(
        route,
        (server) => server.reply(200, returnedData),
      );
      final IDataProvider provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(config: config);
      // when
      final result = await provider.fetchDocument(
          functionName: 'item', params: {}, documentClass: 'Person');
      // then

      expect(result.data, {
        'name': 'Adrian',
        'age': 23,
      });
      expect(result.returnSingle, isTrue);
      expect(result.success, isTrue);
    });
    test('createDocument', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
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
          'content-length': encodedLength.toString()
        },
        data: data,
      );
      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(config: config);
      // when
      final result = await provider.createDocument(
        documentClass: 'Person',
        data: data,
      );
      // then

      expect(result.data, data);
      expect(result.returnSingle, isTrue);
      expect(result.success, isTrue);
    });
    test('updateDocument', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);

      final updateResponse = {'updatedAt': '2011-08-21T18:02:52.248Z'};
      const objectId = 'XXxxnnyy';
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
          'content-length': encodedLength.toString()
        },
        data: data,
      );
      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(config: config);
      // when
      final result = await provider.updateDocument(
        documentId: const DocumentId(documentClass: 'Person', objectId: objectId),
        data: data,
      );
      // then

      expect(result.data, updateResponse);
      expect(result.returnSingle, isTrue);
      expect(result.success, isTrue);
    });

    test('deleteDocument', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);

      final deleteResponse = {};
      const objectId = 'XXxxnnyy';
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
      provider.init(config: config);
      // when
      final result = await provider.deleteDocument(
        documentId: const DocumentId(documentClass: 'Person', objectId: objectId),
      );
      // then

      expect(result.data, deleteResponse);
      expect(result.returnSingle, isTrue);
      expect(result.success, isTrue);
    });

    test('executeFunction', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);

      const String functionName = 'dummyFunction';
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
      provider.init(config: config);
      // when
      final result = await provider.executeFunction(
        functionName: functionName,
        params: params,
      );
      // then

      expect(result.data, serverDataResponse);
      expect(result.success, isTrue);
    });
  });
}
