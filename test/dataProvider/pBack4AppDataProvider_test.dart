import 'package:precept_back4app_backend/backend/back4app/dataProvider/dataProvider.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/script.dart';
import 'package:test/test.dart';

void main() {
  group('DataProvider', () {
    Map<String, Map<String, Map<String, dynamic>>> appConfig = {
      'back4app': {
        'dev': {
          PBack4AppDataProvider.appIdKey: 'at4dM5dN0oCRryJp7VtTccIKZY9l3GtfHre0Hoow',
          PBack4AppDataProvider.clientIdKey: 'DPAF2DQCDVJ9Zmbp8vyaDhfC1XXjDdEveJqIwLYc',
          PBack4AppDataProvider.serverUrlKey: 'https://parseapi.back4app.com',
        }
      }
    };
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
    });

    tearDown(() {});

    test('CRUD', () async {
      // given

      final config =
          PBack4AppDataProvider(configSource: PConfigSource(segment: 'back4app', instance: 'dev'));
      config.appConfig = appConfig;

      final PGet query = PGet(documentId: DocumentId(path: 'Account', itemId: 'wVdGK8TDXR'));
      final PScript script = PScript(dataProvider: config, query: query);
      script.init();
      Back4AppDataProvider dataProvider = Back4AppDataProvider(config: script.dataProvider);
      // when
      final Data result = await dataProvider.get(query: query);
      // then

      expect(result.documentId.path, 'Account');
      expect(result.documentId.itemId, 'wVdGK8TDXR');
      expect(result.data['category'], 'updated5');

      // when
      final updateResponse = await dataProvider.update(
        documentId: query.documentId,
        changedData: {'category': 'updated'},
      );

      // then
      expect(updateResponse, true);
    });
  });
}
