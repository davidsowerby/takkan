import 'package:takkan_script/util/interpolate.dart';
import 'package:test/test.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      const String p1 = 'a message with no params';
      const String p2 = 'a message with {number} params';
      const String p3 =
          'a message with {number} params, using {a} and {reallyLongOne}';
      const String p4 =
          'a message with {number} params, using {a} and {reallyLongOne} and {a} again';
      // when

      // then

      expect(expandErrorMessage(p1, {'number': 5}), p1);
      expect(expandErrorMessage(p2, {'number': 5}), 'a message with 5 params');
      expect(expandErrorMessage(p2, {'number': 5, 'spare': 'spare'}),
          'a message with 5 params');
      expect(
        expandErrorMessage(p3, {
          'number': 5,
          'spare': 'spare',
          'a': 'a short one',
          'reallyLongOne': 'a really long one'
        }),
        'a message with 5 params, using a short one and a really long one',
      );
      expect(expandErrorMessage(p2, {'number': 5, 'spare': 'spare'}),
          'a message with 5 params');
      expect(
        expandErrorMessage(p3, {
          'number': 5,
          'spare': 'spare',
          'reallyLongOne': 'a really long one'
        }),
        'a message with 5 params, using {a} and a really long one',
      );
      expect(
        expandErrorMessage(p4, {
          'number': 5,
          'spare': 'spare',
          'a': 'a short one',
          'reallyLongOne': 'a really long one'
        }),
        'a message with 5 params, using a short one and a really long one and a short one again',
      );
    });
  });
}
