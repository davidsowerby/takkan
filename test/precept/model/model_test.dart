import 'dart:convert';

import 'package:precept/app/data/kitchenSink.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/part/string/stringPart.dart';
import 'package:test/test.dart';

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

      expect(model2.components.length,1);
      final c0=model2.components[0];
      expect(c0.name,"core");
      expect(c0.routes.length,1);
      final r0 = c0.routes[0];
      expect(r0.path,"/");
      final p=r0.page;
      expect(p.title,"Home Page");
      expect(p.elements.length,1);
      

      expect(json.encode(model.toJson()), json.encode(model2.toJson()));
    });

    test('PDocumentSection round trip', () {
      // given
      final m = PDocument(
          documentSelector: PDocumentGet(
            id: DocumentId(path: "any", itemId: "any"),
            params: {},
          ),
          elements: [
            PString(
              property: "title",
              caption: "Title",
            ),
          ]);
      // when
      final asJsonMap = m.toJson();
      final m2 = PDocument.fromJson(asJsonMap);
      // then

      expect(json.encode(m.toJson()), jsonEncode(m2.toJson()));
      expect(m2.elements[0].caption, "Title");
      expect(m2.elements[0], isA<PString>());
    });
  });
}
