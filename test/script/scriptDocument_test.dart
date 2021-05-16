import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/queryConverter.dart';

void main() {
  group('PDocumentSelectorConverter', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('round trip, PDocumentGet', () {
      // given
      PGet g = PGet(
        documentId: DocumentId(
          path: "user/prefs",
          itemId: "23",
        ),
      );
      // when
      final Map<String, dynamic> j = PQueryConverter.toJson(g);
      final mirror =PQueryConverter.fromJson(j);
      // then

      expect(json.encode(g), json.encode(mirror));
    });
  });
}
