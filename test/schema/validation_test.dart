import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/schema/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

void main() {
  group('StringValidator', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('isAlpha', () {
      // given
      final PField field=PString();
      final FieldValidator validator = FieldValidator(field: field);

      // when

      // then

      expect(validator.validate('a'), '');
      expect(validator.validate('-'), validationFailPattern(Validation.isAlpha));
    });
  });
}
