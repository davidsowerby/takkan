import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_script/inject/inject.dart';
import '../helper/listener.dart';
import 'binding_test.dart';

const property = "double";
const double loadedValue = 2.0;
const double defValue = 23.8;
const double updateValue = 199.8;

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
        RootBinding(data: data, editHost: temporaryDocument, id: "test");
    changeListener = ChangeListener();
    temporaryDocument.addListener(changeListener.listenToChange);
  });

  group("DoubleBinding", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final double actual = rootBinding.doubleBinding(property: property).read()!;
        final double expected = loadedValue;
        expect(actual, expected);
      });

      test("read with default settings, value does not exist", () {
        final double actual = rootBinding.doubleBinding(property: "no item").read()!;
        final double expected = 0.0;
        expect(actual, expected);
      });

      test("read with default value, value exists", () {
        double defaultValue = defValue;
        final double expected = loadedValue;
        final double actual =
            rootBinding.doubleBinding(property: property).read(defaultValue: defaultValue)!;
        expect(actual, expected);
      });

      test("read with default value, value does not exist", () {
        double defaultValue = defValue;
        final double expected = defaultValue;
        final actual =
            rootBinding.doubleBinding(property: "no item").read(defaultValue: defaultValue);
        expect(actual, expected);
      });

      test("read with no default value, value does not exist, allowNull is false", () {
        final double expected = 0.0;
        final actual = rootBinding.doubleBinding(property: "no item").read(allowNullReturn: false);
        expect(actual, expected);
      });

      test("read with no default value, value does not exist, allowNull is false", () {
        final double? expected = null;
        final actual = rootBinding.doubleBinding(property: "no item").read(allowNullReturn: true);
        expect(actual, expected);
      });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.doubleBinding(property: property);
        double expected = updateValue;
        itemBinding.write(expected);
        double result = itemBinding.read()!;
        expect(result, expected);
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        double expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final DoubleBinding sb = map.doubleBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
      });

      test("parent list created when needed", () {
        double expected = updateValue;
        final list = rootBinding.listBinding<double>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final DoubleBinding sb = list.doubleBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
      });
    });
  });
}
