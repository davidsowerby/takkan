import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_script/data/converter/converter.dart';

void main() {
  group('PassThrough', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('input validation', () {
      // given
      final converter = PassThroughConverter<String>();
      // when

      // then

      expect(converter.viewModelValidate('any'), true);
    });
  });
  group('IntString', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('input validation', () {
      // given
      final converter = IntStringConverter();
      // when

      // then
      expect(converter.viewModelValidate('1'), true);
      expect(converter.viewModelValidate('12'), true);
      expect(converter.viewModelValidate(''), false);
      expect(converter.viewModelValidate('12.0'), false);
      expect(converter.viewModelValidate('x'), false);
    });
  });
}
