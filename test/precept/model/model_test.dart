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
      final Map <String,dynamic> pc3m = Map.castFrom(json.decode(json.encode(pc2)));
      final PreceptModel pc3=PreceptModel.fromJson(pc3m);
      print(pc3);
      expect(json.encode(model), json.encode(pc2));
      expect(json.encode(pc2),json.encode(pc3));
    });
  });
}
