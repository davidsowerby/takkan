import 'package:precept/common/inject.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';
import 'package:test/test.dart';

import '../../helper/listener.dart';
import 'binding_test.dart';

const property = "dynamic";
const loadedValue = "dynamic";
const String defValue = "a default";
const double updateValue = 23.7;

void main() {
  Map<String, dynamic> data;
  TemporaryDocument temporaryDocument;
  RootBinding rootBinding;
  ChangeListener changeListener;

  setUp(() {
    data = generateData();
    getIt.reset();
    getIt.registerFactory<TemporaryDocument>(() => DefaultTemporaryDocument());
    temporaryDocument = injector<TemporaryDocument>();
    rootBinding =
        RootBinding(data: data, editHost: temporaryDocument, id: "test");
    changeListener = ChangeListener();
    temporaryDocument.addListener(changeListener.listenToChange());
  });

  group("DynamicBinding", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final dynamic actual =
            rootBinding.dynamicBinding(property: property).read();
        final dynamic expected = loadedValue;
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default settings, value does not exist", () {
        final dynamic actual =
            rootBinding.dynamicBinding(property: "no item").read();
        final dynamic expected = "";
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test("read with default value, value exists", () {
        dynamic defaultValue = defValue;
        final dynamic expected = loadedValue;
        final dynamic actual = rootBinding
            .dynamicBinding(property: property)
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default value, value does not exist", () {
        dynamic defaultValue = defValue;
        final dynamic expected = defaultValue;
        final actual = rootBinding
            .dynamicBinding(property: "no item")
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
          () {
        final dynamic expected = "";
        final actual = rootBinding
            .dynamicBinding(property: "no item")
            .read(allowNullReturn: false);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is true",
          () {
        final dynamic expected = null;
        final actual = rootBinding
            .dynamicBinding(property: "no item")
            .read(allowNullReturn: true);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "no change is made, just returns null");
      });

      test(
          "read with default value, value does not exist, allowNull is true, createIfAbsent is false",
          () {
        final dynamic expected = 23;
        final actual = rootBinding.dynamicBinding(property: "no item").read(
            defaultValue: 23, allowNullReturn: true, createIfAbsent: false);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "if defaultValue is set, allowNull is ignored");
      });

      test(
          "read with no default value, value does not exist, allowNull is true, createIfAbsent is false",
          () {
        final dynamic expected = null;
        final actual = rootBinding
            .dynamicBinding(property: "no item")
            .read(allowNullReturn: true, createIfAbsent: false);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "no change is made, just returns null");
      });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.dynamicBinding(property: property);
        dynamic expected = updateValue;
        itemBinding.write(expected);
        dynamic result = itemBinding.read();
        expect(result, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 1, reason: "value updated");
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        dynamic expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final DynamicBinding sb = map.dynamicBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });

      test("parent list created when needed", () {
        dynamic expected = updateValue;
        final list = rootBinding.listBinding<dynamic>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final DynamicBinding sb = list.dynamicBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating DynamicBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });
    });
  });
}
