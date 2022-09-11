import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/field/integer.dart';
import 'package:takkan_schema/schema/field/string.dart';
import 'package:takkan_schema/schema/query/query.dart';
import 'package:takkan_schema/schema/schema.dart';
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


      // when
      schema.init();
      final query = schema.document('Person').query('adults');
      // then

      expect(query.conditions.length, 2);
      expect(query.combinedConditions.length, 3);
      expect(query.combinedConditions[0].field, 'age');
      expect(query.combinedConditions[0].operator, Operator.equalTo);
      expect(query.combinedConditions[0].operand, 152);
      expect(query.combinedConditions[1].field, 'firstName');
      expect(query.combinedConditions[1].operator, Operator.equalTo);
      expect(query.combinedConditions[1].operand, 'Jack');
    });
  });
}
