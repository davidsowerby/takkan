import 'dart:convert';

import 'package:precept_client/precept/script/document.dart';
import 'package:test/test.dart';

void main() {
  group('PDocumentSelectorConverter', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('round trip, PDocumentGet', () {
      // given
      PDocumentSelectorConverter converter = PDocumentSelectorConverter();
      PDocumentGet g = PDocumentGet(
        id: DocumentId(
          path: "user/prefs",
          itemId: "23",
        ),
      );
      // when
      final Map<String, dynamic> j = converter.toJson(g);
      final mirror =converter.fromJson(j);
      // then

      expect(json.encode(g), json.encode(mirror));
    });
  });
}
