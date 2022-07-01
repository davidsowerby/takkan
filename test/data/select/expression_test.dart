import 'package:takkan_medley_script/medley/medley_schema.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/expression.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('Expressions', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('whitespace', () {
      // given
      const expression1 = 'a == 5';
      const expression2 = 'a== 5';
      const expression3 = 'a==5';
      const expression4 = 'a   ==         5';
      // when
      final actual1 = Expression.fromSource(expression1, null);
      final actual2 = Expression.fromSource(expression2, null);
      final actual3 = Expression.fromSource(expression3, null);
      final actual4 = Expression.fromSource(expression4, null);
      // then

      expect(actual1.conditions.length, 1);
      expect(actual2.conditions.length, 1);
      expect(actual3.conditions.length, 1);
      expect(actual4.conditions.length, 1);
    });
    test('equals number', () {
      // given
      const expression = 'a == 5';
      const expected = Condition(
        field: 'a',
        operator: Operator.equalTo,
        value: 5,
      );
      // when
      final actual = Expression.fromSource(expression, null);
      // then

      final c = actual.conditions[0];
      expect(c, expected);

      expect(c.cloudOut, 'query.equalTo("a",5);');
    });
    test('equals String, inner single quotes', () {
      // given
      const expression = "a == 'x'";
      // when
      final actual = Expression.fromSource(expression, null);
      // then

      final c = actual.conditions[0];
      expect(c,
          const Condition(field: 'a', operator: Operator.equalTo, value: 'x'));
      expect(c.cloudOut, 'query.equalTo("a","x");');
    });
    test('equals String, inner double quotes', () {
      // given
      const expression = 'a == "x"';
      // when
      final actual = Expression.fromSource(expression, null);
      // then

      final c = actual.conditions[0];
      expect(c,
          const Condition(field: 'a', operator: Operator.equalTo, value: 'x'));
      expect(c.cloudOut, 'query.equalTo("a","x");');
    });
    test('usage', () {
      // given
      final filter = DocByFilter(
        name: 'test',
        queryScript: "firstName=='Jack' && age==22",
        query: medleySchema1.query('Person',(q) => [
              q['height'].int.equalTo(152),
              q['lastName'].string.equalTo('Hazel'),
            ]),
      );

      // when
      final actual = filter.expression;
      // then

      expect(actual.conditions.length, 4);
      expect(actual.conditions[0].field, 'age');
      expect(actual.conditions[0].operator, Operator.equalTo);
      expect(actual.conditions[0].value, 22);
      expect(actual.conditions[1].field, 'firstName');
      expect(actual.conditions[1].operator, Operator.equalTo);
      expect(actual.conditions[1].value, 'Jack');
      expect(actual.conditions[2].field, 'height');
      expect(actual.conditions[2].operator, Operator.equalTo);
      expect(actual.conditions[2].value, 152);
      expect(actual.conditions[3].field, 'lastName');
      expect(actual.conditions[3].operator, Operator.equalTo);
      expect(actual.conditions[3].value, 'Hazel');
    });
    test('Json round trip', () {
      // given
      final filter = DocByFilter(
        name: 'test',
        queryScript: "b=='yes'",
      );
      // when
      final actual = DocByFilter.fromJson(filter.toJson());
      // then

      expect(actual.expression, filter.expression);
    });
    test('Query all conditions', () {
      // given

      // when

      // then
// ignore: strict_raw_type
//       Condition condition = Query().equalTo('test', 'yes').conditions[0];
//       expect(condition.cloudOut, 'query.equalTo("test","yes");');
//       condition = Query().notEqualTo('test', 'yes').conditions[0];
//       expect(condition.cloudOut, 'query.notEqualTo("test","yes");');
//       condition = Query().greaterThan('test', 'yes').conditions[0];
//       expect(condition.cloudOut, 'query.greaterThan("test","yes");');
    });
    test('Script all conditions', () {
      // ignore: strict_raw_type
      Condition condition =
          Expression.fromSource('test == "yes"', null).conditions[0];
      expect(condition.cloudOut, 'query.equalTo("test","yes");');
      condition = Expression.fromSource('test != "yes"', null).conditions[0];
      expect(condition.cloudOut, 'query.notEqualTo("test","yes");');
      condition = Expression.fromSource('test > "yes"', null).conditions[0];
      expect(condition.cloudOut, 'query.greaterThan("test","yes");');
    });
  });
}
