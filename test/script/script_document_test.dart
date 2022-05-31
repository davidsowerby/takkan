import 'dart:convert';

import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/data/select/query_converter.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

void main() {
  group('DocumentSelectorConverter', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<TakkanSchemaLoader>(() => FakeTakkanSchemaLoader());
    });

    tearDown(() {});

    test('round trip, DocumentGet', () {
      // given
      final GetDocument g = GetDocument(
        documentId: const DocumentId(
          documentClass: 'user/prefs',
          objectId: '23',
        ),
      );
      // when
      final Map<String, dynamic> j = const QueryConverter().toJson(g);
      final mirror = const QueryConverter().fromJson(j);
      // then

      expect(json.encode(g), json.encode(mirror));
    });
  });
}
