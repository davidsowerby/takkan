import 'package:test/test.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given

      // when

      // then

      expect(1, 1);
    });
  });
}

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:precept_backend/backend/data_provider/data_provider.dart';
// import 'package:precept_backend/backend/data_provider/result.dart';
// import 'package:precept_client/data/document_cache.dart';
// import 'package:precept_script/data/provider/document_id.dart';
// import 'package:precept_script/inject/inject.dart';
// import 'package:precept_script/query/query.dart';
// import 'package:precept_script/schema/schema.dart';
// import 'package:precept_script/script/script.dart';
// import 'package:precept_script/script/version.dart';
//
// import '../helper/listener.dart';
// import '../helper/mock.dart';
//
// void main() {
//   late DocumentClassCache classCache;
//   late ChangeListener listener;
//   late DataProvider dataProvider;
//   late UserDiscardChangesPrompt discardChangesPrompt;
//   late UserDeleteDocumentPrompt confirmDeletePrompt;
//   group('ClassCache, successful network connections assumed', () {
//     setUpAll(() {
//       registerFallbackValue(FakeDocumentId());
//       discardChangesPrompt = MockUserDiscardChangesPrompt();
//       confirmDeletePrompt = MockUserDeleteDocumentPrompt();
//       getIt.registerFactory<UserDiscardChangesPrompt>(
//           () => discardChangesPrompt);
//       getIt
//           .registerFactory<UserDeleteDocumentPrompt>(() => confirmDeletePrompt);
//     });
//
//     setUp(() {
//       late UserDiscardChangesPrompt discardChangesPrompt =
//           MockUserDiscardChangesPrompt();
//       late UserDeleteDocumentPrompt confirmDeletePrompt =
//           MockUserDeleteDocumentPrompt();
//       final documentSchema = PDocument(fields: {});
//       dataProvider = MockDataProvider();
//       when(() => dataProvider.objectIdKey).thenReturn('objectId');
//
//       /// easier to use a script, and init, to set up PDocument
//       final script = PScript(
//         name: 'test',
//         version: PVersion(number: 0),
//         schema: PSchema(
//             name: 'test',
//             version: PVersion(number: 0),
//             documents: {'Person': documentSchema}),
//       );
//       final config = PPage(documentClass: 'Person', content: []);
//       script.init();
//
//       ///
//       classCache = DocumentClassCache(
//           config: config,
//           dataProvider: dataProvider,
//           documentSchema: documentSchema);
//       listener = ChangeListener();
//     });
//
//     group('createDocument', () {
//       test('no changes present', () async {
//         // given
//         classCache.temporaryDocument.addListener(listener.listenToChange);
//         // when
//         await classCache.createDocument();
//         // then
//
//         expect(classCache.temporaryDocument.changes.isEmpty, isTrue,
//             reason: 'changes empty');
//         expect(classCache.temporaryDocument.output.isEmpty, isTrue,
//             reason: 'data cleared');
//         expect(classCache.temporaryDocument.initialData.isEmpty, isTrue,
//             reason: 'initial data cleared');
//         expect(listener.changeCount, 1, reason: 'listener fired');
//       });
//
//       test('unsaved changes present, discardChanges=false', () async {
//         // given a change
//         final td = classCache.temporaryDocument;
//         td.createNew(initialData: {'age': 23});
//         td['name'] = 'Peter';
//         when(() => discardChangesPrompt.getResponse())
//             .thenAnswer((_) async => false);
//         classCache.temporaryDocument.addListener(listener.listenToChange);
//         // when
//         final actual = await classCache.createDocument(discardChanges: false);
//         // then
//         expect(actual, isFalse);
//       });
//       test('unsaved changes present, discardChanges=true', () async {
//         // given a change
//         final td = classCache.temporaryDocument;
//         td.createNew(initialData: {'age': 23});
//         td['name'] = 'Peter';
//         classCache.temporaryDocument.addListener(listener.listenToChange);
//         // when
//         await classCache.createDocument(discardChanges: true);
//         // then
//
//         expect(classCache.temporaryDocument.changes.isEmpty, isTrue,
//             reason: 'changes empty');
//         expect(classCache.temporaryDocument.output.isEmpty, isTrue,
//             reason: 'data cleared');
//         expect(classCache.temporaryDocument.initialData.isEmpty, isTrue,
//             reason: 'initial data cleared');
//         expect(listener.changeCount, 1, reason: 'listener fired');
//       });
//     });
//     group('updateRemote', () {
//       test('DataProvider.create called on new document', () async {
//         // given a change
//         final td = classCache.temporaryDocument;
//         classCache.temporaryDocument.addListener(listener.listenToChange);
//         td.createNew(initialData: {'age': 23});
//         td['name'] = 'Peter';
//         when(() => dataProvider.objectIdKey).thenReturn('objectId');
//
//         final readResult = MockCreateResult();
//         when(() => readResult.objectId).thenReturn('aaa');
//         when(() => dataProvider.createDocument(
//                 documentClass: 'Person', data: any(named: 'data')))
//             .thenAnswer((_) => Future.value(readResult));
//         // when(() => dataProvider.updateDocument( data: any(), documentId: any())).thenReturn(UpdateResult(data: data, success: success, documentClass: path, objectId: itemId));
//         // when
//         final result = await classCache.updateRemote();
//         // then
//         expect(result, isA<CreateResult>());
//
//         /// These three a result of marking the document as 'saved'
//         expect(td.changeList, isEmpty);
//         expect(td.changes, isEmpty);
//         expect(td.initialData, td.output);
//
//         expect(classCache.temporaryDocument.output['objectId'], 'aaa',
//             reason:
//                 'objectId returned from server, updated in temporaryDocument');
//         expect(classCache.cacheContains(classCache.currentItemId), isTrue,
//             reason: 'latest version should be in cache');
//       });
//       test('DataProvider.update called on update existing', () async {
//         // given a change
//         final td = classCache.temporaryDocument;
//         classCache.temporaryDocument.addListener(listener.listenToChange);
//         td.createNew(initialData: {'age': 23});
//         td['objectId'] = 'xxx'; // simulate existing document
//         td['name'] = 'Peter';
//         when(() => dataProvider.objectIdKey).thenReturn('objectId');
//         when(() => dataProvider.updateDocument(
//                 data: any(named: 'data'),
//                 documentId:
//                     DocumentId(documentClass: 'Person', objectId: 'xxx')))
//             .thenAnswer((_) => Future.value(MockUpdateResult()));
//         final result = await classCache.updateRemote();
//         // then
//         expect(result, isA<UpdateResult>());
//
//         /// These three a result of marking the document as 'saved'
//         expect(td.changeList, isEmpty);
//         expect(td.changes, isEmpty);
//         expect(td.initialData, td.output);
//       });
//     });
//     group('read document', () {
//       test('read document, no changes present, document in cache', () async {
//         // given
//         final String itemId = 'xxx';
//         final document = <String, dynamic>{
//           'objectId': itemId,
//           'firstName': 'George',
//         };
//         classCache.addToCache(document);
//         final readResult = ReadResultItem(
//           documentClass: 'Person',
//           data: document,
//           success: true,
//           queryReturnType: QueryReturnType.futureItem,
//         );
//         when(() => dataProvider.readDocument(
//                 documentId:
//                     DocumentId(documentClass: 'Person', objectId: itemId)))
//             .thenAnswer((_) => Future.value(readResult));
//         // when
//         final actual = await classCache.readDocument(objectId: itemId);
//         // then
//
//         expect(actual, isTrue);
//         expect(classCache.cacheContains(itemId), isTrue);
//         expect(classCache.currentItemId, itemId);
//         expect(classCache.temporaryDocument.output['firstName'], 'George');
//         verifyNever(() => dataProvider.readDocument(
//             documentId: DocumentId(documentClass: 'Person', objectId: itemId)));
//       });
//       test('read document, no changes present, document not in cache',
//           () async {
//         // given
//         final String itemId = 'xxx';
//         final document = <String, dynamic>{
//           'objectId': itemId,
//           'firstName': 'George',
//         };
//         final readResult = ReadResultItem(
//           documentClass: 'Person',
//           data: document,
//           success: true,
//           queryReturnType: QueryReturnType.futureItem,
//         );
//         when(() => dataProvider.readDocument(
//                 documentId:
//                     DocumentId(documentClass: 'Person', objectId: itemId)))
//             .thenAnswer((_) => Future.value(readResult));
//         // when
//         final actual = await classCache.readDocument(objectId: itemId);
//         // then
//
//         expect(actual, isTrue);
//         expect(classCache.cacheContains(itemId), isTrue);
//         expect(classCache.currentItemId, itemId);
//         expect(classCache.temporaryDocument.output['firstName'], 'George');
//         verify(() => dataProvider.readDocument(
//                 documentId:
//                     DocumentId(documentClass: 'Person', objectId: itemId)))
//             .called(1);
//       });
//       test('read document, unsaved changes, abort', () async {
//         // given some changes to existing document
//         final String existingId = 'xxa';
//         final td = classCache.temporaryDocument;
//         td.createNew(initialData: {'age': 23});
//         td['objectId'] = existingId; // simulate existing document
//         td['firstName'] = 'Peter';
//         // and user declines discarding changes
//         when(() => discardChangesPrompt.getResponse())
//             .thenAnswer((_) async => false);
//
//         // document from store
//         final String itemId = 'xxx';
//         final document = <String, dynamic>{
//           'objectId': itemId,
//           'firstName': 'George',
//         };
//         final readResult = ReadResultItem(
//           documentClass: 'Person',
//           data: document,
//           success: true,
//           queryReturnType: QueryReturnType.futureItem,
//         );
//         when(() => dataProvider.readDocument(
//                 documentId:
//                     DocumentId(documentClass: 'Person', objectId: itemId)))
//             .thenAnswer((_) => Future.value(readResult));
//
//         // when
//         final actual = await classCache.readDocument(objectId: itemId);
//         // then
//
//         expect(actual, isFalse);
//         expect(classCache.cacheContains(itemId), isFalse);
//         expect(classCache.currentItemId, existingId);
//         expect(classCache.temporaryDocument.output['firstName'], 'Peter');
//         verifyNever(() => dataProvider.readDocument(
//             documentId: DocumentId(documentClass: 'Person', objectId: itemId)));
//       });
//       test('read document, unsaved changes, discard changes', () async {
//         // given some changes to existing document
//         final String existingId = 'xxa';
//         final td = classCache.temporaryDocument;
//         td.createNew(initialData: {'age': 23});
//         td['objectId'] = existingId; // simulate existing document
//         td['firstName'] = 'Peter';
//         // and user approves discarding changes
//         when(() => discardChangesPrompt.getResponse())
//             .thenAnswer((_) async => true);
//
//         // document from store
//         final String itemId = 'xxx';
//         final document = <String, dynamic>{
//           'objectId': itemId,
//           'firstName': 'George',
//         };
//         final readResult = ReadResultItem(
//           documentClass: 'Person',
//           data: document,
//           success: true,
//           queryReturnType: QueryReturnType.futureItem,
//         );
//         when(() => dataProvider.readDocument(
//                 documentId:
//                     DocumentId(documentClass: 'Person', objectId: itemId)))
//             .thenAnswer((_) => Future.value(readResult));
//
//         // when
//         final actual = await classCache.readDocument(objectId: itemId);
//         // then
//
//         expect(actual, isTrue);
//         expect(classCache.cacheContains(itemId), isTrue);
//         expect(classCache.currentItemId, itemId);
//         expect(classCache.temporaryDocument.output['firstName'], 'George');
//         verifyNever(() => dataProvider.updateDocument(
//             documentId:
//                 DocumentId(documentClass: 'Person', objectId: existingId),
//             data: any(named: 'data')));
//       });
//       test('read document, remote read fails, unknown id', () async {
//         // given
//         final String itemId = 'xxx';
//         final String newItemId = 'xxy';
//         final document = <String, dynamic>{
//           'objectId': itemId,
//           'firstName': 'George',
//         };
//         classCache.temporaryDocument.createNew(initialData: document);
//         // /// Mocks being saved, clearing changes
//         // dataStore.temporaryDocument.saved();
//         /// read indicates failure
//         final readResult = ReadResultItem(
//           documentClass: 'Person',
//           data: document,
//           success: false,
//           queryReturnType: QueryReturnType.futureItem,
//         );
//         when(() => dataProvider.readDocument(
//                 documentId:
//                     DocumentId(documentClass: 'Person', objectId: newItemId)))
//             .thenAnswer((_) => Future.value(readResult));
//         // when
//         final actual = await classCache.readDocument(objectId: newItemId);
//         // then
//
//         expect(actual, isFalse);
//         expect(classCache.cacheContains(itemId), isFalse);
//         expect(classCache.currentItemId, itemId);
//         expect(classCache.temporaryDocument.output['firstName'], 'George');
//         verify(() => dataProvider.readDocument(
//                 documentId:
//                     DocumentId(documentClass: 'Person', objectId: newItemId)))
//             .called(1);
//       });
//     });
//     group('delete document', () {
//       test('delete document, document is current, remote deletion succeeds',
//           () async {
//         // given
//             final String existingId = 'xxa';
//         final td = classCache.temporaryDocument;
//         td.createNew(initialData: {'age': 23});
//         td['objectId'] = existingId; // simulate existing document
//         td['firstName'] = 'Peter';
//
//         // user confirms delete
//         when(() => confirmDeletePrompt.getResponse())
//             .thenAnswer((_) async => true);
//
//         final deleteResult = DeleteResult(
//             data: const {},
//             success: true,
//             documentClass: 'Person',
//             objectId: existingId);
//         when(
//           () => dataProvider.deleteDocument(
//             documentId:
//                 DocumentId(documentClass: 'Person', objectId: existingId),
//           ),
//         ).thenAnswer((_) => Future.value(deleteResult));
//         // when
//         final actual = await classCache.deleteDocument(objectId: existingId);
//         // then
//
//         expect(actual, isTrue);
//         expect(classCache.temporaryDocument.isEmpty, isTrue);
//         expect(classCache.cacheContains(existingId), isFalse);
//       });
//       test('delete document, document is current, remote deletion fails',
//           () async {
//         // given
//             final String existingId = 'xxa';
//         final td = classCache.temporaryDocument;
//         td.createNew(initialData: {'age': 23});
//         td['objectId'] = existingId; // simulate existing document
//         td['firstName'] = 'Peter';
//
//         classCache.addToCache(td.output);
//         // user confirms delete
//         when(() => confirmDeletePrompt.getResponse())
//             .thenAnswer((_) async => true);
//
//         final deleteResult = DeleteResult(
//             data: const {},
//             success: false,
//             documentClass: 'Person',
//             objectId: existingId);
//         when(
//           () => dataProvider.deleteDocument(
//             documentId:
//                 DocumentId(documentClass: 'Person', objectId: existingId),
//           ),
//         ).thenAnswer((_) => Future.value(deleteResult));
//         // when
//         final actual = await classCache.deleteDocument(objectId: existingId);
//         // then
//
//         expect(actual, isFalse);
//         expect(classCache.temporaryDocument.isEmpty, isFalse);
//         expect(classCache.cacheContains(existingId), isTrue);
//       });
//
//       test('delete document, document is current, user changes mind', () async {
//         // given
//         final String existingId = 'xxa';
//         final td = classCache.temporaryDocument;
//         td.createNew(initialData: {'age': 23});
//         td['objectId'] = existingId; // simulate existing document
//         td['firstName'] = 'Peter';
//
//         classCache.addToCache(td.output);
//         // user confirms delete
//         when(() => confirmDeletePrompt.getResponse())
//             .thenAnswer((_) async => false);
//
//         final deleteResult = DeleteResult(
//             data: const {},
//             success: true,
//             documentClass: 'Person',
//             objectId: existingId);
//         when(
//           () => dataProvider.deleteDocument(
//             documentId:
//                 DocumentId(documentClass: 'Person', objectId: existingId),
//           ),
//         ).thenAnswer((_) => Future.value(deleteResult));
//         // when
//         final actual = await classCache.deleteDocument(objectId: existingId);
//         // then
//
//         expect(actual, isFalse);
//         expect(classCache.temporaryDocument.isEmpty, isFalse);
//         expect(classCache.cacheContains(existingId), isTrue);
//       });
//     });
//   });
// }
