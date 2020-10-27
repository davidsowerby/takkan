import 'dart:convert';

import 'package:precept/pc/pc.dart';
import 'package:test/test.dart';

void main() {
  group('PPart experiment', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final pc = PComponent(
        parts: {
          "a": PStringPart(
            caption: "Wiggly part",
          ),
          "B": PStringPart(caption: "part 2"),
        },
        routes: [
          PRoute(
            path: "user/home",
            page: PPage(
              title: "Big Page",
              sections: [
                PSection(wiggly: Wiggly.big),
              ],
            ),
          )
        ],
      );
      // when

      // then
      Map<String, dynamic> pco = pc.toJson();
      PComponent pc2 = PComponent.fromJson(pco);
      final String pcj = json.encode(pc);
      final String pc2j = json.encode(pc2);
      expect(pcj, pc2j);
    });
  });
}
