import 'dart:convert';

import 'package:takkan_medley_script/script/medley_script.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/script/script.dart';
import 'package:test/test.dart';

import '../../../takkan_schema/test/fixtures.dart';

void main() {
  group('PScript JSON Round trip', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<TakkanSchemaLoader>(() => FakeTakkanSchemaLoader());
    });

    tearDown(() {});
    test('script to JSON map and back', () async {
      // given
      final Script script = medleyScript[0];

      // when
      script.init();
      // then
      final Map<String, dynamic> jsonMap = script.toJson();
      final Script script2 = Script.fromJson(jsonMap);
      script2.init();

      expect(jsonMap['nameLocale'], 'Medley:en_GB');
      expect(script2.routes.length, script.routes.length);

      expect(script.toJson(), script2.toJson());
      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });
  });
}
