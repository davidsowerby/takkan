import 'package:precept_client/precept/part/pPart.dart';
import 'package:test/test.dart';

void main() {
  group('PPart', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('build', () {
      // given
final part=PPart();
      // when
final b=part.build();
      // then

      expect(b, 0);
    });
  });
}