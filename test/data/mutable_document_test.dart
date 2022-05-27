import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/inject/inject.dart';

import '../helper/listener.dart';

void main() {
  late MutableDocument tdoc;
  late ChangeListener listener;
  late StreamMonitor monitor;

  setUp(() {
    getIt.reset();
    tdoc = MutableDocument();
    listener = ChangeListener();
    tdoc.addListener(listener.listenToChange);
    monitor = StreamMonitor(tdoc.stream);
  });

  group("data changes correctly and fires listeners and stream", () {
    group("changes to first level keys", () {
      test(
          "add, change, remove, clear. Output, changes & changeList tracks changes, initial data unchanged",
          () async {
        tdoc.createNew(initialData: {"item1": 3});
        expect(tdoc.initialData["item1"], 3);
        expect(listener.changeCount, 1);
        expect(tdoc.output['item1'], 3);

        tdoc["item1"] = 23;
        expect(tdoc["item1"], 23);
        expect(listener.changeCount, 2);
        expect(tdoc.changeList, hasLength(1));
        expect(tdoc.changeList[0].type, ChangeType.update);
        expect(tdoc.changeList[0].key, "item1");
        expect(tdoc.changes["item1"], 23);
        expect(tdoc.initialData["item1"], 3);

        tdoc["item2"] = 24;
        expect(listener.changeCount, 3);
        expect(tdoc.changes["item2"], 24);
        tdoc["item1"] = 25;
        expect(listener.changeCount, 4);
        expect(tdoc["item1"], 25);
        expect(tdoc.changes["item1"], 25);
        tdoc.remove("item1");
        expect(listener.changeCount, 5);
        expect(tdoc["item1"], null);
        expect(tdoc.changes["item1"], null);
        expect(tdoc.keys.length, 1);
        expect(tdoc.keys, contains("item2"));

        tdoc.reset();
        expect(listener.changeCount, 6);
        expect(tdoc.output, tdoc.initialData);
        expect(tdoc.changes.isEmpty, true);
        expect(tdoc.changeList.isEmpty, true);

        await Future.delayed(Duration(milliseconds: 500));
        expect(monitor.eventCount, listener.changeCount);
        expect(monitor.events, [
          {'item1': 3},
          {'item1': 23},
          {'item1': 23, 'item2': 24},
          {'item1': 25, 'item2': 24},
          {'item2': 24},
          {'item1': 3}
        ]);
        print(monitor.events);
      });
    });
    group("changes to deeper keys", () {
      test("add a map and manipulate its values", () {
        final Map<String, dynamic> level2 = {"level2": "I am"};
        tdoc["item1"] = level2;
        expect(listener.changeCount, 1);

        final item1Binding = tdoc.rootBinding.modelBinding(property: "item1");
        final item11Binding = item1Binding.intBinding(property: "item11");
        item11Binding.write(23);
        expect(tdoc["item1"]["item11"], 23);
        expect(listener.changeCount, 2);
      });
    });
    group("using binding on first level", () {
      test("fires only one change event", () {
        final stringBinding =
            tdoc.rootBinding.stringBinding(property: "First level");
        stringBinding.write("something");
        expect(listener.changeCount, 1);
        expect(tdoc.changeList[0].type, ChangeType.update);
        expect(tdoc.changeList[0].key, "First level");
        stringBinding.write("something else");
        expect(listener.changeCount, 2);
      });
    });
  });
  group("updating source", () {
    test("changes are maintained after source updated", () {
      // given
      Map<String, dynamic> originalSource = {
        "item1": "original1",
        "item2": "original2",
        "item3": "original3",
        "item4": "original4"
      };

      // when
      tdoc.updateFromSource(
          source: originalSource,
          documentId: DocumentId(documentClass: '', objectId: 'x'));

      // then
      expect(tdoc.initialData, originalSource);

      // given
      final item1 = tdoc.rootBinding.stringBinding(property: "item1");
      final item2 = tdoc.rootBinding.stringBinding(property: "item2");
      final item3 = tdoc.rootBinding.stringBinding(property: "item3");
      final item4 = tdoc.rootBinding.stringBinding(property: "item4");

      item1.write("localupdated1");
      item2.write("localupdated2");

      Map<String, dynamic> updatedSource = {
        "item1": "original1",
        "item2": "remoteupdated2",
        "item3": "remoteupdated3",
        "item4": "original4"
      };

      // when
      tdoc.updateFromSource(
          source: updatedSource,
          documentId: DocumentId(documentClass: '', objectId: 'x'));

      // then
      expect(item1.read(), "localupdated1");
      expect(item2.read(), "localupdated2");
      expect(item3.read(), "remoteupdated3");
      expect(item4.read(), "original4");
      expect(tdoc.initialData, updatedSource);
    });
  });
}

// group("Saving and updating, using model to ensure response to deep changes",
//     () {
//   DocumentSnapshot documentSnapshot =
//       MockDocumentSnapshot(); // TODO should not be using backend specific entity
//   when(documentSnapshot.data).thenReturn(testData1());
//
//   setUp(() {
//     getIt.reset();
//     getIt.registerFactory<MutableDocument>(() => DefaultMutableDocument());
//     getIt.registerFactory<Toast>(() => MockToast());
//     tdoc = inject<MutableDocument>();
//   });

//   test(
//       "saving with changesOnly=false, saves all, no documentId uses existing",
//       () async {
//     // given
//     final backend = Backend();
//     //when
//
//     model.peek();
//     model.setItem1("item1 amended");
//     model.list1.insertRow(2, 12);
//     model.list1.deleteRow(0);
//     model.map1.intBinding(property: "mapitem2").write(999);
//     //then
//     await backend.save(
//         saveChangesOnly: false,
//         documentType: DocumentType.standard,
//         data: model.temporaryDocument);
//     //expect
//     final data = mockBackendDelegate.store;
//     expect(data["item1"], "item1 amended");
//     expect(data["list1"], [2, 12, 3, 4]);
//     expect(data["item2"], 444);
//     expect(data["map1"]["mapitem2"], 999);
//   });
//   });
// }

// Map<String, dynamic> testData1() {
//   return {
//     "className": "TestClass",
//     "objectId": "anObject",
//     "item1": "item1",
//     "list1": [1, 2, 3, 4],
//     "map1": {"map1item1": "map1item1", "map1item2": 399},
//     "item2": 444,
//   };
// }

class StreamMonitor {
  final Stream<Map<String, dynamic>> stream;
  List<Map<String, dynamic>> events = List.empty(growable: true);
  int eventCount = 0;

  StreamMonitor(this.stream) {
    stream.forEach((element) {
      eventCount++;
      events.add(element);
      print('stream event: $eventCount, data: $element');
    });
  }
}
