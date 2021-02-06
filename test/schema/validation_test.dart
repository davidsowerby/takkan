import 'package:flutter_test/flutter_test.dart';
import 'package:validators/validators.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final result = isInt('23');

      // when

      // then

      expect(isFloat('23.0'),true);
    });
  });
}
