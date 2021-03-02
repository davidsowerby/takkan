import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/json/queryConverter.dart';
import 'package:precept_script/script/query.dart';

void main() {
  group('PDocumentSelectorConverter', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('round trip, PDocumentGet', () {
      // given
      PGet g = PGet(// ignore: missing_required_param
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
