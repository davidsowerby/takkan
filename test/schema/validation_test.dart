import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/schema/validation/validator.dart';

void main() {
  group('StringValidator', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('isAlpha', () {
      // given
      final StringValidator validator = StringValidator(validations: [Validation.isAlpha]);

      // when

      // then

      expect(validator.validate('a'), '');
      expect(validator.validate('-'), validationPattern(Validation.isAlpha));
    });
  });
}
