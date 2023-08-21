import 'package:takkan_schema/common/constants.dart';
import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('Field', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    group('apply diff', () {
      test('remove default value', () {
        // given
        final field = Field<String>(defaultValue: 'x');
        final diff = FieldDiff<String>(removeDefaultValue: true);
        // when
        final result = diff.applyTo(field);
        // then
        expect(result.defaultValue, isNull);
      });
      test('replace default value', () {
        // given
        final field = Field<String>(defaultValue: 'x');
        final diff = FieldDiff<String>(defaultValue: 'y');
        // when
        final result = diff.applyTo(field);
        // then
        expect(result.defaultValue, 'y');
      });
      test('No change diff', () {
        // given
        final field = Field<String>(
          defaultValue: 'x',
          validation: 'x isLongerThan 5',
          constraints: [V.string.lengthGreaterThan(5)],
          required: true,
          isReadOnly: IsReadOnly.yes,
          index: Index.ascending,
        );
        final diff = FieldDiff<String>();
        // when
        final result = diff.applyTo(field);
        // then
        expect(result, field);
      });
      test('Diff changes all', () {
        // given
        final field = Field<String>(
          defaultValue: 'x',
          validation: 'isLongerThan 5',
          constraints: [V.string.lengthGreaterThan(5)],
          required: true,
          isReadOnly: IsReadOnly.yes,
          index: Index.ascending,
        );
        final diff = FieldDiff<String>(
          defaultValue: 'y',
          validation: 'isLongerThan 3',
          constraints: [
            V.string.lengthGreaterThan(3),
            V.string.lengthLessThan(5)
          ],
          required: false,
          isReadOnly: IsReadOnly.inherited,
          index: Index.descending,
        );
        // when
        final result = diff.applyTo(field);
        // then
        expect(result.defaultValue, 'y');
        expect(result.validation, 'isLongerThan 3');
        expect(result.constraints, [
          V.string.lengthGreaterThan(3),
          V.string.lengthLessThan(5),
        ]);
        expect(result.required, false);
        expect(result.isReadOnly, IsReadOnly.inherited);
        expect(result.index, Index.descending);
      });
      test('hasValidation', () {
        // given
        final schema = Schema(
            version: const Version(versionIndex: 1),
            documents: {
              'Person': Document(
                  fields: {
                    'firstName': Field<String>(),
                    'familyName': Field<String>(validation: 'length> 5'),
                    'age': Field<int>(constraints: [V.int.greaterThan(0)]),
                    'height': Field<int>(required: true),
                  }
              )
            }
        );
        // when
        schema.init(schemaName: 'test');
        final firstNameField=schema.documents['Person']!.fields['firstName']!;
        final lastNameField=schema.documents['Person']!.fields['familyName']!;
        final ageField=schema.documents['Person']!.fields['age']!;
        final heightField=schema.documents['Person']!.fields['height']!;
        // then
        expect(firstNameField.hasValidation, false);
        expect(lastNameField.hasValidation, true);
        expect(ageField.hasValidation, true);
        expect(heightField.hasValidation, true);

      });
    });
  });
}
