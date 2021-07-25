import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/dataProvider.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/fieldSelector.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

import '../../../script.dart';

void main() {
  group('Provider CRUD', () {
    DataProvider? provider;
    AppConfig appConfig = AppConfig({
      'back4app': {
        'dev': {
          'X-Parse-Application-Id': 'xLWKrOqVNy3O1u3z9ovoalO2XFuKQn0NlHPksJV6',
          'X-Parse-Client-Key': 'Ib1NDOh4ph4fkCci0IIxWF01flSxhpJf6FO1gAkQ',
          'serverUrl': 'https://parseapi.back4app.com/',
        }
      }
    });
    setUpAll(() async {
      final PBack4AppDataProvider providerConfig = PBack4AppDataProvider(
        configSource: PConfigSource(segment: 'back4app', instance: 'dev'),
        scriptDelegate: CloudInterface.graphQL,
        schema:
            PSchema(name: 'test', documents: {'PreceptScript': pScriptSchema0}),
      );

      provider = Back4AppDataProvider(config: providerConfig);
      provider?.init(appConfig);
    });

    tearDownAll(() {});

    /// clear the PreceptScript table
    setUp(() async {
      // await deleteAllScripts(provider, scriptSchema);
    });

    /// Using PScript as it is versioned, so we get to test that as well
    group('versioned document', () {
      test('CRUD positive test', () async {
        // given
        myScript.init();

        // when
        final CreateResult createResult =
            await provider!.createPScriptDocument(script: myScript);
        // then

        expect(createResult.success, isTrue);
        expect(createResult.objectId.length, 10);
        expect(createResult.createdAt, isNotNull);

        // when read
        final ReadResult readResult = await provider!.readDocument(
            documentId: createResult.documentId,
            fieldSelector: FieldSelector(fields: ['objectId', 'name']));

        // then field limited result
        expect(readResult.objectId, createResult.objectId);
        expect(readResult.data['name'], 'Kitchen Sink');

        /// __typename is also returned, but deleted by readDocument
        expect(readResult.data.length, 2);

        // given
        final ReadResult readResult2 = await provider!.readDocument(
          documentId: createResult.documentId,
          fieldSelector: FieldSelector(allFields: true),
        );
        final updatedData = Map<String, dynamic>.from(readResult2.data);
        updatedData['script']['controlEdit'] =
            ControlEdit.panelsOnly.toString().replaceFirst('ControlEdit.', '');
        // when update
        final updateResult = await provider!.updateDocument(
            documentId: readResult2.documentId, data: updatedData);

        expect(updateResult.success, isTrue);

        final ReadResult readResult3 = await provider!.readDocument(
          documentId: createResult.documentId,
          fieldSelector: FieldSelector(fields: ['version', 'script']),
        );
        expect(readResult3.data['script']['controlEdit'], 'panelsOnly');
        expect(readResult3.data['version'], 1);
      });
    });
    //   test('create', () async {
    //     // given
    //
    //     // when
    //
    //     myScript.init();
    //     final UpdateResult result = await provider!
    //         .uploadPreceptScript(script: myScript, locale: Locale('en', 'US'));
    //     // then
    //     expect(result.data['createPreceptScript'], isNotNull);
    //     expect(
    //         result.data['createPreceptScript']?['preceptScript']?['version'], 0);
    //     expect(
    //         result.data['createPreceptScript']?['preceptScript']?['script']
    //             ?['version'],
    //         0);
    //
    //     // when
    //     final UpdateResult result2 = await provider!.uploadPreceptScript(
    //         script: myScript, locale: Locale('en', 'US'), incrementVersion: true);
    //
    //     expect(result2.data['createPreceptScript'], isNotNull);
    //     expect(
    //         result2.data['createPreceptScript']?['preceptScript']?['version'], 1);
    //     expect(
    //         result2.data['createPreceptScript']?['preceptScript']?['script']
    //             ?['version'],
    //         1);
    //   });
    //
    //   test('latest versions', () async {
    //     // given we load a v0, v1 and 2 x v2
    //     await provider!.uploadPreceptScript(
    //         script: myScript,
    //         locale: Locale('en', 'US'),
    //         incrementVersion: false);
    //     UpdateResult result = await provider!.uploadPreceptScript(
    //         script: myScript, locale: Locale('en', 'US'), incrementVersion: true);
    //     final myScript1 = PScript.fromJson(result.data);
    //     result = await provider!.uploadPreceptScript(
    //         script: myScript1,
    //         locale: Locale('en', 'US'),
    //         incrementVersion: true);
    //     final myScript2 = PScript.fromJson(result.data);
    //     result = await provider!.uploadPreceptScript(
    //         script: myScript2,
    //         locale: Locale('en', 'US'),
    //         incrementVersion: false);
    //     // when
    //     final PScript latest = await provider!.latestScript(
    //         name: 'Kitchen Sink', locale: Locale('en', 'US'), fromVersion: 2);
    //     // then
    //
    //     expect(latest, isNotNull);
    //     expect(latest.name, 'Kitchen Sink');
    //     expect(latest.version, 2);
    //   });
  });
}

const String fetchAllScripts = r'''query GetPreceptScripts {
  preceptScripts {
    edges {
      node{
        objectId
        name
      }
    }
  }
}''';

deleteAllScripts(DataProvider? provider, PDocument scriptSchema) async {
  final List<Map<String, dynamic>> currentEntries = await provider!.fetchList(
      queryConfig: PGraphQLQuery(querySchema: '', script: fetchAllScripts),
      pageArguments: {});

  for (Map<String, dynamic> e in currentEntries) {
    await provider.deleteDocument(
      documentId: provider.documentIdFromData(e),
    );
  }
}
