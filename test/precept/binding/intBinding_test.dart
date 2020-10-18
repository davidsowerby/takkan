import 'package:precept/inject/inject.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';
import 'package:test/test.dart';

import '../../helper/listener.dart';
import 'binding_test.dart';

const String property = "int";
const int loadedValue = 23;
const int defValue = 99;
const int updateValue = 437;

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

  group("IntBinding", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final int actual = rootBinding.intBinding(property: property).read();
        final int expected = loadedValue;
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default settings, value does not exist", () {
        final int actual = rootBinding.intBinding(property: "no item").read();
        final int expected = 0;
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test("read with default value, value exists", () {
        int defaultValue = defValue;
        final int expected = loadedValue;
        final int actual = rootBinding
            .intBinding(property: property)
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default value, value does not exist", () {
        int defaultValue = defValue;
        final int expected = defaultValue;
        final actual = rootBinding
            .intBinding(property: "no item")
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
          () {
        final int expected = 0;
        final actual = rootBinding
            .intBinding(property: "no item")
            .read(allowNullReturn: false);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
          () {
        final int expected = null;
        final actual = rootBinding
            .intBinding(property: "no item")
            .read(allowNullReturn: true);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.intBinding(property: property);
        int expected = updateValue;
        itemBinding.write(expected);
        int result = itemBinding.read();
        expect(result, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 1, reason: "value updated");
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        int expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final IntBinding sb = map.intBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });

      test("parent list created when needed", () {
        int expected = updateValue;
        final list = rootBinding.listBinding<int>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final IntBinding sb = list.intBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating IntBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });
    });
  });
}
