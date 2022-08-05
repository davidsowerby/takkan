import 'package:takkan_script/data/select/condition/condition.dart';
import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/field/string.dart';
import 'package:takkan_script/schema/query/query.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
import 'package:test/test.dart';

void main() {
  group('Expressions', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('combine script and query', () {
      // given
      final Schema schema =
          Schema(name: 'test', version: const Version(number: 0), documents: {
        'Person': Document(
          fields: {
            'firstName': FString(),
            'lastName': FString(),
            'age': FInteger(),
          },
          queries: {
            'adults': Query(
              conditions: [
                C('age').int.equalTo(152),
                C('lastName').string.equalTo('Hazel'),
              ],
              queryScript: "firstName == 'Jack'",
              returnSingle: true,
            ),
          },
        )
      });
      final Script script = Script(
          name: 'test', version: const Version(number: 0), schema: schema);

      // when
      script.init();
      final query = schema.document('Person').query('adults');
      // then

      expect(query.conditions.length, 2);
      expect(query.combinedConditions.length, 3);
      expect(query.combinedConditions[0].field, 'age');
      expect(query.combinedConditions[0].operator, Operator.equalTo);
      expect(query.combinedConditions[0].reference, 152);
      expect(query.combinedConditions[1].field, 'firstName');
      expect(query.combinedConditions[1].operator, Operator.equalTo);
      expect(query.combinedConditions[1].reference, 'Jack');
    });
  });
}
