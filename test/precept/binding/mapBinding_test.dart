import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:test/test.dart';

import '../../helper/listener.dart';
import 'binding_test.dart';

const property = "map";
const Map<String, dynamic> loadedValue = {"column0": "cell00"};
const Map<String, dynamic> defValue = {"default": "value"};
const Map<String, dynamic> updateValue = {"updated": "with new value"};

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

  group("MapBinding<String,dynamic>", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final Map<String, dynamic> actual =
        rootBinding.modelBinding(property: property).read();
        final Map<String, dynamic> expected = loadedValue;
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating MapBinding<String,dynamic> adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default settings, value does not exist", () {
        final Map<String, dynamic> actual =
        rootBinding.modelBinding(property: "no item").read();
        final Map<String, dynamic> expected = {};
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating MapBinding<String,dynamic> adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test("read with default value, value exists", () {
        Map<String, dynamic> defaultValue = defValue;
        final Map<String, dynamic> expected = loadedValue;
        final Map<String, dynamic> actual = rootBinding
            .modelBinding(property: property)
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating MapBinding<String,dynamic> adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default value, value does not exist", () {
        Map<String, dynamic> defaultValue = defValue;
        final Map<String, dynamic> expected = defaultValue;
        final actual = rootBinding
            .modelBinding(property: "no item")
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating MapBinding<String,dynamic> adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
              () {
            final Map<String, dynamic> expected = {};
            final actual = rootBinding
                .modelBinding(property: "no item")
                .read(allowNullReturn: false);
            expect(actual, expected);
            expect(changeListener.changeCount, 1,
                reason: "creating MapBinding<String,dynamic> adds property");
            expect(temporaryDocument.changeList.length, 1,
                reason: "default is createIfAbsent=true");
          });

      test(
          "read with no default value, value does not exist, allowNull is false",
              () {
            final Map<String, dynamic> expected = null;
            final actual = rootBinding
                .modelBinding(property: "no item")
                .read(allowNullReturn: true);
            expect(actual, expected);
            expect(changeListener.changeCount, 1,
                reason: "creating MapBinding<String,dynamic> adds property");
            expect(temporaryDocument.changeList.length, 0,
                reason: "successful read, no changes made");
          });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.modelBinding(property: property);
        Map<String, dynamic> expected = updateValue;
        itemBinding.write(expected);
        Map<String, dynamic> result = itemBinding.read();
        expect(result, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating MapBinding<String,dynamic> adds property");
        expect(temporaryDocument.changeList.length, 1, reason: "value updated");
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        Map<String, dynamic> expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final MapBinding<String, dynamic> sb =
        map.modelBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating MapBinding<String,dynamic> adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });

      test("parent list created when needed", () {
        Map<String, dynamic> expected = updateValue;
        final list =
        rootBinding.listBinding<Map<String, dynamic>>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final MapBinding<String, dynamic> sb = list.modelBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating MapBinding<String,dynamic> adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });
    });
  });
}
