import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/dataProvider/restDataProvider.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/configLoader.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/script.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

void main() {
  group('DataProvider', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<ConfigLoader>(() => MockConfigLoader());
    });

    tearDown(() {});

    test('CRUD', () async {
      // given
      final PGet query = PGet(documentId: DocumentId(path: 'Account', itemId: 'wVdGK8TDXR'));
      final PScript script = PScript(
          dataProvider: PBack4AppDataProvider(
            env: Env.test,
            instanceName: 'test',
            appId: 'at4dM5dN0oCRryJp7VtTccIKZY9l3GtfHre0Hoow',
            clientKey: 'DPAF2DQCDVJ9Zmbp8vyaDhfC1XXjDdEveJqIwLYc',
            baseUrl: 'https://parseapi.back4app.com',
          ),
          query: query);
      script.init();
      RestDataProvider dataProvider = RestDataProvider(config: script.dataProvider);
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
