import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/script/script.dart';

void main() {
  group('StringValidator', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('length', () {
      // given
      PScript script=PScript(name: 'A script');
      // script.init();

      final PString field = PString(
        validations: [
          StringValidation(method: ValidateString.lengthGreaterThan, param: 3),
          StringValidation(method: ValidateString.lengthLessThan, param: 6),
        ],
      );

      // when

      // then

      expect(field.validate('ab',script), ['must be more than 3 characters']);
      expect(field.validate('abcdedfg',script), ['must be less than 6 characters']);
      expect(field.validate('abcd',script), []);

    });
  });
}
