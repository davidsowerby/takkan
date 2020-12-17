import 'dart:convert';

import 'package:precept_script/script/json/dataSourceConverter.dart';
import 'package:precept_script/script/query.dart';
import 'package:test/test.dart';

void main() {
  group('PDocumentSelectorConverter', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('round trip, PDocumentGet', () {
      // given
      PDataSourceConverter converter = PDataSourceConverter();
      PDataGet g = PDataGet(// ignore: missing_required_param
        documentId: DocumentId(
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
