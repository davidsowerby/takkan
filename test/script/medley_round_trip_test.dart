import 'dart:convert';

import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/example/medley_script.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/script.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

void main() {
  group('PScript JSON Round trip', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(
          () => FakePreceptSchemaLoader());
    });

    tearDown(() {});
    test('script to JSON map and back', () async {
      // given
      PScript script = medleyScript[0];

      // when
      script.init();
      // then
      Map<String, dynamic> jsonMap = script.toJson();
      PScript script2 = PScript.fromJson(jsonMap);

      expect(jsonMap['nameLocale'], 'Medley:en_GB');
      expect(script2.routes.length, script.routes.length);
      script2.init();

      expect(script.toJson(), script2.toJson());
      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });
  });
}
