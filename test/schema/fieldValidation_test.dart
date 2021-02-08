import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/schema/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final PString field = PString(validations: [Validation.isAlpha]);
      // when

      // then

      expect(1, 0);
    });
  });
}
