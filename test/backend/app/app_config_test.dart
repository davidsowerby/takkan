import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/app/app_config_loader.dart';
import 'package:precept_backend/backend/data_provider/constants.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:test/test.dart';

import '../../fixtures/matchers.dart';
import '../../fixtures/mocks.dart';

void main() {
  group('AppConfig', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('back4app group sets instance type', () {
      // given
      final AppConfig appConfig = AppConfig(
        data: {
          'back4app': {
            'instance1': {
              'headers': {
                keyHeaderApplicationId: 'test',
                keyHeaderClientKey: 'test',
              }
            }
          }
        },
      );
      // when
      final instance = appConfig.group('back4app').instance('instance1');
      // then

      expect(instance.type, 'back4app');
    });

    test('access instanceConfig, valid & invalid instance', () {
      // given
      final AppConfig appConfig = AppConfig(
        data: {
          'group1': {
            'instance1': {'serverUrl': 'https://test.com'}
          }
        },
      );
      final MockPDataProvider mockDpValid = MockPDataProvider();
      final MockPDataProvider mockDpInvalidInstance = MockPDataProvider();
      final MockPDataProvider mockDpInvalidGroup = MockPDataProvider();
      when(() => mockDpValid.instanceConfig)
          .thenReturn(PInstance(group: 'group1', instance: 'instance1'));
      when(() => mockDpInvalidInstance.instanceConfig)
          .thenReturn(PInstance(group: 'group1', instance: 'instance2'));
      when(() => mockDpInvalidGroup.instanceConfig)
          .thenReturn(PInstance(group: 'group2', instance: 'instance1'));

      // when

      // then

      expect(appConfig.instanceConfig(mockDpValid), isA<InstanceConfig>());
      expect(() => appConfig.instanceConfig(mockDpInvalidInstance),
          throwsPreceptException);
      expect(() => appConfig.instanceConfig(mockDpInvalidGroup),
          throwsPreceptException);
    });
    test('instanceConfig, default values', () {
      // given
      final AppConfig appConfig = AppConfig(
        data: {
          'back4app': {
            'instance1': {
              'headers': {
                keyHeaderApplicationId: 'test',
                keyHeaderClientKey: 'test',
              }
            }
          }
        },
      );
      // when
      final instance = appConfig.group('back4app').instance('instance1');
      // then

      expect(
          instance.cloudCodeDirectory.path,
          Directory(
                  '${Platform.environment['HOME']!}/b4a/MyApp/instance1/cloud')
              .path);
      expect(instance.type, 'back4app');
      expect(instance.serverUrl, 'https://parseapi.back4app.com');
      expect(instance.name, 'instance1');
      expect(instance.clientKey, 'test');
      expect(instance.appId, 'test');
      expect(instance.appName, 'MyApp');
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

      // when
      final appConfig = await AppConfigFileLoader(
              fileName: 'test/backend/app/sample-precept.json')
          .load(currentStage: 'dev');
      // then

      expect(appConfig.appName, 'MyApp');
      expect(appConfig.type, 'back4app');
      expect(appConfig.serverUrl, 'https://parseapi.back4app.com');
      expect(appConfig.documentStub, 'classes');
      expect(appConfig.functionStub, 'functions');
      expect(appConfig.graphqlStub, 'graphql');
      expect(
          appConfig.documentEndpoint, 'https://parseapi.back4app.com/classes');
      expect(appConfig.functionEndpoint,
          'https://parseapi.back4app.com/functions');
      expect(
          appConfig.graphqlEndpoint, 'https://parseapi.back4app.com/graphql');

      final GroupConfig main = appConfig.group('main');
      expect(main.appName, 'Sample App');
      expect(main.type, 'back4app');
      expect(main.stages, ["dev", "test", "qa", "prod"]);
      expect(main.serverUrl, 'https://parseapi.back4app.com');
      expect(main.documentStub, 'classes');
      expect(main.functionStub, 'functions');
      expect(main.graphqlStub, 'graphql');
      expect(main.documentEndpoint, 'https://parseapi.back4app.com/classes');
      expect(main.functionEndpoint, 'https://parseapi.back4app.com/functions');
      expect(main.graphqlEndpoint, 'https://parseapi.back4app.com/graphql');

      final InstanceConfig dev = main.instance('dev');
      expect(dev.appName, 'Sample App');
      expect(dev.type, 'back4app');
      expect(dev.serverUrl, 'https://parseapi.back4app.com');
      expect(dev.documentStub, 'classes');
      expect(dev.functionStub, 'functions');
      expect(dev.graphqlStub, 'graphql');
      expect(dev.documentEndpoint, 'https://parseapi.back4app.com/classes');
      expect(dev.functionEndpoint, 'https://parseapi.back4app.com/functions');
      expect(dev.graphqlEndpoint, 'https://parseapi.back4app.com/graphql');
      expect(dev.clientKey, 'dev client key');
      expect(dev.appId, 'dev app id');

      final InstanceConfig test = main.instance('test');
      expect(test.appName, 'Sample App');
      expect(test.type, 'back4app');
      expect(test.serverUrl, "http://localhost:1337/parse/");
      expect(test.documentStub, 'classes');
      expect(test.functionStub, 'functions');
      expect(test.graphqlStub, 'graphql');
      expect(test.documentEndpoint, "http://localhost:1337/parse/classes");
      expect(test.functionEndpoint, "http://localhost:1337/parse/functions");
      expect(test.graphqlEndpoint, 'http://localhost:1337/parse/graphql');
      expect(test.clientKey, 'test client key');
      expect(test.appId, 'test app id');
    });
  });
}
