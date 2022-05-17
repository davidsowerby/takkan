import 'package:takkan_medley_script/medley/medley_script.dart';
import 'package:test/test.dart';

void main() {
  group('PContent properties', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('When no caption specified, use property', () {
      // given

      // when
      medleyScript0.init();
      // then

      expect(
          medleyScript0.routes['person']?.contentAsMap['age']?.caption, 'age');
    });
  });
}
