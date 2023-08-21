import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_schema/schema/validation/validation_error_messages.dart';
import 'package:test/test.dart';

const ValidationErrorMessages errorMessages =
    ValidationErrorMessages(typePatterns: defaultValidationErrorMessages);

void main() {
  group('StringCondition', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});
    test('Conditions', () {
      // given
      final Document document = Document(fields: {
        'a': Field<String>(constraints: [V.string.equalTo('x')]),
        'b': Field<String>(constraints: [
          V.string.lessThan('z'),
          V.string.greaterThan('c'),
          V.string.notEqualTo('dd'),
        ]),
        'c': Field<String>(constraints: [V.string.lengthLessThan(3)]),
        'd': Field<String>(constraints: [V.string.lengthGreaterThan(3)]),
        'e': Field<String>(constraints: [V.string.lengthLessThanOrEqualTo(3)]),
        'f': Field<String>(
            constraints: [V.string.lengthGreaterThanOrEqualTo(3)]),
        'g': Field<String>(constraints: [
          V.string.lessThanOrEqualTo('z'),
          V.string.greaterThanOrEqualTo('c'),
        ]),
      });
      final Schema schema =
          Schema(version: const Version(versionIndex: 0), documents: {
        'test': document,
      });
      // when
      schema.init(schemaName: 'test');
      // then
      expecting(document);
    });
    test('Expression', () {
      // given
      final Document document = Document(fields: {
        'a': Field<String>(validation: "== 'x'"),
        'b': Field<String>(validation: "< 'z' && > 'c' && != 'dd'"),
        'c': Field<String>(validation: 'length< 3'),
        'd': Field<String>(validation: 'length> 3'),
        'e': Field<String>(validation: 'length<= 3'),
        'f': Field<String>(validation: 'length>= 3'),
        'g': Field<String>(validation: "<= 'z'  && >= 'c'"),
      });
      final Schema schema =
          Schema(version: const Version(versionIndex: 0), documents: {
        'test': document,
      });
      // when
      schema.init(schemaName: 'test');
      // then

      expecting(document);
    });
  });
}

void expecting(Document document) {
  expect(
    document.field('a').doValidation('y', errorMessages),
    ["must be equal to 'x'"],
  );
  expect(
    document.field('b').doValidation('b', errorMessages),
    ["must be greater than 'c'"],
  );
  expect(
    document.field('b').doValidation('za', errorMessages),
    ["must be less than 'z'"],
  );
  expect(
    document.field('b').doValidation('dd', errorMessages),
    ["must not be equal to 'dd'"],
  );
  expect(
    document.field('c').doValidation('ddd', errorMessages),
    ['must have length of less than 3'],
  );
  expect(
    document.field('d').doValidation('d', errorMessages),
    ['must have length of greater than 3'],
  );
  expect(
    document.field('e').doValidation('dddd', errorMessages),
    ['must have length of less than or equal to 3'],
  );
  expect(
    document.field('f').doValidation('d', errorMessages),
    ['must have length of greater than or equal to 3'],
  );
  expect(
    document.field('g').doValidation('z', errorMessages),
    [],
  );
  expect(
    document.field('g').doValidation('za', errorMessages),
    ["must be less than or equal to 'z'"],
  );
  expect(
    document.field('g').doValidation('c', errorMessages),
    [],
  );
  expect(
    document.field('g').doValidation('bz', errorMessages),
    ["must be greater than or equal to 'c'"],
  );
}
