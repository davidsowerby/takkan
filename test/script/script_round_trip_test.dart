import 'dart:convert';
import 'dart:io';

import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/example/kitchen_sink.dart';
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
      PScript script = kitchenSinkScript;

      // when
      script.init();
      // then
      Map<String, dynamic> jsonMap = script.toJson();
      PScript script2 = PScript.fromJson(jsonMap);

      expect(jsonMap['nameLocale'], 'Kitchen Sink:en_GB');
      expect(script2.routes.length, 8);
      final tracker = script2.init().tracker;
      expect(nullsInTracker(tracker), 0);
      final c0 = script2.routes['/'];
      expect(c0?.route, '/');

      expect(c0?.title, "Home Page");
      expect(c0?.content.length, 1);

      File original = File('/home/david/temp/original.json');
      File returned = File('/home/david/temp/returned.json');
      await script.writeToFile(original);
      await script.writeToFile(returned);

      expect(script.toJson(), script2.toJson());
    });

    test('script to file and back', () async {
      // given
      Directory tempDir = Directory.systemTemp;
      File f = File('${tempDir.path}/scriptOut.json');
      PScript script = kitchenSinkScript;

      // when
      script.init();
      await script.writeToFile(f);
      final script2 = await PScript.readFromFile(f);
      // then

      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });
  });
}

int nullsInTracker(List<String> tracker) {
  int count = 0;
  for (String item in tracker) {
    if (item.contains('null')) {
      count++;
    }
  }
  return count;
}