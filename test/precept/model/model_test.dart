import 'dart:convert';

import 'package:precept_client/app/data/kitchenSink.dart';
import 'package:precept_client/precept/model/model.dart';
import 'package:precept_client/precept/model/modelDocument.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:test/test.dart';

void main() {
  group('Round trip Precept model to JSON', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('full model', () {
      // given
      PModel model = kitchenSinkModel;

      // when

      // then
      Map<String, dynamic> jsonMap = model.toJson();
      PModel model2 = PModel.fromJson(jsonMap);

      expect(model2.components.length, 1);
      final c0 = model2.components[0];
      expect(c0.name, "core");
      expect(c0.routes.length, 1);
      final r0 = c0.routes[0];
      expect(r0.path, "/");
      final p = r0.page;
      expect(p.title, "Home Page");
      expect(p.document.sections.length, 1);

      expect(json.encode(model.toJson()), json.encode(model2.toJson()));
    });

    test('PDocument round trip', () {
      // given
      final m = PDocument(
          documentSelector: PDocumentGet(
            id: DocumentId(path: "any", itemId: "any"),
            params: {},
          ),
          sections: [
            PSection(elements: [
              PString(
                caption: "Title",
              )
            ]),
          ]);
      // when
      final asJsonMap = m.toJson();
      final m2 = PDocument.fromJson(asJsonMap);
      // then

      expect(json.encode(m.toJson()), jsonEncode(m2.toJson()));
      expect(m2.sections[0].elements[0].caption, "Title");
      expect(m2.sections[0].elements[0], isA<PString>());
    });
  });
}
