// ignore_for_file: strict_raw_type

import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/data/select/condition/integer_condition.dart';
import 'package:takkan_schema/data/select/condition/string_condition.dart';
import 'package:takkan_schema/schema/field/integer.dart';
import 'package:takkan_schema/schema/field/string.dart';
import 'package:takkan_schema/schema/query/expression.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('Expressions', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('whitespace', () {
      // given
      final Document document = Document(fields: {'a': FInteger()});

      const expression1 = 'a == 5';
      const expression2 = 'a== 5';
      const expression3 = 'a==5';
      const expression4 = 'a   ==         5';
      // when
      final actual1 = Expression(document: document)
          .parseQuery(expression: expression1);
      final actual2 = Expression(document: document)
          .parseQuery(expression: expression2);
      final actual3 = Expression(document: document)
          .parseQuery(expression: expression3);
      final actual4 = Expression(document: document)
          .parseQuery(expression: expression4);
      // then

      expect(actual1.length, 1);
      expect(actual2.length, 1);
      expect(actual3.length, 1);
      expect(actual4.length, 1);
      expect(actual1[0], isA<IntegerCondition>());
    });
    test('equals number', () {
      // given
      final Document document = Document(fields: {'a': FInteger()});
      const expression = 'a == 5';
      const expected = IntegerCondition(
        field: 'a',
        operator: Operator.equalTo,
        reference: 5,
      );
      // when
      final actual = Expression(document: document)
          .parseQuery(expression: expression);
      // then

      final c = actual[0];
      expect(c, expected);

      expect(c.cloudOut, 'query.equalTo("a", 5);');
    });
    test('equals String, inner single quotes', () {
      // given
      final Document document = Document(fields: {'a': FString()});
      const expression = "a == 'x'";
      // when
      final actual = Expression(document: document)
          .parseQuery(expression: expression);
      // then

      final c = actual[0];
      expect(
          c,
          const StringCondition(
              field: 'a', operator: Operator.equalTo, reference: 'x'));
      expect(c.cloudOut, 'query.equalTo("a", "x");');
    });
    test('equals String, inner double quotes', () {
      // given
      final Document document = Document(fields: {'a': FString()});
      const expression = 'a == "x"';
      // when
      final actual = Expression(document: document)
          .parseQuery(expression: expression);
      // then

      final c = actual[0];
      expect(
          c,
          const StringCondition(
              field: 'a', operator: Operator.equalTo, reference: 'x'));
      expect(c.cloudOut, 'query.equalTo("a", "x");');
    });
    test('validation', () {
      // given
      final Schema schema = Schema(documents: {'testDoc':Document(fields: {'a': FString()})}, version: const Version(number: 0), name: '');
      schema.init();
      const validation = '!="x" && !="y"';
            // when
      final document=schema.document('testDoc');
      final actual = Expression(document: document)
          .parseValidation(expression: validation, field: document.field('a'));
      // then

      expect(actual.length, 2);
      expect(actual[0].field, 'a');
      expect(actual[0].operator, Operator.notEqualTo);
      expect(actual[0].reference, 'x');
      expect(actual[1].field, 'a');
      expect(actual[1].operator, Operator.notEqualTo);
      expect(actual[1].reference, 'y');
    });

    group('String conditions', () {
      final schema = Schema(
        name: 'testSchema',
        version: const Version(number: 0),
        documents: {
          'testDoc': Document(fields: {'a': FString()})
        },
      );

      test('equalTo', () {
        // given
        schema.init();
        final document = schema.document('testDoc');
        const StringCondition expected = StringCondition(
          field: 'a',
          operator: Operator.equalTo,
          reference: 'yes',
        );
        // when
        final Condition actual = Expression(document: document)
            .parseQuery(expression: 'a == "yes"')[0];

        //then
        expect(actual, expected);
      });
      test('notEqualTo', () {
        // given
        schema.init();
        final document = schema.document('testDoc');
        const StringCondition expected = StringCondition(
          field: 'a',
          operator: Operator.notEqualTo,
          reference: 'yes',
        );
        // when
        final Condition actual = Expression(document: document)
            .parseQuery(expression: 'a != "yes"')[0];

        //then
        expect(actual, expected);
      });
      test('longerThan', () {
        // given
        schema.init();
        final document = schema.document('testDoc');
        const StringCondition expected = StringCondition(
          field: 'a',
          operator: Operator.greaterThan,
          reference: 'yes',
        );
        // when
        final Condition actual = Expression(document: document)
            .parseQuery(expression: 'a > "yes"')[0];

        //then
        expect(actual, expected);
      });
    });
  });
}
