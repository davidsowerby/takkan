// import 'package:mocktail/mocktail.dart';
// import 'package:takkan_backend/backend/data_provider/data_provider.dart';
// import 'package:takkan_backend/backend/data_provider/data_provider_library.dart';
// import 'package:takkan_backend/backend/data_provider/result.dart';
// import 'package:takkan_client/app/takkan.dart';
// import 'package:takkan_client/data/data_root.dart';
// import 'package:takkan_client/data/data_source.dart';
// import 'package:takkan_client/data/document_cache.dart';
// import 'package:takkan_script/data/provider/data_provider.dart';
// import 'package:takkan_script/data/provider/document_id.dart';
// import 'package:takkan_script/data/select/data.dart';
// import 'package:takkan_script/data/select/query.dart';
// import 'package:takkan_script/data/select/single.dart';
// import 'package:takkan_script/inject/inject.dart';
// import 'package:takkan_script/loader/loaders.dart';
// import 'package:takkan_script/page/page.dart';
// import 'package:takkan_script/page/static_page.dart';
// import 'package:takkan_script/schema/schema.dart';
// import 'package:takkan_script/script/script.dart';
// import 'package:takkan_script/script/version.dart';
// import 'package:test/test.dart';
//
// import '../helper/mock.dart';
//
// /// Had to make takkan.loaders public.  This test requires the lookup of
// /// Document from documentClass, and that uses the rootModel of Takkan.
// void main() {
//   group('Document Cache', () {
//     late Script script;
//     late DocumentCache cache;
//     late DataContext parentConnector;
//     late DataProvider dataProvider = MockDataProvider();
//     final mockDataProviderLibrary = MockDataProviderLibrary();
//     final PData dataSelector = DataItem();
//
//     /// TODO: how do we really select this?
//     setUpAll(() {});
//
//     tearDownAll(() {});
//
//     setUp(() {
//       script = Script(
//         name: 'test',
//         version: Version(number: 0),
//         dataProvider: PDataProvider(
//             instanceConfig: PInstance(group: 'test', instance: 'dev')),
//         schema: Schema(
//           version: Version(number: 0),
//           name: 'test',
//           documents: {'Person': Document(fields: {})},
//         ),
//         pages: [],
//       );
//       takkan.loadScripts([DirectTakkanLoader(script: script)]);
//     });
//
//     tearDown(() {});
//
//     group('dataConnector', () {
//       cache = DocumentCache();
//
//       group('parent is NullDataConnector', () {
//         parentConnector = NullDataContext();
//         setUp(() {
//           getIt.reset();
//           getIt.registerSingleton<DataProviderLibrary>(mockDataProviderLibrary);
//           when(() => mockDataProviderLibrary.find(
//               providerConfig: script.dataProvider!)).thenReturn(dataProvider);
//         });
//         test('connection request is static', () {
//           // given
//
//           final page = PPageStatic(routes: ['staticPage']);
//           script.routes['test'] = page;
//           script.init();
//
//           // when
//           // then
//           final actual = cache.dataContext(
//             dataSelector: dataSelector,
//             parentDataContext: parentConnector,
//             config: page,
//           );
//
//           expect(actual, isA<StaticDataContext>());
//           final connector = actual as StaticDataContext;
//           expect(connector.parentDataContext, isA<NullDataContext>());
//         });
//         test('connection request is root with objectId', () async {
//           // given
//           takkan.cache.flush();
//           final page = PPage(
//             documentClass: 'Person',
//             dataSelectors: [
//               DataItemById(
//                 tag: 'fixed',
//                 objectId: 'xxx',
//               ),
//             ],
//           );
//           script.routes['test'] = page;
//           script.init();
//           constructData(dataProvider, page.documentClass!);
//           // when
//           final actual = cache.dataContext(
//             dataSelector: dataSelector,
//             parentDataContext: parentConnector,
//             config: page,
//           );
//           // then
//
//           expect(actual, isA<DocumentRoot>());
//           final connector = actual as DocumentRoot;
//           expect(connector.dataRoot, connector);
//           expect(connector.dataProvider, isA<DataProvider>());
//           expect(connector.dataProvider, dataProvider);
//           expect(connector.dataRoot.documentSchema.name, 'Person');
//           expect(connector.dataRoot.output, isEmpty);
//           expect(connector.dataRoot.isReady, isFalse);
//
//           /// Wait for the data to be read into the cache
//           await Future.delayed(Duration(milliseconds: 300));
//           expect(connector.dataRoot.output, isNotEmpty);
//           expect(connector.dataRoot.output['name'], 'Mike');
//           expect(connector.dataRoot.isReady, isTrue);
//         });
//         test('connection request is root with selectionId', () async {
//           // given
//           takkan.cache.flush();
//           final page = PPage(
//             documentClass: 'Person',
//             dataSelectors: [
//               DataItem(),
//             ],
//           );
//           script.routes['test'] = page;
//           script.init();
//           constructData(dataProvider, page.documentClass!);
//           // when
//           final actual = cache.dataContext(
//             dataSelector: dataSelector,
//             parentDataContext: parentConnector,
//             config: page,
//           );
//           // then
//
//           expect(actual, isA<DocumentRoot>());
//           final connector = actual as DocumentRoot;
//           expect(connector.dataRoot, connector);
//           expect(connector.dataProvider, isA<DataProvider>());
//           expect(connector.dataProvider, dataProvider);
//           expect(connector.dataRoot.documentSchema.name, 'Person');
//           expect(connector.dataRoot.output, isEmpty);
//           expect(connector.dataRoot.isReady, isFalse);
//
//           // when selection made
//           actual.setSelection(objectId: 'xxx');
//
//           /// Wait for the data to be read into the cache
//           await Future.delayed(Duration(milliseconds: 300));
//           expect(connector.dataRoot.output, isNotEmpty);
//           expect(connector.dataRoot.output['name'], 'Mike');
//           expect(connector.dataRoot.isReady, isTrue);
//         });
//       });
//     });
//   });
// }
//
// constructData(DataProvider dataProvider, String documentClass) {
//   final documentIdX = DocumentId(
//     documentClass: documentClass,
//     objectId: 'xxx',
//   );
//   final documentIdY = DocumentId(
//     documentClass: documentClass,
//     objectId: 'yyy',
//   );
//   final ReadResultItem resultX = ReadResultItem(
//     documentClass: documentClass,
//     success: true,
//     data: {'name': 'Mike', 'age': 23, 'objectId': 'xxx'},
//     queryReturnType: QueryReturnType.futureItem,
//   );
//   final ReadResultItem resultY = ReadResultItem(
//     documentClass: documentClass,
//     success: true,
//     data: {'name': 'Katya', 'age': 28, 'objectId': 'yyy'},
//     queryReturnType: QueryReturnType.futureItem,
//   );
//   when(() => dataProvider.readDocument(documentId: documentIdX)).thenAnswer(
//       (_) async => Future<ReadResultItem>.delayed(
//           Duration(milliseconds: 200), () => resultX));
//   when(() => dataProvider.readDocument(documentId: documentIdY)).thenAnswer(
//       (_) async => Future<ReadResultItem>.delayed(
//           Duration(milliseconds: 200), () => resultY));
// }
