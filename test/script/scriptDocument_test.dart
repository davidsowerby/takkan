import 'dart:convert';

import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/json/dataSourceConverter.dart';
import 'package:test/test.dart';

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
      final Map<String, dynamic> j = PDataSourceConverter.toJson(g);
      final mirror =PDataSourceConverter.fromJson(j);
      // then

      expect(json.encode(g), json.encode(mirror));
    });
  });
}
