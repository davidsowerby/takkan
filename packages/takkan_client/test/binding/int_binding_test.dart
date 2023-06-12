import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_script/inject/inject.dart';

import '../helper/listener.dart';
import 'binding_test.dart';

const String property = "int";
const int loadedValue = 23;
const int defValue = 99;
const int updateValue = 437;

void main() {
  late Map<String, dynamic> data;
  late MutableDocument temporaryDocument;
  late RootBinding rootBinding;
  late ChangeListener changeListener;

  setUp(() {
    data = generateData();
    getIt.reset();
    temporaryDocument = MutableDocument();
    rootBinding =
        RootBinding(data: data, getEditHost: ()=>temporaryDocument, id: "test");
    changeListener = ChangeListener();
    temporaryDocument.addListener(changeListener.listenToChange);
  });

  group("IntBinding", () {
    group("Read", () {
      test("read with default settings, property exists", () {
        final int actual = rootBinding.intBinding(property: property).read()!;
        final int expected = loadedValue;
        expect(actual, expected);
      });

      test("read with default settings, value does not exist", () {
        final int actual = rootBinding.intBinding(property: "no item").read()!;
        final int expected = 0;
        expect(actual, expected);
      });

      test("read with default value, value exists", () {
        int defaultValue = defValue;
        final int expected = loadedValue;
        final int actual =
            rootBinding.intBinding(property: property).read(defaultValue: defaultValue)!;
        expect(actual, expected);
      });

      test("read with default value, value does not exist", () {
        int defaultValue = defValue;
        final int expected = defaultValue;
        final actual = rootBinding.intBinding(property: "no item").read(defaultValue: defaultValue);
        expect(actual, expected);
      });

      test("read with no default value, value does not exist, allowNull is false", () {
        final int expected = 0;
        final actual = rootBinding.intBinding(property: "no item").read(allowNullReturn: false);
        expect(actual, expected);
      });

      test("read with no default value, value does not exist, allowNull is true", () {
        final int? expected = null;
        final actual = rootBinding.intBinding(property: "no item").read(allowNullReturn: true);
        expect(actual, expected);
      });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.intBinding(property: property);
        int expected = updateValue;
        itemBinding.write(expected);
        int result = itemBinding.read()!;
        expect(result, expected);
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        int expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final IntBinding sb = map.intBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
      });

      test("parent list created when needed", () {
        int expected = updateValue;
        final list = rootBinding.listBinding<int>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final IntBinding sb = list.intBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
      });
    });
  });
}
