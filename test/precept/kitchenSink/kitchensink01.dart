/// See [developer guide](https://takkan.org/developer-guide/kitchenSink.html#static-page-with-overrides)
///

// final Script kitchenSink01 = Script(
//   name: 'script01',
//   version: Version(number: 0),
//   routes: {
//     'test': PPage(
//       pageType: Library.simpleKey,
//       caption: 'Page 1',
//       content: [
//         PPanel(
//           caption: 'Panel 1',
//           heading: PPanelHeading(),
//           content: [
//             PText(
//               id: 'Part 1-1',
//               staticData: 'Part 1-1',
//             ),
//             PText(
//               id: 'Part 1-2',
//               staticData: 'Part 1-2',
//             ),
//             PPanel(
//               caption: 'Panel 1-3',
//               dataProvider: PDataProvider(
//                 instanceConfig: PInstance(group: 'fake', instance: 'mock'),
//               ),
//               data: DataItem(
//                 objectId: 'objectId1',
//               ),
//               controlEdit: ControlEdit.thisOnly,
//               property: '',
//               content: [
//                 Part(
//                   readTraitName: PText.defaultReadTrait,
//                   property: 'firstName',
//                   caption: 'Part 1-3-1',
//                   staticData: 'Part 1-3-1',
//                 ),
//                 Part(
//                   readTraitName: PText.defaultReadTrait,
//                   property: 'lastName',
//                   caption: 'Part 1-3-2',
//                   staticData: 'Part 1-3-2',
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Part(
//             readTraitName: PText.defaultReadTrait,
//             id: 'Part 2',
//             staticData: 'Part 2',
//             caption: 'Part 2'),
//         Part(
//             readTraitName: PText.defaultReadTrait,
//             id: 'Part 3',
//             staticData: 'Part 3',
//             caption: 'Part 3'),
//       ],
//     ),
//   },
//   schema: kitchenSinkSchema01,
// );
//
// final Schema kitchenSinkSchema01 = Schema(
//   version: Version(number: 0),
//   name: 'schema01',
//   documents: {
//     'Account': Document(
//       fields: {
//         'firstName': FString(),
//         'lastName': FString(),
//       },
//     ),
//   },
// );
//
// void main() {
//   group('Static Page with Overrides (kitchen-sink-01)', () {
//     late WidgetTestTree testTree;
//     final AppConfig appConfig = MockAppConfig();
//
//     setUpAll(() {});
//
//     tearDownAll(() {});
//
//     setUp(() {});
//
//     tearDown(() {
//       testTree.debug.forEach((element) {
//         print("$element\n");
//       });
//     });
//
//     testWidgets('All ', (WidgetTester tester) async {
//       // given
//       final Script script = KitchenSinkTest().init(
//         script: kitchenSink01,
//         useCaptionsAsIds: true,
//         appConfig: MockAppConfig(),
//       );
//       script.init();
//       // when
//       final widgetTree = MaterialApp(
//           home: TakkanPage(
//         config: script.routes['test']!, dataConnector: null,
//       ));
//       await tester.pumpWidget(widgetTree);
//       // final pumps = await tester.pumpAndSettle(const Duration(milliseconds: 500),);
//       testTree = WidgetTestTree(script, tester.allWidgets.toList(),
//           pages: 1, panels: 2, parts: 4);
//       // then
//       testTree.verify();
//
//       final pageId = 'script01.test';
//       expect(testTree.elementHasEditState(pageId), isFalse);
//       expect(
//           testTree.elementHasDataBinding(pageId, TakkanPage, tester), isFalse);
//       expect(
//           testTree.elementHasDataStore(pageId, TakkanPage, tester), isFalse);
//
//       final panel1Id = 'script01.test.Panel 1';
//       expect(testTree.elementHasEditState(panel1Id), isFalse);
//       expect(testTree.elementHasDataBinding(panel1Id, Panel, tester), isFalse);
//       expect(testTree.elementHasDataStore(panel1Id, Panel, tester), isFalse);
//
//       final panel13Id = 'script01.test.Panel 1.Panel 1-3';
//       expect(testTree.elementHasEditState(panel13Id), isTrue);
//       expect(testTree.elementHasDataBinding(panel13Id, Panel, tester), isTrue);
//       expect(testTree.elementHasDataStore(panel13Id, Panel, tester), isTrue);
//
//       final part2Id = 'script01.test.Part 2';
//       expect(testTree.elementHasEditState(part2Id), isFalse);
//       expect(testTree.elementHasDataBinding(part2Id, TakkanPage, tester),
//           isFalse);
//       expect(
//           testTree.elementHasDataStore(part2Id, TakkanPage, tester), isFalse);
//
//       final part3Id = 'script01.test.Part 3';
//       expect(testTree.elementHasEditState(part3Id), isFalse);
//       expect(testTree.elementHasDataBinding(part3Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part3Id, Part, tester), isFalse);
//
//       final part11Id = 'script01.test.Panel 1.Part 1-1';
//       expect(testTree.elementHasEditState(part11Id), isFalse);
//       expect(testTree.elementHasDataBinding(part11Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part11Id, Part, tester), isFalse);
//
//       final part12Id = 'script01.test.Panel 1.Part 1-2';
//       expect(testTree.elementHasEditState(part12Id), isFalse);
//       expect(testTree.elementHasDataBinding(part12Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part12Id, Part, tester), isFalse);
//
//       final part131Id = 'script01.test.Panel 1.Panel 1-3.Part 1-3-1';
//       expect(testTree.elementHasEditState(part131Id), isFalse);
//       expect(testTree.elementHasDataBinding(part131Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part131Id, Part, tester), isFalse);
//
//       final part132Id = 'script01.test.Panel 1.Panel 1-3.Part 1-3-2';
//       expect(testTree.elementHasEditState(part132Id), isFalse);
//       expect(testTree.elementHasDataBinding(part132Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part132Id, Part, tester), isFalse);
//     });
//   }, skip: true);
// }
