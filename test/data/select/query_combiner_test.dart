import 'package:takkan_script/schema/query_combiner.dart';
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
      final actual1 = QueryCombiner.fromSource(expression1, null);
      final actual2 = QueryCombiner.fromSource(expression2, null);
      final actual3 = QueryCombiner.fromSource(expression3, null);
      final actual4 = QueryCombiner.fromSource(expression4, null);
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
      final actual = QueryCombiner.fromSource(expression, null);
      // then

      final c = actual.conditions[0];
      expect(c, expected);

      expect(c.cloudOut, 'query.equalTo("a",5);');
    });
    test('equals String, inner single quotes', () {
      // given
      const expression = "a == 'x'";
      // when
      final actual = QueryCombiner.fromSource(expression, null);
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
      final actual = QueryCombiner.fromSource(expression, null);
      // then

      final c = actual.conditions[0];
      expect(c,
          const Condition(field: 'a', operator: Operator.equalTo, value: 'x'));
      expect(c.cloudOut, 'query.equalTo("a","x");');
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
          QueryCombiner.fromSource('test == "yes"', null).conditions[0];
      expect(condition.cloudOut, 'query.equalTo("test","yes");');
      condition = QueryCombiner.fromSource('test != "yes"', null).conditions[0];
      expect(condition.cloudOut, 'query.notEqualTo("test","yes");');
      condition = QueryCombiner.fromSource('test > "yes"', null).conditions[0];
      expect(condition.cloudOut, 'query.greaterThan("test","yes");');
    });
  });
}
