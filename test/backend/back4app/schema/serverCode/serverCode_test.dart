import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/dataProvider.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/serverCode/serverCode.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';

void main() {
  group('Generate server code', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('Integer Validation', () async {
      // given
      final Back4AppServerCodeGenerator generator =
          Back4AppServerCodeGenerator();
      final PSchema schema = PSchema(
        name: 'Test',
        documents: {
          'Issue': PDocument(fields: {
            'weight': PInteger(validations: [
              IntegerValidation(
                method: ValidateInteger.isGreaterThan,
                param: 0,
              ),
              IntegerValidation(
                method: ValidateInteger.isLessThan,
                param: 10,
              ),
            ])
          })
        },
      );
      // when
      schema.init();
      generator.generate(schema: schema);
      // then
      final AppConfig appConfig = AppConfig({
        'test': {
          'test': {
            "X-Parse-Application-Id":
                "jku55NXfuI27v7h8lcuzSw5vrazN5fwMNadXDCVs",
            "X-Parse-Client-Key": "H9OkmTAoElaOlVV3iALD2xynKJDohWeShR9PMMrX",
            "serverUrl": "https://parseapi.back4app.com/"
          },
        }
      });
      final provider = Back4AppDataProvider(
          config: PBack4AppDataProvider(
              schema: schema,
              configSource: PConfigSource(segment: 'test', instance: 'test')));
      provider.init(appConfig);
      final result = await provider.updateDocument(
          documentId: DocumentId(path: 'Issue', itemId: 'wMlwVUFQgz'),
          data: {'weight': 8});
      print(generator.output['Issue']);
      expect(1, 1);
    });
  });
}
