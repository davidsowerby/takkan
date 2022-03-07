/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchensink.html#static-page)
///

// final PScript kitchenSink00 = PScript(
//   name: 'script00',
//   version: PVersion(number: 0),
//   routes: {
//     '/test': PPage(
//       pageType: Library.simpleKey,
//       caption: 'Page 1',
//       content: [
//         PText(caption: 'Part 1', staticData: 'Part 1'),
//         PPanel(
//           caption: 'Panel 2',
//           heading: PPanelHeading(),
//           content: [
//             PPanel(
//               caption: 'Panel 2-1',
//               heading: PPanelHeading(),
//               content: [
//                 PPart(
//                     readTraitName: PText.defaultReadTrait,
//                     caption: 'Part 2-1-1',
//                     staticData: 'Part 2-1-1'),
//                 PText(
//                   id: 'Part 2-1-2',
//                   staticData: 'Part 2-1-2',
//                 ),
//               ],
//             ),
//             PPart(
//                 readTraitName: PText.defaultReadTrait,
//                 caption: 'Part 2-2',
//                 staticData: 'Part 2-2'),
//             PText(id: 'Part 2-3', staticData: 'Part 2-3'),
//           ],
//         ),
//         PPart(
//             readTraitName: PText.defaultReadTrait,
//             caption: 'Part 3',
//             staticData: 'Part 3'),
//       ],
//     ),
//   },
//   schema: validationSchema,
// );
//
// void main() {
//   group('Static Page (kitchen-sink-00)', () {
//     late WidgetTestTree testTree;
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
//       final PScript script = KitchenSinkTest().init(
//         script: kitchenSink00,
//         useCaptionsAsIds: true,
//         appConfig: MockAppConfig(),
//       );
//       // when
//       final widgetTree = MaterialApp(
//           home: PreceptPage(
//         config: script.routes['/test']!, dataConnector: null,
//       ));
//       await tester.pumpWidget(widgetTree);
//       testTree = WidgetTestTree(script, tester.allWidgets.toList());
//       testTree.verify();
//       // then
//       final pageId = 'script00./test';
//       // expect(testTree.elementHasPanelState(pageId), isFalse);
//       expect(testTree.elementHasEditState(pageId), isFalse);
//       expect(
//           testTree.elementHasDataBinding(pageId, PreceptPage, tester), isFalse);
//       expect(
//           testTree.elementHasDataStore(pageId, PreceptPage, tester), isFalse);
//
//       final panel2Id = 'script00./test.Panel 2';
//       expect(testTree.elementHasEditState(panel2Id), isFalse);
//       expect(testTree.elementHasDataBinding(panel2Id, Panel, tester), isFalse);
//       expect(testTree.elementHasDataStore(panel2Id, Panel, tester), isFalse);
//
//       final panel21Id = 'script00./test.Panel 2.Panel 2-1';
//       expect(testTree.elementHasEditState(panel21Id), isFalse);
//       expect(testTree.elementHasDataBinding(panel21Id, Panel, tester), isFalse);
//       expect(testTree.elementHasDataStore(panel21Id, Panel, tester), isFalse);
//
//       final part1Id = 'script00./test.Part 1';
//       expect(testTree.elementHasEditState(part1Id), isFalse);
//       expect(testTree.elementHasDataBinding(part1Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part1Id, Part, tester), isFalse);
//
//       final part3Id = 'script00./test.Part 3';
//       expect(testTree.elementHasEditState(part3Id), isFalse);
//       expect(testTree.elementHasDataBinding(part3Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part3Id, Part, tester), isFalse);
//
//       final part22Id = 'script00./test.Panel 2.Part 2-2';
//       expect(testTree.elementHasEditState(part22Id), isFalse);
//       expect(testTree.elementHasDataBinding(part22Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part22Id, Part, tester), isFalse);
//
//       final part23Id = 'script00./test.Panel 2.Part 2-3';
//       expect(testTree.elementHasEditState(part23Id), isFalse);
//       expect(testTree.elementHasDataBinding(part23Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part23Id, Part, tester), isFalse);
//
//       final part211Id = 'script00./test.Panel 2.Panel 2-1.Part 2-1-1';
//       expect(testTree.elementHasEditState(part211Id), isFalse);
//       expect(testTree.elementHasDataBinding(part211Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part211Id, Part, tester), isFalse);
//
//       final part212Id = 'script00./test.Panel 2.Panel 2-1.Part 2-1-2';
//       expect(testTree.elementHasEditState(part212Id), isFalse);
//       expect(testTree.elementHasDataBinding(part212Id, Part, tester), isFalse);
//       expect(testTree.elementHasDataStore(part212Id, Part, tester), isFalse);
//     });
//   }, skip: true);
// }
