import 'dart:convert';

import 'package:takkan_script/data/converter/conversion_error_messages.dart';
import 'package:test/test.dart';

void main() {
  group('ConversionPattern', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('round trip', () {
      // given
      const patterns = ConversionErrorMessages(patterns: defaultConversionPatterns);
      // when
      // then
      final patternsJson = patterns.toJson();
      final mirror = ConversionErrorMessages.fromJson(patternsJson);
      expect(json.encode(patternsJson), json.encode(mirror));
    });
  });
}
