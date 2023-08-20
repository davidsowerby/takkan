import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/common/interpolate.dart';

void main() {
  group(
    'interpolate',
    () {
      setUpAll(() {});

      tearDownAll(() {});

      setUp(() {});

      tearDown(() {});

      test('extract params from pattern', () {
        // given
        final values = <String, dynamic>{'total': 5, 'name': 'Wiggly'};
        final String pattern =
            'This pattern has {total} params, and is called {name}';
        // when

        // then

        expect(TestInterpolator().interp(pattern, (key) => values[key]!),
            'This pattern has 5 params, and is called Wiggly');
      });

      test('nothing to expand', () {
        // given
        final values = <String, dynamic>{};
        final String pattern = 'There is nothing to see here';
        // when
        final actual =
            TestInterpolator().interp(pattern, (key) => values[key]!);
        // then

        expect(actual, pattern);
      });

      test(
        'single simple variable',
        () {
          // given
          final values = <String, dynamic>{'something': 'a duck'};
          final String pattern = 'There is {something} to see here';

          // when
          final actual =
              TestInterpolator().interp(pattern, (key) => values[key]!);
          // then

          expect(actual, 'There is a duck to see here');
        },
      );

      test(
        'single simple variable with comma',
        () {
          // given
          final values = <String, dynamic>{'something': 'a duck'};
          final String pattern = 'There is {something}, to see here';

          // when
          final actual =
              TestInterpolator().interp(pattern, (key) => values[key]!);
          // then

          expect(actual, 'There is a duck, to see here');
        },
      );

      test(
        'single extended variable',
        () {
          // given
          final values = <String, dynamic>{'user.something': 'bat'};
          final String pattern = 'There is a {user.something} to see here';

          // when
          final actual =
              TestInterpolator().interp(pattern, (key) => values[key]);
          // then

          expect(actual, 'There is a bat to see here');
        },
      );

      test('concatenated variables', () {
        // given
        final values = <String, dynamic>{
          'something': 'bat',
          'source': ' out of hell'
        };
        final String pattern = 'Do you like the song {something}{source}';
        // when
        final actual = TestInterpolator().interp(pattern, (key) => values[key]);
        // then

        expect(actual, 'Do you like the song bat out of hell');
      });
    },
  );
}

class TestInterpolator with Interpolator {
  interp(String pattern, dynamic Function(String) getValue) {
    return doInterpolate(pattern, getValue);
  }
}
