import 'dart:convert';
import 'dart:io';

import 'package:takkan_medley_script/script/medley_script.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/script/script.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

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
      final Script script = medleyScript2;

      // when
      script.init();
      // then
      final Map<String, dynamic> jsonMap = script.toJson();
      final Script script2 = Script.fromJson(jsonMap);
      final tracker = script2.init().initWalker.tracker;

      expect(jsonMap['nameLocale'], 'Medley:en_GB');
      expect(script2.routes.length, script.routes.length);

      expect(nullsInTracker(tracker), 0);
      final c0 = script2.routes[TakkanRoute.fromString('home/static')];
      expect(
          c0?.routeMap.keys, contains(TakkanRoute.fromString('home/static')));

      expect(c0?.title, 'Home');
      expect(c0?.children.length, 1);

      final File original = File('/home/david/temp/original.json');
      final File returned = File('/home/david/temp/returned.json');
      await script.writeToFile(original);
      await script.writeToFile(returned);

      expect(script.toJson(), script2.toJson());
    });

    test('script to file and back', () async {
      // given
      final Directory tempDir = Directory.systemTemp;
      final File f = File('${tempDir.path}/scriptOut.json');
      final Script script = medleyScript2;

      // when
      script.init();
      await script.writeToFile(f);
      final script2 = await Script.readFromFile(f);
      script2.init();
      // then

      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });
  });
}

int nullsInTracker(List<String> tracker) {
  int count = 0;
  for (final String item in tracker) {
    if (item.contains('null')) {
      count++;
    }
  }
  return count;
}
