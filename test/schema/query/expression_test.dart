// ignore_for_file: strict_raw_type

import 'package:takkan_script/data/select/condition/condition.dart';
import 'package:takkan_script/data/select/condition/integer_condition.dart';
import 'package:takkan_script/data/select/condition/string_condition.dart';
import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/field/string.dart';
import 'package:takkan_script/schema/query/expression.dart';
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

    test('whitespace', () {
      // given
      final Document document = Document(fields: {'a': FInteger()});

      const expression1 = 'a == 5';
      const expression2 = 'a== 5';
      const expression3 = 'a==5';
      const expression4 = 'a   ==         5';
      // when
      final actual1 = QueryExpression(document: document)
          .parseQuery(expression: expression1);
      final actual2 = QueryExpression(document: document)
          .parseQuery(expression: expression2);
      final actual3 = QueryExpression(document: document)
          .parseQuery(expression: expression3);
      final actual4 = QueryExpression(document: document)
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
      final actual = QueryExpression(document: document)
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
      final actual = QueryExpression(document: document)
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
      final actual = QueryExpression(document: document)
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
      final script = Script(
        name: 'test',
        version: const Version(number: 0),
        schema: Schema(
          name: 'testSchema',
          version: const Version(number: 0),
          documents: {
            'testDoc': Document(fields: {'a': FString()})
          },
        ),
      );
      script.init();
      final document = script.schema.document('testDoc');
      const validation = '!="x" && !="y"';
      // when
      final actual = ValidationExpression(document: document)
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
      final script = Script(
        name: 'test',
        version: const Version(number: 0),
        schema: Schema(
          name: 'testSchema',
          version: const Version(number: 0),
          documents: {
            'testDoc': Document(fields: {'a': FString()})
          },
        ),
      );

      test('equalTo', () {
        // given
        script.init();
        final document = script.schema.document('testDoc');
        const StringCondition expected = StringCondition(
          field: 'a',
          operator: Operator.equalTo,
          reference: 'yes',
        );
        // when
        final Condition actual = QueryExpression(document: document)
            .parseQuery(expression: 'a == "yes"')[0];

        //then
        expect(actual, expected);
      });
      test('notEqualTo', () {
        // given
        script.init();
        final document = script.schema.document('testDoc');
        const StringCondition expected = StringCondition(
          field: 'a',
          operator: Operator.notEqualTo,
          reference: 'yes',
        );
        // when
        final Condition actual = QueryExpression(document: document)
            .parseQuery(expression: 'a != "yes"')[0];

        //then
        expect(actual, expected);
      });
      test('longerThan', () {
        // given
        script.init();
        final document = script.schema.document('testDoc');
        const StringCondition expected = StringCondition(
          field: 'a',
          operator: Operator.greaterThan,
          reference: 'yes',
        );
        // when
        final Condition actual = QueryExpression(document: document)
            .parseQuery(expression: 'a > "yes"')[0];

        //then
        expect(actual, expected);
      });
    });
  });
}
