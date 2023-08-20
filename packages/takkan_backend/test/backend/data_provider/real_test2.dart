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
import 'package:takkan_script/inject/inject.dart';
import 'package:test/test.dart';

void main() {
  final DataProvider config = DataProvider(
    instanceConfig: const AppInstance(
      group: 'main',
      instance: 'test',
    ),
  );
  group('Positive tests', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      const instanceName = 'main:test';
      getIt.registerFactory<RestServerConnect>(
        () => const DefaultRestServerConnect(),
        instanceName: instanceName,
      );
      final provider = GenericDataProvider();
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
                'selectedInstance': 'test',
                'type': 'back4app',
                'dev': {
                  'headers': {
                    'X-Parse-Application-Id':
                        'QXt7fp7YEXrgUmGJ5GZTnTmPXGNvOGZBfVYW1h9X',
                    'X-Parse-Client-Key':
                        'Hs8b03ZT4GnvcsOzVtkNno8OSSGVrh0JkIdefFxr'
                  }
                },
                'test': {
                  'headers': {
                    'X-Parse-Application-Id':
                        'MPzfLSZsSRKqkxnPhjTmliFgGLhM7Ai0veYG2EtO',
                    'X-Parse-Client-Key':
                        'lbmSTPMeamne2GPA2arpdgPcPuCSTepAtT4r46pe'
                  }
                }
              }
            },
          ));
      getIt.registerSingletonAsync<AppConfig>(() {
        final AppConfig appConfig = AppConfig();
        return appConfig.load();
      });
    });

    tearDown(() {});

    test('executeFunction', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);

      const String functionName = 'hello';
      final params = {'name': 'Wiggly'};
      final expectedResponse = {'result': 'Hello Wiggly'};

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

      expect(result.data, expectedResponse);
      expect(result.success, isTrue);
    });
    test('functionItem', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);

      const String functionName = 'topIssue';
      final Map<String, dynamic> params = {};
      final expectedResponse = {
        'title': 'It broke',
        'description':
            'When I dropped it from a great height it shattered into thousands of pieces',
        'weight': 5,
        'createdAt': '2022-04-27T12:50:57.964Z',
        'updatedAt': '2022-04-27T14:02:06.219Z',
        'state': 'open',
        'objectId': 'YP3pFS1XI3',
        '__type': 'Object',
        'className': 'Issue'
      };

      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(config: config);
      // when
      final result = await provider.fetchDocument(
        functionName: functionName,
        documentClass: 'Issue',
        params: params,
      );
      // then

      expect(result.data, expectedResponse);
      expect(result.success, isTrue);
    });
    test('functionList', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);

      const String functionName = 'issuesWeight';
      final Map<String, dynamic> params = {'weight': 1};
      final expectedResponse = [
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
      ];

      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(config: config);
      // when
      final result = await provider.fetchDocumentList(
        functionName: functionName,
        documentClass: 'Issue',
        params: params,
      );
      // then

      expect(result.data, expectedResponse);
      expect(result.success, isTrue);
    });
    test('CRUD document', () async {
      // given
      await getIt.isReady<AppConfig>();
      final appConfig = inject<AppConfig>();
      final InstanceConfig instanceConfig = appConfig.instanceConfig(config);

      final createData = {
        'title': 'New creation',
        'description': 'All shiny',
        'weight': 4,
        'state': 'open',
      };

      final provider = inject<IDataProvider>(
        instanceName: instanceConfig.uniqueName,
      );
      provider.init(config: config);
      // when
      final result = await provider.createDocument(
        documentClass: 'Issue',
        data: createData,
      );
      // then

      expect(result.data.containsKey('createdAt'), isTrue);
      expect(result.data.containsKey('objectId'), isTrue);
      expect(result.documentId.documentClass, 'Issue');
      expect(result.documentId.objectId, result.data['objectId']);
      expect(result.success, isTrue);

      final documentId = result.documentId;

      final createReadResult = await provider.readDocument(
        documentId: documentId,
      );

      expect(createReadResult.documentId, documentId);
      expect(createReadResult.success, isTrue);
      expect(createReadResult.data['title'], 'New creation');

      final updateResult = await provider.updateDocument(
        documentId: documentId,
        data: {'title': 'shiny and updated'},
      );

      expect(updateResult.success, isTrue);

      final updateReadResult = await provider.readDocument(
        documentId: documentId,
      );

      expect(updateReadResult.data['title'], 'shiny and updated');

      final deleteResult = await provider.deleteDocument(
        documentId: documentId,
      );

      expect(deleteResult.objectId, documentId.objectId);
    });
  });
}
