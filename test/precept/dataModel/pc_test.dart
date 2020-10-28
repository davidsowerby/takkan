import 'dart:convert';

import 'package:precept/precept/model/model.dart';
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
      PreceptModel model = testModel;

      // when

      // then
      Map<String, dynamic> pco = model.toJson();
      PreceptModel pc2 = PreceptModel.fromJson(pco);
      final String pcj = json.encode(model);
      final String pc2j = json.encode(pc2);
      expect(pcj, pc2j);
    });
  });
}
