import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/data/binding/list_binding.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_script/inject/inject.dart';

import '../helper/catcher.dart';
import 'binding_test.dart';

void main() {
  late Map<String, dynamic> data;
  late MutableDocument temporaryDocument;
  late RootBinding rootBinding;

  setUp(() {
    data = generateData();
    getIt.reset();
    temporaryDocument = MutableDocument();
    rootBinding =
        RootBinding(data: data, editHost: temporaryDocument, id: "test");
  });

  group("ListBinding", () {
    test("updates value correctly", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      List update = ["c", "d"];
      listBinding.write(update);
      List? result = listBinding.read();
      expect(result, update);
    });

    test("sorts descending", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["c", "d", "e"]);
      listBinding.sortDescending();
      List? result = listBinding.read();
      expect(result, ["e", "d", "c"]);
    });

    test("sorts ascending", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      listBinding.sortAscending();
      List? result = listBinding.read();
      expect(result, ["c", "d", "e"]);
    });

    test("changing order with valid parameters", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      int returnedOrder = listBinding.changeOrder(oldIndex: 0, newIndex: 2);
      List? result = listBinding.read();
      expect(result, ["e", "c", "d"]);
      expect(returnedOrder, 2);
    });

    test("changing order with target==source, does nothing", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      int returnedOrder = listBinding.changeOrder(oldIndex: 1, newIndex: 1);
      List? result = listBinding.read();
      expect(result, ["d", "e", "c"]);
      expect(returnedOrder, -1);
    });

    test("changing order with target index <0", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      expect(() => listBinding.changeOrder(oldIndex: 1, newIndex: -1),
          throwsBindingException);
    });

    test("changing order with target index > list length", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      expect(() => listBinding.changeOrder(oldIndex: 1, newIndex: 3),
          throwsBindingException);
    });

    test("changing order with source index < 0", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      expect(() => listBinding.changeOrder(oldIndex: -1, newIndex: 3),
          throwsBindingException);
    });

    test("changing order with source index > list length", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      expect(() => listBinding.changeOrder(oldIndex: 3, newIndex: 1),
          throwsBindingException);
    });

    test("insert row with valid parameter", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      listBinding.insertRow(0, "a");
      List? actual = listBinding.read();
      expect(actual, ["a", "d", "e", "c"]);
    });

    test("insert row with target index < 0", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      expect(() => listBinding.insertRow(-1, "a"), throwsRangeError);
    });

    test("insert row with index out of bounds throws range error", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);

      expect(() => listBinding.insertRow(-1, "a"), throwsRangeError);
      expect(() => listBinding.insertRow(4, "a"), throwsRangeError);
    });

    test("promote row with valid index", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      listBinding.promote(1);
      List? actual = listBinding.read();
      expect(actual, ["e", "d", "c"]);
    });

    test("promote row with index==0, should do nothing", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      listBinding.promote(0);
      List? actual = listBinding.read();
      expect(actual, ["d", "e", "c"]);
    });

    test("promote row with index<0", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      listBinding.promote(-1);
      List? actual = listBinding.read();
      expect(actual, ["d", "e", "c"]);
    });

    test("promote row with index out of range (high)", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      expect(() => listBinding.promote(3), throwsBindingException);
    });

    test("demote row with valid index", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      listBinding.demote(1);
      List? actual = listBinding.read();
      expect(actual, ["d", "c", "e"]);
    });

    test("demote row with index == max range", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      listBinding.demote(2);
      List? actual = listBinding.read();
      expect(actual, ["d", "e", "c"]);
    });

    test("demote row with index > max range", () {
      ListBinding listBinding = rootBinding.listBinding(property: "list");
      listBinding.write(["d", "e", "c"]);
      expect(() => listBinding.demote(3), throwsBindingException);
    });
  });
}
