import 'package:precept/inject/inject.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';
import 'package:test/test.dart';

import '../../helper/listener.dart';
import 'binding_test.dart';

const String property = "table";
const List<Map<String, dynamic>> loadedValue = [
  {"column0": "cell00"}
];
const List<Map<String, dynamic>> defValue = [
  {"default": 49.3}
];
const List<Map<String, dynamic>> updateValue = [
  {"update": true}
];

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
        RootBinding(data: data, editHost: temporaryDocument, id: "test");
    changeListener = ChangeListener();
    temporaryDocument.addListener(changeListener.listenToChange());
  });

  group("TableBinding", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final List<Map<String, dynamic>> actual =
            rootBinding.tableBinding(property: property).read();
        final List<Map<String, dynamic>> expected = loadedValue;
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default settings, value does not exist", () {
        final List<Map<String, dynamic>> actual =
            rootBinding.tableBinding(property: "no item").read();
        final List<Map<String, dynamic>> expected = [];
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test("read with default value, value exists", () {
        List<Map<String, dynamic>> defaultValue = defValue;
        final List<Map<String, dynamic>> expected = loadedValue;
        final List<Map<String, dynamic>> actual = rootBinding
            .tableBinding(property: property)
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default value, value does not exist", () {
        List<Map<String, dynamic>> defaultValue = defValue;
        final List<Map<String, dynamic>> expected = defaultValue;
        final actual = rootBinding
            .tableBinding(property: "no item")
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
          () {
        final List<Map<String, dynamic>> expected = [];
        final actual = rootBinding
            .tableBinding(property: "no item")
            .read(allowNullReturn: false);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
          () {
        final List<Map<String, dynamic>> expected = null;
        final actual = rootBinding
            .tableBinding(property: "no item")
            .read(allowNullReturn: true);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.tableBinding(property: property);
        List<Map<String, dynamic>> expected = updateValue;
        itemBinding.write(expected);
        List<Map<String, dynamic>> result = itemBinding.read();
        expect(result, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 1, reason: "value updated");
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        List<Map<String, dynamic>> expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final TableBinding sb = map.tableBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });

      test("parent list created when needed", () {
        List<Map<String, dynamic>> expected = updateValue;
        final list = rootBinding.listBinding<List<Map<String, dynamic>>>(
            property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final TableBinding sb = list.tableBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating TableBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });
    });
  });
}
