import 'dart:convert';

import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/data/select/query.dart';
import 'package:precept_script/data/select/query_converter.dart';
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
      PGetDocument g = PGetDocument(
        documentId: DocumentId(
          documentClass: "user/prefs",
          objectId: "23",
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
