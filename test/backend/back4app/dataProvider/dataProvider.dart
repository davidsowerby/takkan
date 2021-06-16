import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/dataProvider.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/script/script.dart';
import 'package:graphql/client.dart';

import '../../script.dart';

void main() {
  group('Script CRUD', () {
    Back4AppDataProvider? provider;
    setUpAll(() async {
      File f = File('back4app.json');
      final raw = await f.readAsString();
      final jsonConfig = json.decode(raw);
      final PBack4AppDataProvider config = PBack4AppDataProvider(
        configSource: PConfigSource(segment: 'back4app', instance: 'dev'),
      );

      provider = Back4AppDataProvider(config: config);
    });

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('create', () async {
      // given

      // when

      myScript.init();
      final QueryResult result =
          await provider!.uploadPreceptScript(script: myScript, locale: Locale('en', 'US'));
      // then
      expect(result.data?['createPreceptScript'], isNotNull);
      expect(result.data?['createPreceptScript']?['preceptScript']?['version'], 0);
      expect(result.data?['createPreceptScript']?['preceptScript']?['script']?['version'], 0);

      // when
      final QueryResult result2 = await provider!.uploadPreceptScript(
          script: myScript, locale: Locale('en', 'US'), incrementVersion: true);

      expect(result2.data?['createPreceptScript'], isNotNull);
      expect(result2.data?['createPreceptScript']?['preceptScript']?['version'], 1);
      expect(result2.data?['createPreceptScript']?['preceptScript']?['script']?['version'], 1);
    });

    test('latest versions', () async {
      // given

      // when
      final PScript result = await provider!.latestScript(name: 'Kitchen Sink', locale: Locale('en', 'US'), fromVersion: 2);
      // then

      expect(result, isNotNull);
      expect(result.name, "Kitchen Sink");
      expect(result.version, 3);
    });
  });
}
