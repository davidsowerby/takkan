import 'dart:convert';

import 'package:precept/pc/pc.dart';
import 'package:test/test.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final pc = PComponent(
        parts: {"a": PPart(title: "Wiggly part")},
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
