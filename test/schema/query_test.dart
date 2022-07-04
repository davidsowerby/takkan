import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/field/string.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
import 'package:test/test.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final Schema schema = Schema(
        name: 'test',
        version: const Version(number: 0),
        documents: {
          'Person': Document(
            fields: {
              'firstName': FString(),
              'lastName': FString(),
              'age': FInteger(
                validations: [
                  const VInteger.greaterThan(0),
                  const VInteger.lessThan(128),
                ],
              ),
            },
            queries: {
              'adults': (q) => [
                    q['age'].int.equalTo(152),
                    q['lastName'].string.equalTo('Hazel'),
                  ]
            },
          )
        },
      );
      final Script script = Script(
          name: 'test', version: const Version(number: 0), schema: schema);

      // when
      script.init();
      final query=schema.document('Person').query('adults');
      // then

      expect(query.conditions.length, 2);
      expect(query.conditions[0].field,'age');
      expect(query.conditions[0].value,152);
    });
  });
}
