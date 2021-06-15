import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/binding/listBinding.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_script/inject/inject.dart';

import '../../helper/listener.dart';
import 'binding_test.dart';

const property = "list";
const List<int> loadedValue = [7, 93];
const List<int> defValue = [1, 13];
const List<int> updateValue = [12, 45];

void main() {
  late Map<String, dynamic> data;
  late MutableDocument temporaryDocument;
  late RootBinding rootBinding;
  late ChangeListener changeListener;

  setUp(() {
    data = generateData();
    getIt.reset();
    getIt.registerFactory<MutableDocument>(() => DefaultMutableDocument());
    temporaryDocument = inject<MutableDocument>();
    rootBinding = RootBinding(data: data, editHost: temporaryDocument, id: "test");
    changeListener = ChangeListener();
    temporaryDocument.addListener(changeListener.listenToChange);
  });

  group("ListBinding<int>", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final List<int> actual = rootBinding.listBinding<int>(property: property).read()!;
        final List<int> expected = loadedValue;
        expect(actual, expected);
      });

      test("read with default settings, value does not exist", () {
        final List<int> actual = rootBinding.listBinding<int>(property: "no item").read()!;
        final List<int> expected = [];
        expect(actual, expected);
      });

      test("read with default value, value exists", () {
        List<int> defaultValue = defValue;
        final List<int> expected = loadedValue;
        final List<int> actual =
            rootBinding.listBinding<int>(property: property).read(defaultValue: defaultValue)!;
        expect(actual, expected);
      });

      test("read with default value, value does not exist", () {
        List<int> defaultValue = defValue;
        final List<int> expected = defaultValue;
        final actual =
            rootBinding.listBinding<int>(property: "no item").read(defaultValue: defaultValue);
        expect(actual, expected);
      });

      test("read with no default value, value does not exist, allowNull is false", () {
        final List<int> expected = [];
        final actual =
            rootBinding.listBinding<int>(property: "no item").read(allowNullReturn: false);
        expect(actual, expected);
      });

      test("read with no default value, value does not exist, allowNull is false", () {
        final List<int>? expected = null;
        final actual =
            rootBinding.listBinding<int>(property: "no item").read(allowNullReturn: true);
        expect(actual, expected);
      });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.listBinding<int>(property: property);
        List<int> expected = updateValue;
        itemBinding.write(expected);
        List<int> result = itemBinding.read()!;
        expect(result, expected);
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        List<int> expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final ListBinding<int> sb = map.listBinding<int>(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
      });

      test("parent list created when needed", () {
        List<int> expected = updateValue;
        final list = rootBinding.listBinding<List<int>>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final ListBinding<int> sb = list.listBinding<int>(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
      });
    });
  });
}
