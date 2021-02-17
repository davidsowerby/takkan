import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/data/converter/converter.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/integer.dart';

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

      expect(converter.viewModelValidate('any'), null);
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
      expect(converter.viewModelValidate('1'), null);
      expect(converter.viewModelValidate('12'), null);
      expect(converter.viewModelValidate(''), "'' must be a whole number");
      expect(converter.viewModelValidate('12.0'), "'12.0' must be a whole number");
      expect(converter.viewModelValidate('x'), "'x' must be a whole number");
    });
    test('model validation', () {
      // given
      final converter = IntStringConverter();
      final PField field =PInteger();
      // when

      // then

      expect(1, 0);
    });

  });
}
