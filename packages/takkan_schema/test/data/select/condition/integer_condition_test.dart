import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/data/select/condition/integer_condition.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/query/expression.dart';
import 'package:takkan_schema/schema/query/query.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_schema/schema/validation/validation_error_messages.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';

/// string_condition_test is probably a better model for testing
void main() {
  const ValidationErrorMessages errorMessages =
      ValidationErrorMessages(typePatterns: defaultValidationErrorMessages);
  group('IntegerCondition', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('equalTo', () {
      // given
      final Document document = Document(fields: {'a': Field<int>()});
      const expression = 'a == 5';
      const expected = IntegerCondition(
        field: 'a',
        operator: Operator.equalTo,
        operand: 5,
        forQuery: true,
      );
      // when
      final actual = ConditionBuilder(document: document)
          .parseForQuery(expression: expression);
      // then

      final c = actual[0];
      expect(c, expected);

      expect(c.cloudCode, 'equalTo("a", 5);');
    });
    test('lengthGreaterThan', () {
      // given
      final Document document = Document(fields: {'a': Field<int>()});
      const expression = 'a length> 5';

      // when then

      expect(
          () => ConditionBuilder(document: document)
              .parseForQuery(expression: expression),
          throwsUnsupportedError);
    });
    test('lengthLessThan', () {
      // given
      final Document document = Document(fields: {'a': Field<int>()});
      const expression = 'a length< 5';

      // when then

      expect(
          () => ConditionBuilder(document: document)
              .parseForQuery(expression: expression),
          throwsUnsupportedError);
    });
    test('greaterThan', () {
      // given
      final Document document = Document(fields: {'a': Field<int>()});
      const expression = 'a > 5';
      const expected = IntegerCondition(
        field: 'a',
        operator: Operator.greaterThan,
        operand: 5,
        forQuery: true,
      );
      // when
      final actual = ConditionBuilder(document: document)
          .parseForQuery(expression: expression);
      // then

      final c = actual[0];
      expect(c, expected);

      expect(c.cloudCode, 'greaterThan("a", 5);');
    });
    test('greaterThanOrEqualTo', () {
      // given
      final Document document = Document(fields: {'a': Field<int>()});
      const expression = 'a >= 5';
      const expected = IntegerCondition(
        field: 'a',
        operator: Operator.greaterThanOrEqualTo,
        operand: 5,
        forQuery: true,
      );
      // when
      final actual = ConditionBuilder(document: document)
          .parseForQuery(expression: expression);
      // then

      final c = actual[0];
      expect(c, expected);

      expect(c.cloudCode, 'greaterThanOrEqualTo("a", 5);');
    });
    test('lessThan', () {
      // given
      final Document document = Document(fields: {'a': Field<int>()});
      const expression = 'a < 5';
      const expected = IntegerCondition(
        field: 'a',
        operator: Operator.lessThan,
        operand: 5,
        forQuery: true,
      );
      // when
      final actual = ConditionBuilder(document: document)
          .parseForQuery(expression: expression);
      // then

      final c = actual[0];
      expect(c, expected);

      expect(c.cloudCode, 'lessThan("a", 5);');
    });
    test('lessThanOrEqualTo', () {
      // given
      final Document document = Document(fields: {'a': Field<int>()});
      const expression = 'a <= 5';
      const expected = IntegerCondition(
        field: 'a',
        operator: Operator.lessThanOrEqualTo,
        operand: 5,
        forQuery: true,
      );
      // when
      final actual = ConditionBuilder(document: document)
          .parseForQuery(expression: expression);
      // then

      final c = actual[0];
      expect(c, expected);

      expect(c.cloudCode, 'lessThanOrEqualTo("a", 5);');
    });

    test('notEqualTo', () {
      // given
      final Document document = Document(fields: {'a': Field<int>()});
      const expression = 'a != 5';
      const expected = IntegerCondition(
        field: 'a',
        operator: Operator.notEqualTo,
        operand: 5,
        forQuery: true,
      );
      // when
      final actual = ConditionBuilder(document: document)
          .parseForQuery(expression: expression);
      // then

      final c = actual[0];
      expect(c, expected);

      expect(c.cloudCode, 'notEqualTo("a", 5);');
    });
  });

  test('validation', () {
    // given

    final Document document = Document(fields: {
      'a': Field<int>(constraints: [V.int.equalTo(5)]),
      'b': Field<int>(validation: '== 5'),
      'c': Field<int>(
        constraints: [
          V.int.greaterThan(1),
          V.int.lessThan(8),
          V.int.notEqualTo(3),
        ],
      ),
      'c1': Field<int>(
        validation: '> 1 && < 8 && != 3',
      ),
      'd': Field<int>(constraints: [
        V.int.lessThanOrEqualTo(5),
        V.int.greaterThanOrEqualTo(3),
      ]),
    }, queries: {
      'a is 5': Query(constraints: [
        Q('a').int.equalTo(5),
      ]),
    });
    // when
    final Schema schema = Schema(
        version: const Version(versionIndex: 0), documents: {'test': document});
    schema.init(schemaName: 'test');
    // then

    expect(document.field('a').doValidation(5, errorMessages), []);
    expect(document.field('a').doValidation(6, errorMessages),
        ['must be equal to 5']);
    expect(document.field('b').doValidation(5, errorMessages), []);
    expect(document.field('b').doValidation(6, errorMessages),
        ['must be equal to 5']);
    expect(document.field('c').conditions.length, 3);
    expect(document.field('c').doValidation(1, errorMessages),
        ['must be greater than 1']);
    expect(document.field('c').doValidation(8, errorMessages),
        ['must be less than 8']);
    expect(document.field('c').doValidation(3, errorMessages),
        ['must not be equal to 3']);
    expect(document.field('c').doValidation(5, errorMessages), []);
    expect(document.field('c1').conditions.length, 3);
    expect(document.field('c1').doValidation(1, errorMessages),
        ['must be greater than 1']);
    expect(document.field('c1').doValidation(8, errorMessages),
        ['must be less than 8']);
    expect(document.field('c1').doValidation(3, errorMessages),
        ['must not be equal to 3']);
    expect(document.field('c1').doValidation(5, errorMessages), []);
    expect(document.field('d').doValidation(3, errorMessages), []);
    expect(document.field('d').doValidation(5, errorMessages), []);
    expect(document.field('d').doValidation(2, errorMessages),
        ['must be greater than or equal to 3']);
    expect(document.field('d').doValidation(6, errorMessages),
        ['must be less than or equal to 5']);

    expect(document.query('a is 5').conditions[0].cloudCode,
        'equalTo("a", 5);');
  });

  test('invalidExpression', () {
    // given
    final Document document = Document(fields: {'a': Field<int>()});
    const expression = 'a = 5'; // Invalid expression

    // when then
    expect(
      () => ConditionBuilder(document: document)
          .parseForQuery(expression: expression),
      throwsTakkanException,
    );
  });
  test('greaterThanOrEqualTo', () {
    // given
    final Document document = Document(fields: {'a': Field<int>()});
    const expression = 'a >= 5';
    const expected = IntegerCondition(
      field: 'a',
      operator: Operator.greaterThanOrEqualTo,
      operand: 5,
      forQuery: true,
    );
    // when
    final actual = ConditionBuilder(document: document)
        .parseForQuery(expression: expression);
    // then

    final c = actual[0];
    expect(c, expected);

    expect(c.cloudCode, 'greaterThanOrEqualTo("a", 5);');
  });
  test('greaterThan', () {
    // given
    final Document document = Document(fields: {'a': Field<int>()});
    const expression = 'a > 5';
    const expected = IntegerCondition(
      field: 'a',
      operator: Operator.greaterThan,
      operand: 5,
      forQuery: true,
    );
    // when
    final actual = ConditionBuilder(document: document)
        .parseForQuery(expression: expression);
    // then

    final c = actual[0];
    expect(c, expected);

    expect(c.cloudCode, 'greaterThan("a", 5);');
  });
}
