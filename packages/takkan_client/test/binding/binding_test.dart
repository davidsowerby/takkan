import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/binding/list_binding.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/binding/string_binding.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_script/inject/inject.dart';

import '../helper/catcher.dart';
import '../helper/listener.dart';

void main() {
  late Map<String, dynamic> data;
  late MutableDocument temporaryDocument;
  late RootBinding rootBinding;
  late ChangeListener changeListener;

  setUp(() {
    data = generateData();
    getIt.reset();
    temporaryDocument = MutableDocument();
    rootBinding = RootBinding(
        id: "-root-", data: data, getEditHost: () => temporaryDocument);
    changeListener = ChangeListener();
    temporaryDocument.addListener(changeListener.listenToChange);
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
      expect(rootBinding.getEditHost(), temporaryDocument);
    });

    test("itemBinding returns correct value", () {
      Binding itemBinding = rootBinding.stringBinding(property: "item");
      String result = itemBinding.read();
      expect(result, "item a");
    });

    test("listBinding returns correct values", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      List result = listBinding.read()!;
      expect(result[0], 7);
      expect(result[1], 93);
    });

    test("tableBinding returns correct value", () {
      TableBinding tableBinding = rootBinding.tableBinding(property: "table");
      List result = tableBinding.read()!;
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

      expect(changeListener.changeCount, 1);
    });
  });

  group("Pass-down params set correctly", () {
    test("RootBinding creates first level with key set to property name", () {
      Binding itemBinding = rootBinding.stringBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.getEditHost(), temporaryDocument);

      itemBinding = rootBinding.intBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.getEditHost(), temporaryDocument);

      itemBinding = rootBinding.modelBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.getEditHost(), temporaryDocument);

      itemBinding = rootBinding.doubleBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.getEditHost(), temporaryDocument);

      itemBinding = rootBinding.intBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.getEditHost(), temporaryDocument);

      itemBinding = rootBinding.listBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.getEditHost(), temporaryDocument);

      itemBinding = rootBinding.booleanBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.getEditHost(), temporaryDocument);

      itemBinding = rootBinding.tableBinding(property: "item");
      expect(itemBinding.property, "item");
      expect(itemBinding.firstLevelKey, "item");
      expect(itemBinding.getEditHost(), temporaryDocument);
    });
  });
}

class StateChangeRecorder {
  int count = 0;

  void stateChange(Function() function) {
    count++;
    function();
  }
}

// class MockDocument extends Mock implements DocumentSnapshot {}
//
generateData() {
  Map<String, dynamic> data = Map();
  List<int> list = [7, 93];
  List<Map<String, dynamic>> table = List.empty(growable: true);
  Map<String, dynamic> row0 = {"column0": "cell00"};
  table.add(row0);
  data["item"] = "item a";
  data["dynamic"] = "dynamic";
  data["list"] = list;
  data["table"] = table;
  data["int"] = 23;
  data["double"] = 2.0;
  data["timestamp"] = DateTime(2019, 11, 1);
  data["boolean"] = true;
  data["map"] = {"column0": "cell00"};
  return data;
}
