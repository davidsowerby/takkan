import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/app/app_config_loader.dart';
import 'package:takkan_backend/backend/data_provider/constants.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:test/test.dart';

import '../../fixtures/matchers.dart';
import '../../fixtures/mocks.dart';

void main() {
  group('AppConfig', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('back4app group sets instance type', () async {
      // given
      final Map<String, dynamic> data = {
        'back4app': {
          'isGroup': true,
          'instance1': {
            'headers': {
              keyHeaderApplicationId: 'test',
              keyHeaderClientKey: 'test',
            }
          }
        }
      };
      getIt.reset();
      getIt.registerFactory<JsonFileLoader>(() => DirectFileLoader(data: data));
      final AppConfig appConfig = AppConfig();
      await appConfig.load();

      // when
      final instance = appConfig.group('back4app').instance('instance1');
      // then

      expect(instance.serviceType, 'back4app');
    });

    test('access instanceConfig, valid group, valid selectedInstance',
        () async {
      // given

      final Map<String, dynamic> data = {
        'core': {
          'isGroup': true,
          'dev': {'serverUrl': 'https://dev.com'},
          'test': {'serverUrl': 'https://test.com'},
          'selectedInstance': 'test',
        },
      };
      getIt.reset();
      getIt.registerFactory<JsonFileLoader>(() => DirectFileLoader(data: data));
      final AppConfig appConfig = AppConfig();
      await appConfig.load();

      final MockDataProviderConfig mockDpValid = MockDataProviderConfig();
      when(() => mockDpValid.instanceConfig)
          .thenReturn(const AppInstance(group: 'core', instance: 'test'));

      // when

      // then

      expect(appConfig.instanceConfig(mockDpValid), isA<InstanceConfig>());
    });
    test('access instanceConfig, valid group, invalid instance', () async {
      // given
      final Map<String, dynamic> data = {
        'core': {
          'test': {'serverUrl': 'https://test.com'}
        }
      };

      getIt.reset();
      getIt.registerFactory<JsonFileLoader>(() => DirectFileLoader(data: data));
      final AppConfig appConfig = AppConfig();
      await appConfig.load();

      final MockDataProviderConfig mockDpInvalidInstance =
          MockDataProviderConfig();
      when(() => mockDpInvalidInstance.instanceConfig)
          .thenReturn(const AppInstance(group: 'back4app', instance: 'wiggly'));

      // when

      // then

      expect(() => appConfig.instanceConfig(mockDpInvalidInstance),
          throwsTakkanException);
    });
    test('instanceConfig, default values', () async {
      // given
      final Map<String, dynamic> data = {
        'back4app': {
          'isGroup': true,
          'instance1': {
            'headers': {
              keyHeaderApplicationId: 'test',
              keyHeaderClientKey: 'test',
            }
          }
        }
      };

      getIt.reset();
      getIt.registerFactory<JsonFileLoader>(() => DirectFileLoader(data: data));
      final AppConfig appConfig = AppConfig();
      await appConfig.load();

      // when
      final instance = appConfig.group('back4app').instance('instance1');
      // then

      expect(
          instance.cloudCodeDirectory.path,
          Directory(
                  '${Platform.environment['HOME']!}/b4a/MyApp/instance1/cloud')
              .path);
      expect(instance.serviceType, 'back4app');
      expect(instance.serverUrl, 'https://parseapi.back4app.com');
      expect(instance.name, 'instance1');
      expect(instance.clientKey, 'test');
      expect(instance.appId, 'test');
      expect(instance.appName, 'MyApp');
      expect(instance.parent.selectedInstanceName, 'instance1');
      expect(
          instance.documentEndpoint, 'https://parseapi.back4app.com/classes');
      expect(instance.graphqlEndpoint, 'https://parseapi.back4app.com/graphql');
    });
  });
  group('InstanceConfig', () {});
  group('AppConfigLoader', () {});
  group('AppConfig', () {
    test('inheritance', () async {
      // given
      getIt.reset();
      getIt
          .registerFactory<JsonFileLoader>(() => const DefaultJsonFileLoader());
      final AppConfig appConfig = AppConfig();
      await appConfig.load(filePath: 'test/backend/app/sample-takkan.json');

      // when

      // then

      final GroupConfig main = appConfig.group('main');
      final InstanceConfig dev = main.instance('dev');
      expect(dev.appName, 'Sample App');
      expect(dev.serviceType, 'back4app');
      expect(dev.serverUrl, 'https://parseapi.back4app.com');
      expect(dev.documentEndpoint, 'https://parseapi.back4app.com/classes');
      expect(dev.functionEndpoint, 'https://parseapi.back4app.com/functions');
      expect(dev.graphqlEndpoint, 'https://parseapi.back4app.com/graphql');
      expect(dev.clientKey, 'dev client key');
      expect(dev.appId, 'dev app id');

      final InstanceConfig test = main.instance('test');
      expect(test.appName, 'Sample App');
      expect(test.serviceType, 'back4app');
      expect(test.serverUrl, 'http://localhost:1337/parse/');
      expect(test.documentEndpoint, 'http://localhost:1337/parse/classes');
      expect(test.functionEndpoint, 'http://localhost:1337/parse/functions');
      expect(test.graphqlEndpoint, 'http://localhost:1337/parse/graphql');
      expect(test.clientKey, 'test client key');
      expect(test.appId, 'test app id');
    });
  });
  group('Create from data', () {
    test('Compare direct and file loaded', () async {
      // given

      getIt.reset();
      getIt
          .registerFactory<JsonFileLoader>(() => const DefaultJsonFileLoader());

      // when
      final AppConfig appConfig1 = AppConfig();
      await appConfig1.load(filePath: 'test/backend/app/sample-takkan.json');
      final AppConfig appConfig2 = AppConfig.fromData(data: sampleData);
      // then

      expect(appConfig1.data, appConfig2.data);
      expect(appConfig1.isReady, appConfig2.isReady);
    });
    test('Mixed properties and groups', () async {
      // given
      getIt.reset();
      getIt
          .registerFactory<JsonFileLoader>(() => const DefaultJsonFileLoader());
      // when
      final AppConfig appConfig = AppConfig();
      await appConfig.load(filePath: 'test/backend/app/sample-takkan2.json');
      // then

      expect(
        appConfig.property(propertyName: 'exportFilePath', defaultValue: '?'),
        'tmp:takkan_export',
      );
      expect(appConfig.groups.length, 2);
      expect(appConfig.groups.map((e) => e.name).toList(),
          ['main', 'I am a group']);
      expect(appConfig.takkanStoreConfig.isNotEmpty, isTrue);
    });
  });
}

/// This must be a replica of file 'test/backend/app/sample-takkan.json'
const sampleData = {
  'main': {
    'appName': 'Sample App',
    'type': 'back4app',
    'stages': ['dev', 'test', 'qa', 'prod'],
    'serverUrl': 'https://parseapi.back4app.com',
    'dev': {
      'headers': {
        'X-Parse-Application-Id': 'dev app id',
        'X-Parse-Client-Key': 'dev client key'
      }
    },
    'test': {
      'headers': {
        'X-Parse-Application-Id': 'test app id',
        'X-Parse-Client-Key': 'test client key'
      },
      'serverUrl': 'http://localhost:1337/parse/'
    },
    'qa': {
      'headers': {
        'X-Parse-Application-Id': 'qa app id',
        'X-Parse-Client-Key': 'qa client key'
      }
    },
    'prod': {
      'headers': {
        'X-Parse-Application-Id': 'prod app id',
        'X-Parse-Client-Key': 'prod client key'
      }
    }
  },
  'public REST': {
    'type': 'rest',
    'restcountries': {
      'headers': {},
      'documentEndpoint': 'https://restcountries.eu/'
    }
  }
};
