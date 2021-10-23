import 'dart:convert';

import 'package:precept_script/data/converter/conversionErrorMessages.dart';
import 'package:test/test.dart';

void main() {
  group('ConversionPattern', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('round trip', () {
      // given
      final patterns = ConversionErrorMessages(patterns: defaultConversionPatterns);
      // when
      // then
      final patternsJson = patterns.toJson();
      final mirror = ConversionErrorMessages.fromJson(patternsJson);
      expect(json.encode(patternsJson), json.encode(mirror));
    });
  });
}
