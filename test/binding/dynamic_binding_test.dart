import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_script/inject/inject.dart';

import '../helper/listener.dart';
import 'binding_test.dart';

const property = "dynamic";
const loadedValue = "dynamic";
const String defValue = "a default";
const double updateValue = 23.7;

void main() {
  late  Map<String, dynamic> data;
  late  MutableDocument temporaryDocument;
  late   RootBinding rootBinding;
  late  ChangeListener changeListener;

  setUp(() {
    data = generateData();
    getIt.reset();
    temporaryDocument = MutableDocument();
    rootBinding =
        RootBinding(data: data, editHost: temporaryDocument, id: "test");
    changeListener = ChangeListener();
    temporaryDocument.addListener(changeListener.listenToChange);
  });

  group("DynamicBinding", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final dynamic actual =
        rootBinding.dynamicBinding(property: property).read();
        final dynamic expected = loadedValue;
        expect(actual, expected);
      });

      test("read with default settings, value does not exist", () {
        final dynamic actual =
        rootBinding.dynamicBinding(property: "no item").read();
        final dynamic expected = "";
        expect(actual, expected);
      });

      test("read with default value, value exists", () {
        dynamic defaultValue = defValue;
        final dynamic expected = loadedValue;
        final dynamic actual = rootBinding
            .dynamicBinding(property: property)
            .read(defaultValue: defaultValue);
        expect(actual, expected);
      });

      test("read with default value, value does not exist", () {
        dynamic defaultValue = defValue;
        final dynamic expected = defaultValue;
        final actual = rootBinding
            .dynamicBinding(property: "no item")
            .read(defaultValue: defaultValue);
        expect(actual, expected);
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
              () {
            final dynamic expected = "";
            final actual = rootBinding
                .dynamicBinding(property: "no item")
                .read(allowNullReturn: false);
            expect(actual, expected);
      });

      test(
          "read with no default value, value does not exist, allowNull is true",
              () {
            final dynamic expected = null;
            final actual = rootBinding
                .dynamicBinding(property: "no item")
                .read(allowNullReturn: true);
            expect(actual, expected);
      });

      test(
          "read with default value, value does not exist, allowNull is true, createIfAbsent is false",
              () {
            final dynamic expected = 23;
            final actual = rootBinding.dynamicBinding(property: "no item").read(
                defaultValue: 23, allowNullReturn: true, createIfAbsent: false);
            expect(actual, expected);
      });

      test(
          "read with no default value, value does not exist, allowNull is true, createIfAbsent is false",
              () {
            final dynamic expected = null;
            final actual = rootBinding
                .dynamicBinding(property: "no item")
                .read(allowNullReturn: true, createIfAbsent: false);
            expect(actual, expected);
      });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.dynamicBinding(property: property);
        dynamic expected = updateValue;
        itemBinding.write(expected);
        dynamic result = itemBinding.read();
        expect(result, expected);
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        dynamic expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final DynamicBinding sb = map.dynamicBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
      });

      test("parent list created when needed", () {
        dynamic expected = updateValue;
        final list = rootBinding.listBinding<dynamic>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final DynamicBinding sb = list.dynamicBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
      });
    });
  });
}
