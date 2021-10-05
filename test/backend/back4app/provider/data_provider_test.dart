import 'package:graphql/client.dart';
import 'package:precept_back4app_client/backend/back4app/provider/data_provider.dart';
import 'package:precept_back4app_client/backend/back4app/provider/pback4app_data_provider.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/query/field_selector.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/test.dart';

import '../../../kitchensink_script.dart';

void main() async {
  AppConfigFileLoader loader = AppConfigFileLoader();
  AppConfig appConfig = await loader.load();
  group('Provider CRUD', () {
    DataProvider? provider;

    setUpAll(() async {
      final PBack4AppDataProvider providerConfig = PBack4AppDataProvider(
        configSource: PConfigSource(segment: 'precept', instance: 'dev'),
        schema: PSchema(
            name: 'test',
            version: PVersion(number: 0),
            documents: {'PreceptScript': pScriptSchema0}),
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
        final CreateResult createResult = await provider!.createDocument(
          data: myScript.toJson(),
          path: 'PreceptScript',
          fieldSelector: FieldSelector(fields: ['createdAt']),
        );
        // then

        expect(createResult.success, isTrue);
        expect(createResult.objectId.length, 10);
        expect(createResult.createdAt, isNotNull);

        // when read
        final ReadResultItem readResult = await provider!.readDocument(
            documentId: createResult.documentId,
            fieldSelector: FieldSelector(fields: ['objectId', 'name']));

        // then field limited result
        expect(readResult.objectId, createResult.objectId);
        expect(readResult.data['name'], 'Kitchen Sink');

        /// __typename is also returned, but deleted by readDocument
        expect(readResult.data.length, 2);

        // given
        final ReadResultItem readResult2 = await provider!.readDocument(
          documentId: createResult.documentId,
          fieldSelector: FieldSelector(allFields: true),
        );
        final updatedData = Map<String, dynamic>.from(readResult2.data);
        updatedData['controlEdit'] =
            ControlEdit.panelsOnly.toString().replaceFirst('ControlEdit.', '');
        // when update
        final updateResult = await provider!.updateDocument(
            documentId: readResult2.documentId, data: updatedData);

        expect(updateResult.success, isTrue);

        final ReadResult readResult3 = await provider!.readDocument(
          documentId: createResult.documentId,
          fieldSelector: FieldSelector(fields: ['version', 'controlEdit']),
          fetchPolicy: FetchPolicy.networkOnly,
        );
        expect(readResult3.data['controlEdit'], 'panelsOnly');
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
  final ReadResultList result = await provider!.fetchList(
      queryConfig: PGraphQLQuery(
        queryName: 'deleteAllScripts',
        documentSchema: 'PScript',
        script: fetchAllScripts,
      ),
      pageArguments: {});
  final List<Map<String, dynamic>> currentEntries = result.data;

  for (Map<String, dynamic> e in currentEntries) {
    await provider.deleteDocument(
      documentId: provider.documentIdFromData(e),
    );
  }
}
