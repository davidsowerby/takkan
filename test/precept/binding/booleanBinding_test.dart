import 'package:precept/inject/inject.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';
import 'package:test/test.dart';

import '../../helper/listener.dart';
import 'binding_test.dart';

const String property = "boolean";
const bool loadedValue = true;
const bool defValue = false;
const bool updateValue = false;

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

  group("BooleanBinding", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final bool actual =
            rootBinding.booleanBinding(property: property).read();
        final bool expected = loadedValue;
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default settings, value does not exist", () {
        final bool actual =
            rootBinding.booleanBinding(property: "no item").read();
        final bool expected = false;
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test("read with default value, value exists", () {
        bool defaultValue = defValue;
        final bool expected = loadedValue;
        final bool actual = rootBinding
            .booleanBinding(property: property)
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default value, value does not exist", () {
        bool defaultValue = defValue;
        final bool expected = defaultValue;
        final actual = rootBinding
            .booleanBinding(property: "no item")
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
          () {
        final bool expected = false;
        final actual = rootBinding
            .booleanBinding(property: "no item")
            .read(allowNullReturn: false);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
          () {
        final bool expected = null;
        final actual = rootBinding
            .booleanBinding(property: "no item")
            .read(allowNullReturn: true);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.booleanBinding(property: property);
        bool expected = updateValue;
        itemBinding.write(expected);
        bool result = itemBinding.read();
        expect(result, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 1, reason: "value updated");
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        bool expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final BooleanBinding sb = map.booleanBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });

      test("parent list created when needed", () {
        bool expected = updateValue;
        final list = rootBinding.listBinding<bool>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final BooleanBinding sb = list.booleanBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating BooleanBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });
    });
  });
}
