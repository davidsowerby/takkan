import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/data/converter/conversionErrorMessages.dart';

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
