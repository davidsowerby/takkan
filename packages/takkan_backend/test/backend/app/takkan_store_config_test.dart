import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:test/test.dart';

import '../../fixtures/matchers.dart';

void main() {
  group('TakkanStoreConfig, valid data', () {
    test('empty', () {
      // given
      final AppConfig appConfig = AppConfig.fromData(data: {});
      final config = appConfig.takkanStoreConfig;
      // when

      // then

      expect(config.isEmpty, isTrue);
      expect(config.isNotEmpty, isFalse);
    });
    test('all in one', () {
      // given
      final AppConfig appConfig = AppConfig.fromData(data: {
        'takkan_store': {
          'type': 'back4app',
          'all': {
            'headers': {
              'X-Parse-Application-Id': 'ccc',
              'X-Parse-Client-Key': 'ddd'
            }
          }
        }
      });
      final config = appConfig.takkanStoreConfig;
      // when

      // then

      expect(config.type, 'back4app', reason: 'defaults to back4app');
      expect(config.scriptStoreConfig.appId, 'ccc');
      expect(config.scriptStoreConfig.clientKey, 'ddd');
      expect(config.schemaStoreConfig.appId, 'ccc');
      expect(config.schemaStoreConfig.clientKey, 'ddd');
    });
    test('script and schema separate', () {
      // given
      final AppConfig appConfig = AppConfig.fromData(data: {
        'takkan_store': {
          'type': 'back4app',
          'script': {
            'headers': {
              'X-Parse-Application-Id': 'ccc',
              'X-Parse-Client-Key': 'ddd'
            }
          },
          'schema': {
            'headers': {
              'X-Parse-Application-Id': 'aaa',
              'X-Parse-Client-Key': 'bbb'
            }
          }
        }
      });
      final config = appConfig.takkanStoreConfig;
      // when

      // then

      expect(config.type, 'back4app', reason: 'defaults to back4app');
      expect(config.scriptStoreConfig.appId, 'ccc');
      expect(config.scriptStoreConfig.clientKey, 'ddd');
      expect(config.schemaStoreConfig.appId, 'aaa');
      expect(config.schemaStoreConfig.clientKey, 'bbb');
    });
  });

  group('TakkanStoreConfig, invalid data', () {
    test('script defined, no schema', () {
      final AppConfig appConfig = AppConfig.fromData(data: {
        'takkan_store': {
          'type': 'back4app',
          'script': {
            'headers': {
              'X-Parse-Application-Id': 'ccc',
              'X-Parse-Client-Key': 'ddd'
            }
          },
        }
      });
      final config = appConfig.takkanStoreConfig;
      // then

      expect(config.type, 'back4app', reason: 'defaults to back4app');
      expect(config.scriptStoreConfig.appId, 'ccc');
      expect(config.scriptStoreConfig.clientKey, 'ddd');
      expect(() => config.schemaStoreConfig.appId, throwsTakkanException);
      expect(() => config.schemaStoreConfig.clientKey, throwsTakkanException);
    });
    test('schema defined no script', () {
      // given
      final AppConfig appConfig = AppConfig.fromData(data: {
        'takkan_store': {
          'type': 'back4app',
          'schema': {
            'headers': {
              'X-Parse-Application-Id': 'ccc',
              'X-Parse-Client-Key': 'ddd'
            }
          },
        }
      });
      final config = appConfig.takkanStoreConfig;
      // then

      expect(config.type, 'back4app', reason: 'defaults to back4app');
      expect(() => config.scriptStoreConfig.appId, throwsTakkanException);
      expect(() => config.scriptStoreConfig.clientKey, throwsTakkanException);
      expect(config.schemaStoreConfig.appId, 'ccc');
      expect(config.schemaStoreConfig.clientKey, 'ddd');
    });
    test('script and all defined', () {
      // given
      final Map<String, dynamic> data = {
        'takkan_store': {
          'type': 'back4app',
          'script': {
            'headers': {
              'X-Parse-Application-Id': 'ccc',
              'X-Parse-Client-Key': 'ddd'
            }
          },
          'all': {
            'headers': {
              'X-Parse-Application-Id': 'ccc',
              'X-Parse-Client-Key': 'ddd'
            }
          },
        }
      };
      // when then
      expect(() => AppConfig.fromData(data: data), throwsTakkanException);
    });
    test('schema and all defined', () {
      // given
      final Map<String, dynamic> data = {
        'takkan_store': {
          'type': 'back4app',
          'schema': {
            'headers': {
              'X-Parse-Application-Id': 'ccc',
              'X-Parse-Client-Key': 'ddd'
            }
          },
          'all': {
            'headers': {
              'X-Parse-Application-Id': 'ccc',
              'X-Parse-Client-Key': 'ddd'
            }
          },
        }
      };
      // when then
      expect(() => AppConfig.fromData(data: data), throwsTakkanException);
    });
  });
}
