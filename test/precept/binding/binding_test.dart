import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/binding/binding.dart';
import 'package:precept_client/precept/binding/listBinding.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/mutable/temporaryDocument.dart';
import 'package:precept_client/precept/part/string/stringBinding.dart';

import '../../helper/catcher.dart';
import '../../helper/listener.dart';

void main() {
  Map<String, dynamic> data;
  TemporaryDocument temporaryDocument;
  RootBinding rootBinding;
  ChangeListener changeListener;

  setUp(() {
    data = generateData();
    getIt.reset();
    getIt.registerFactory<TemporaryDocument>(() => DefaultTemporaryDocument());
    temporaryDocument = inject<TemporaryDocument>();
    rootBinding =
        RootBinding(id: "-root-", data: data, editHost: temporaryDocument);
    changeListener = ChangeListener();
    temporaryDocument.addListener(changeListener.listenToChange());
  });

  group('Root Binding', () {
    test("when passed a document connects to data", () {
      expect(rootBinding.read(), data);
    });

    test(
        "attempting to write with WriteableRootBinding throws BindingException",
        () {
      expect(() => rootBinding.write({}), throwsBindingException);
    });

    test("editHost returns non null", () {
      expect(rootBinding.editHost, temporaryDocument);
    });

    test("itemBinding returns correct value", () {
      Binding itemBinding = rootBinding.stringBinding(property: "item");
      String result = itemBinding.read();
      expect(result, "item a");
    });

    test("listBinding returns correct values", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      List result = listBinding.read();
      expect(result[0], 7);
      expect(result[1], 93);
    });

    test("tableBinding returns correct value", () {
      TableBinding tableBinding = rootBinding.tableBinding(property: "table");
      List result = tableBinding.read();
      expect(result[0]["column0"], "cell00");
    });
  });

  group("MapBinding", () {
    test("write and read", () {
      final mb = rootBinding.modelBinding(property: "map");
      expect(mb, isNotNull);

      final StringBinding sb = mb.stringBinding(property: "firstName");
      sb.write("Wiggly");
      expect(mb.read(), isNotEmpty);
      expect(sb.read(), "Wiggly");
    });
  });

  group("Pass-down params set correctly", () {
    test("RootBinding creates first level with key set to property name", () {
      Binding itemBinding = rootBinding.stringBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.editHost, temporaryDocument);

      itemBinding = rootBinding.intBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.editHost, temporaryDocument);

      itemBinding = rootBinding.modelBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.editHost, temporaryDocument);

      itemBinding = rootBinding.doubleBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.editHost, temporaryDocument);

      itemBinding = rootBinding.intBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.editHost, temporaryDocument);

      itemBinding = rootBinding.listBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.editHost, temporaryDocument);

      itemBinding = rootBinding.booleanBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.editHost, temporaryDocument);

      itemBinding = rootBinding.tableBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.editHost, temporaryDocument);
    });
  });
}

Future<RootBinding> readDataRoot(StateChangeRecorder recorder) async {
  final db = Firestore.instance;
  DocumentSnapshot documentSnapshot =
      await db.collection("test").document("test data").get();
  return RootBinding(data: documentSnapshot.data, id: "test");
}

class StateChangeRecorder {
  int count = 0;

  void stateChange(Function() function) {
    count++;
    function();
  }
}

class MockDocument extends Mock implements DocumentSnapshot {}

generateData() {
  Map<String, dynamic> data = Map();
  List<int> list = [7, 93];
  List<Map<String, dynamic>> table = List();
  Map<String, dynamic> row0 = {"column0": "cell00"};
  table.add(row0);
  data["item"] = "item a";
  data["dynamic"] = "dynamic";
  data["list"] = list;
  data["table"] = table;
  data["int"] = 23;
  data["double"] = 2.0;
  data["timestamp"] = Timestamp.fromDate(DateTime(2019, 11, 1));
  data["boolean"] = true;
  data["geopoint"] = GeoPoint(23.13, 17.45);
  data["map"] = {"column0": "cell00"};
  return data;
}
