import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/data/select/condition/integer_condition.dart';
import 'package:takkan_schema/data/select/condition/string_condition.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/field/field.dart';
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
      final Schema schema = Schema(
        version: const Version(versionIndex: 0),
        documents: {
          'Person': Document(
            fields: {
              'firstName': Field<String>(),
              'lastName': Field<String>(),
              'age': Field<int>(),
            },
            queries: {
              'adults': Query(
                constraints: [
                  Q('age').int.equalTo(152),
                  Q('lastName').string.equalTo('Hazel'),
                ],
                queryScript: "firstName == 'Jack'",
                returnSingle: true,
              ),
            },
          ),
        },
      );
      const expectedConditionAge = IntegerCondition(
        field: 'age',
        forQuery: true,
        operator: Operator.equalTo,
        operand: 152,
      );
      const expectedConditionFirstName = StringCondition(
        field: 'firstName',
        operator: Operator.equalTo,
        operand: 'Jack',
        forQuery: true,
      );
      const expectedConditionLastName = StringCondition(
        field: 'lastName',
        operator: Operator.equalTo,
        operand: 'Hazel',
        forQuery: true,
      );

      // when
      schema.init(schemaName: 'test');
      final query = schema.document('Person').query('adults');
      // then

      expect(query.constraints.length, 2);
      expect(query.conditions.length, 3);
      expect(query.conditions, contains(expectedConditionAge));
      expect(query.conditions, contains(expectedConditionFirstName));
      expect(query.conditions, contains(expectedConditionLastName));
    });
  });
  group('QueryDiff', () {
    test('no changes', () {
      // given
      final amendAdults = QueryDiff(constraints: [
        Q('age').int.greaterThanOrEqualTo(18),
      ]);
      final doc = Document(
        fields: {
          'firstName': Field<String>(),
          'lastName': Field<String>(),
          'age': Field<int>(),
        },
        queries: {
          'adults': Query(
            constraints: [
              Q('age').int.greaterThan(18),
            ],
          ),
          'Jack': Query(
            constraints: [
              Q('firstName').string.equalTo('Jack'),
            ],
          ),
        },
      );

      final schema = Schema(
        version: const Version(versionIndex: 0),
        documents: {'Person': doc},
      );
      final teensQuery=Query(
        constraints: [
          Q('age').int.lessThan(18),
          Q('age').int.greaterThanOrEqualTo(13),
        ],
      );
      final schemaDiff = SchemaDiff(
        version: const Version(versionIndex: 1),
        amendDocuments: {
          'Person': DocumentDiff(
            addQueries: {'teens': teensQuery},
            removeQueries: ['Jack'],
            amendQueries: {'adults': amendAdults},
          ),
        },
      );
      final schemaSet = SchemaSet(
        baseVersion: schema,
        diffs: [schemaDiff],
        schemaName: 'test',
      );
      // when
      schemaSet.init();
      final actual = schemaSet.schemaVersion(1);
      final document = actual.documents['Person']!;
      // then
      expect(document.queries['Jack'],isNull);
      expect(document.queries['teens'], teensQuery);
      expect(document.queries['adults']?.conditions, [Q('age').int.greaterThanOrEqualTo(18)]);
    });
  });
}
