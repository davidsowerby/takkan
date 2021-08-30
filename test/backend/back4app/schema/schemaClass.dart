import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/schemaConverter.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';

void main() {
  group('Data Types', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('name not required', () {
      // given
      final expected = {
        "className": "Sample",
        "fields": {
          "name": {
            "type": "String",
            "required": false,
          },
        }
      };
      final PDocument document = PDocument(fields: {
        'name': PString(required: false),
      });
      final PSchema schema = PSchema(name: 'test', documents: {
        'Sample': document,
      });
      schema.init();
      final SchemaClass clazz = SchemaClass.fromPrecept(document);
      // when

      // then

      expect(clazz.toJson(), expected);
    });
  });
  group('CLP', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given

      // when

      // then

      expect(1, 0);
    });
  });
}

final nameNotRequired = r'''"name": {
"type": "String",
"required": false
}''';
