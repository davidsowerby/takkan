import 'dart:convert';

import 'package:precept/app/data/kitchenSink.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/part/string/stringPart.dart';
import 'package:test/test.dart';

import '../../data/testModel/testModel.dart';

void main() {
  group('Round trip Precept model to JSON', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('full model', () {
      // given
      PreceptModel model = kitchenSinkModel;

      // when

      // then
      Map<String, dynamic> jsonMap = model.toJson();
      PreceptModel model2 = PreceptModel.fromJson(jsonMap);
      expect(json.encode(model.toJson()), json.encode(model2.toJson()));
    });

    test('PDocumentSection round trip', () {
      // given
      final m = PDocumentSection(                  documentSelector: PDocumentGet(
        id: DocumentId(path: "any", itemId: "any"),
        params: {},
      ),
          parts: [
            PStringPart(
              property: "title",
              caption: "Title",
            ),
          ]);
      // when
      final asJsonMap = m.toJson();
      final m2=PDocumentSection.fromJson(asJsonMap);
      // then

      expect(json.encode(m.toJson()), jsonEncode(m2.toJson()));
      expect(m2.parts[0].property,"title");
      expect(m2.parts[0].caption,"Title");
      expect(m2.parts[0],isA<PStringPart>());

    });
  });
}
