import 'package:flutter_test/flutter_test.dart';
import 'package:validators/validators.dart';

void main() {
  group('String manipulation', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      String a = 'z';
      // when
      List<int> b = a.codeUnits;
      Runes r = a.runes;
      // then
      isAlphanumeric("k");

      expect(1, 0);
    });
  });
}
