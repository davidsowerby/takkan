import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/constants.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/schemaConverter.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_script/data/provider/dataProvider.dart';

void main() {
  group('Schema downloader', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () async {
      // given
      Back4AppSchemaConverter converter = Back4AppSchemaConverter(
        appConfig: AppConfig({
          'back4app': {
            'sample': {
              "serverUrl": "https://parseapi.back4app.com/",
              keyHeaderMasterKey: 'V6L7p2yItRTn4ydRYzvcQVZT8haftbX2Ub24Nkpu',
              keyHeaderApplicationId:
                  'jku55NXfuI27v7h8lcuzSw5vrazN5fwMNadXDCVs',
            },
          },
        }),
        config: PBack4AppDataProvider(
          headerKeys: [keyHeaderMasterKey, keyHeaderApplicationId],
          configSource: PConfigSource(instance: 'sample', segment: 'back4app'),
        ),
      );
      // when
      final Map<String, dynamic> bs = await converter.getRawBackendSchema();

      File f = File('reference.json');
      // then
      f.writeAsStringSync(json.encode(bs));
      expect(1, 0);
    }, skip: true);
  });
}
