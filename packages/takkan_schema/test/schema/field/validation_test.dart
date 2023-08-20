import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_schema/schema/validation/validation_error_messages.dart';
import 'package:test/test.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('field validations', () {
      // given
      final schema = medleySchema1;
      schema.init();
      final doc = schema.document('Person');
      const errorMessages =
          ValidationErrorMessages(typePatterns: defaultValidationErrorMessages);
      // when

      // then

      expect(doc.field('age').doValidation(10, errorMessages), []);
      expect(doc.field('age').doValidation(-1, errorMessages),
          ['must be greater than 0']);
      expect(doc.field('age').doValidation(128, errorMessages),
          ['must be less than 128']);
    });
    test('hasValidation', () {
      // given

      final Schema schema = medleySchema1;
      final Document doc = schema.document('Person');
      // when

      // then

      expect(doc.field('firstName').hasValidation, isTrue,
          reason: 'required is true');
      expect(doc.field('lastName').hasValidation, isFalse,
          reason: 'not required and no conditions');
      expect(doc.field('age').hasValidation, isTrue);
      expect(doc.field('height').hasValidation, isTrue);
    });
  });
}
