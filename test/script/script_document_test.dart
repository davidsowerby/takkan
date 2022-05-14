import 'dart:convert';

import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/data/select/query.dart';
import 'package:precept_script/data/select/query_converter.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:test/test.dart';

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
      GetDocument g = GetDocument(
        documentId: DocumentId(
          documentClass: "user/prefs",
          objectId: "23",
        ),
        documentSchema: 'Document',
      );
      // when
      final Map<String, dynamic> j = QueryConverter().toJson(g);
      final mirror = QueryConverter().fromJson(j);
      // then

      expect(json.encode(g), json.encode(mirror));
    });
  });
}
