import 'package:takkan_back4app_client/backend/back4app/provider/data_provider.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/app/app_config_loader.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_medley_script/medley/medley_script.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:test/test.dart';

/// Note: This uses the takkan-dev instance of Back4App and therefore needs
/// takkan.json to be set up for it (but excluded from Git)
void main() async {
  AppConfigFileLoader loader = AppConfigFileLoader();
  AppConfig appConfig = await loader.load();
  late Script script;
  group('Provider CRUD', () {
    IDataProvider? provider;
    setUpAll(() async {
      script = medleyScript[0];
      script.init();
      provider = Back4AppDataProvider(config: script.dataProvider!);
      provider?.init(appConfig);
    });

    tearDownAll(() {});

    /// clear the TakkanScript table
    setUp(() async {
      // await deleteAllScripts(provider, scriptSchema);
    });

    /// Using PScript as it is versioned, so we get to test that as well
    group('versioned document', () {
      // test('CRUD positive test', () async {
      //   // given
      //
      //   // when
      //   final CreateResult createResult = await provider!.createDocument(
      //     data: s.toJson(),
      //     path: 'TakkanScript',
      //     fieldSelector: FieldSelector(fields: ['createdAt']),
      //   );
      //   // then
      //
      //   expect(createResult.success, isTrue);
      //   expect(createResult.objectId.length, 10);
      //   expect(createResult.createdAt, isNotNull);
      //
      //   // when read
      //   final ReadResultItem readResult = await provider!.readDocument(
      //       documentId: createResult.documentId,
      //       fieldSelector: FieldSelector(fields: ['objectId', 'name']));
      //
      //   // then field limited result
      //   expect(readResult.objectId, createResult.objectId);
      //   expect(readResult.data['name'], 'Kitchen Sink');
      //
      //   /// __typename is also returned, but deleted by readDocument
      //   expect(readResult.data.length, 2);
      //
      //   // given
      //   final ReadResultItem readResult2 = await provider!.readDocument(
      //     documentId: createResult.documentId,
      //     fieldSelector: FieldSelector(allFields: true),
      //   );
      //   final updatedData = Map<String, dynamic>.from(readResult2.data);
      //   updatedData['controlEdit'] =
      //       ControlEdit.panelsOnly.toString().replaceFirst('ControlEdit.', '');
      //   // when update
      //   final updateResult = await provider!.updateDocument(
      //       documentId: readResult2.documentId, data: updatedData);
      //
      //   expect(updateResult.success, isTrue);
      //
      //   final ReadResult readResult3 = await provider!.readDocument(
      //     documentId: createResult.documentId,
      //     fieldSelector: FieldSelector(fields: ['version', 'controlEdit']),
      //     fetchPolicy: FetchPolicy.networkOnly,
      //   );
      //   expect(readResult3.data['controlEdit'], 'panelsOnly');
      //   expect(readResult3.data['version'], 1);
      // });
    });
    //   test('create', () async {
    //     // given
    //
    //     // when
    //
    //     myScript.init();
    //     final UpdateResult result = await provider!
    //         .uploadTakkanScript(script: myScript, locale: Locale('en', 'US'));
    //     // then
    //     expect(result.data['createTakkanScript'], isNotNull);
    //     expect(
    //         result.data['createTakkanScript']?['takkanScript']?['version'], 0);
    //     expect(
    //         result.data['createTakkanScript']?['takkanScript']?['script']
    //             ?['version'],
    //         0);
    //
    //     // when
    //     final UpdateResult result2 = await provider!.uploadTakkanScript(
    //         script: myScript, locale: Locale('en', 'US'), incrementVersion: true);
    //
    //     expect(result2.data['createTakkanScript'], isNotNull);
    //     expect(
    //         result2.data['createTakkanScript']?['takkanScript']?['version'], 1);
    //     expect(
    //         result2.data['createTakkanScript']?['takkanScript']?['script']
    //             ?['version'],
    //         1);
    //   });
    //
    //   test('latest versions', () async {
    //     // given we load a v0, v1 and 2 x v2
    //     await provider!.uploadTakkanScript(
    //         script: myScript,
    //         locale: Locale('en', 'US'),
    //         incrementVersion: false);
    //     UpdateResult result = await provider!.uploadTakkanScript(
    //         script: myScript, locale: Locale('en', 'US'), incrementVersion: true);
    //     final myScript1 = PScript.fromJson(result.data);
    //     result = await provider!.uploadTakkanScript(
    //         script: myScript1,
    //         locale: Locale('en', 'US'),
    //         incrementVersion: true);
    //     final myScript2 = PScript.fromJson(result.data);
    //     result = await provider!.uploadTakkanScript(
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

const String fetchAllScripts = r'''query GetTakkanScripts {
  takkanScripts {
    edges {
      node{
        objectId
        name
      }
    }
  }
}''';

deleteAllScripts(IDataProvider? provider, Document scriptSchema) async {
  final ReadResultList result = await provider!.fetchList(
      queryConfig: GraphQLQuery(
        queryName: 'deleteAllScripts',
        documentSchema: 'PScript',
        queryScript: fetchAllScripts,
      ),
      pageArguments: {});
  final List<Map<String, dynamic>> currentEntries = result.data;

  for (Map<String, dynamic> e in currentEntries) {
    await provider.deleteDocument(
      documentId: provider.documentIdFromData(e),
    );
  }
}
