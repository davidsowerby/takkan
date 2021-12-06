import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/constants.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:test/test.dart';

import '../../fixtures/matchers.dart';
import '../../fixtures/mocks.dart';

void main() {
  group('AppConfig', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('back4app segment sets instance type', () {
      // given
      final AppConfig appConfig = AppConfig({
        'back4app': {
          'instance1': {
            'headers': {
              keyHeaderApplicationId: 'test',
              keyHeaderClientKey: 'test',
            }
          }
        }
      });
      // when
      final instance = appConfig.instanceCfg(
          PConfigSource(segment: 'back4app', instance: 'instance1'));
      // then

      expect(instance.type, 'back4app');
    });

    test('access instanceConfig, valid & invalid instance', () {
      // given
      final AppConfig appConfig = AppConfig({
        'segment1': {
          'instance1': {'serverUrl': 'https://test.com'}
        }
      });
      final MockPDataProvider mockDpValid = MockPDataProvider();
      final MockPDataProvider mockDpInvalidInstance = MockPDataProvider();
      final MockPDataProvider mockDpInvalidSegment = MockPDataProvider();
      when(() => mockDpValid.configSource).thenReturn(
          PConfigSource(segment: 'segment1', instance: 'instance1'));
      when(() => mockDpInvalidInstance.configSource).thenReturn(
          PConfigSource(segment: 'segment1', instance: 'instance2'));
      when(() => mockDpInvalidSegment.configSource).thenReturn(
          PConfigSource(segment: 'segment2', instance: 'instance1'));

      // when

      // then

      expect(appConfig.instanceConfig(mockDpValid), isA<InstanceConfig>());
      expect(() => appConfig.instanceConfig(mockDpInvalidInstance),
          throwsPreceptException);
      expect(() => appConfig.instanceConfig(mockDpInvalidSegment),
          throwsPreceptException);
    });
    test('instanceConfig, default values', () {
      // given
      final AppConfig appConfig = AppConfig({
        'back4app': {
          'instance1': {
            'headers': {
              keyHeaderApplicationId: 'test',
              keyHeaderClientKey: 'test',
            }
          }
        }
      });
      // when
      final instance = appConfig.instanceCfg(
          PConfigSource(segment: 'back4app', instance: 'instance1'));
      // then

      expect(
          instance.cloudCodeDirectory.path,
          Directory('${Platform.environment['HOME']!}/b4a/MyApp/instance1')
              .path);
      expect(instance.type, 'back4app');
      expect(instance.serverUrl, 'https://parseapi.back4app.com');
      expect(instance.instanceName, 'instance1');
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
}
