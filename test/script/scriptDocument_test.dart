import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/queryConverter.dart';

import '../fixtures.dart';

void main() {
  group('PDocumentSelectorConverter', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(() => FakePreceptSchemaLoader());
    });

    tearDown(() {});

    test('round trip, PDocumentGet', () {
      // given
      PGetDocument g = PGetDocument(
        documentId: DocumentId(
          path: "user/prefs",
          itemId: "23",
        ),
        documentSchema: 'Document',
      );
      // when
      final Map<String, dynamic> j = PQueryConverter().toJson(g);
      final mirror = PQueryConverter().fromJson(j);
      // then

      expect(json.encode(g), json.encode(mirror));
    });
  });
}
