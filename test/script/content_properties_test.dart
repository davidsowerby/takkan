import 'package:takkan_medley_script/script/medley_script.dart';
import 'package:test/test.dart';

void main() {
  group('Content properties', () {
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
          medleyScript0
              .pageFromStringRoute('person/static')
              ?.contentAsMap['age']
              ?.caption,
          'age');
    });
  });
}
