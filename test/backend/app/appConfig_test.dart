import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_script/data/provider/dataProvider.dart';

import '../../fixtures/matchers.dart';
import '../../fixtures/mocks.dart';

void main() {
  group('AppConfig', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('correct structure', () {
      // given
      final AppConfig appConfig = AppConfig({
        'segment': {
          'instance1': {'serverUrl': 'https://test.com'}
        }
      });
      final MockPDataProvider mockDp = MockPDataProvider();

      // when
      when(() => mockDp.configSource)
          .thenReturn(PConfigSource(segment: 'segment', instance: 'instance1'));
      // then

      expect(appConfig.instanceConfig(mockDp), isNotNull);

      // when
      when(() => mockDp.configSource)
          .thenReturn(PConfigSource(segment: 'segment', instance: 'instance2'));

      // then
      expect(() => appConfig.instanceConfig(mockDp), throwsPreceptException);

      // when
      when(() => mockDp.configSource).thenReturn(
          PConfigSource(segment: 'segment2', instance: 'instance1'));

      // then
      expect(() => appConfig.instanceConfig(mockDp), throwsPreceptException);
    });
  });
}
