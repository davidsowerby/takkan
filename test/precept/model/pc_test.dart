import 'dart:convert';

import 'package:precept/pc/pc.dart';
import 'package:test/test.dart';

import '../../data/testModel/testModel.dart';

void main() {
  group('Round trip Precept model to JSON', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      Precept model = testModel;

      // when

      // then
      Map<String, dynamic> pco = model.toJson();
      Precept pc2 = Precept.fromJson(pco);
      final String pcj = json.encode(model);
      final String pc2j = json.encode(pc2);
      expect(pcj, pc2j);
    });
  });
}
