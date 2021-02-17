import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/validation/validationErrorMessages.dart';
import 'package:precept_script/script/script.dart';

void main() {
  group('ValidationErrorMessages', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('find', () {
      // given
      final messages = ValidationErrorMessages(defaultValidationErrorMessages);

      // when

      // then
      final actual = messages.find(
          IntegerValidation(method: ValidateInteger.isGreaterThan, param: 3));
      expect(actual,'must be greater than {0}');
    });
  });
}
