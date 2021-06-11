import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/common/interpolate.dart';

import '../helper/catcher.dart';

void main() {
  group(
    'interpolate',
    () {
      setUpAll(() {});

      tearDownAll(() {});

      setUp(() {});

      tearDown(() {});

      test(
        'nothing to expand',
        () {
          // given
          final String value = 'There is nothing to see here';
          // when
          final actual = interpolate(value, {});
          // then

          expect(actual, value);
        },
      );

      test(
        'single simple variable',
        () {
          // given
          final String value = 'There is @something to see here';
          // final String value = r'''There is $something to see here''';

          // when
          final actual = interpolate(value, {'something': 'a duck'});
          // then

          expect(actual, 'There is a duck to see here');
        },
      );

      test(
        'single simple variable with comma',
        () {
          // given
          final String value = 'There is @something, to see here';
          // final String value = r'''There is $something to see here''';
          // String s='a';
          // final q=s.codeUnits;
          // final q2=s.runes;

          // when
          final actual = interpolate(value, {'something': 'a duck'});
          // then

          expect(actual, 'There is a duck, to see here');
        },
      );

      test(
        'escaped @',
        () {
          final String value = 'There is \\@something to see here';
          // final String value = r'''There is $something to see here''';

          // when
          final actual = interpolate(value, {'something': 'a duck'});
          // then

          expect(actual, 'There is @something to see here');
        },
      );

      test(
        'single extended variable',
        () {
          // given
          final String value = 'There is @{always.something} to see here';

          // when
          final actual = interpolate(value, {
            'always': {'something': 'a bat'}
          });
          // then

          expect(actual, 'There is a bat to see here');
        },
      );

      test(
        'unnecessary braces',
        () {
          // given
          final String value = 'There is @{something} to see here';
          // final String value = r'''There is $something to see here''';

          // when
          final actual = interpolate(value, {'something': 'a duck'});
          // then

          expect(actual, 'There is a duck to see here');
        },
      );

      test('incomplete braces', () {
        // given
        final String value = 'There is @{something to see here';

        // when
        // then

        expect(() => interpolate(value, {'something': 'a duck'}), throwsPreceptException);
      });

      test('all sorts', () {
        // given
        final String value =
            'This can be \\@ignored, while we need to process @this and @{other.also}';
        // when
        final actual = interpolate(
          value,
          {
            'this': 'this',
            'other': {'also': 'also'}
          },
        );
        // then

        expect(actual, 'This can be @ignored, while we need to process this and also');
      });
    },
  );
}
