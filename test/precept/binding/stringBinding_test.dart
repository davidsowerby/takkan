import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/binding/stringBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:test/test.dart';

import '../../helper/listener.dart';
import 'binding_test.dart';

const property = "item";
const loadedValue = "item a";
const String defValue = "a default";
const String updateValue = "an update";

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

  group("StringBinding", () {
    group("Read", () {
      test("read with default settings, value exists", () {
        final String actual =
        rootBinding.stringBinding(property: property).read();
        final String expected = loadedValue;
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating StringBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default settings, value does not exist", () {
        final String actual =
        rootBinding.stringBinding(property: "no item").read();
        final String expected = "";
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating StringBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test("read with default value, value exists", () {
        String defaultValue = defValue;
        final String expected = loadedValue;
        final String actual = rootBinding
            .stringBinding(property: property)
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating StringBinding adds property");
        expect(temporaryDocument.changeList.length, 0,
            reason: "successful read, no changes made");
      });

      test("read with default value, value does not exist", () {
        String defaultValue = defValue;
        final String expected = defaultValue;
        final actual = rootBinding
            .stringBinding(property: "no item")
            .read(defaultValue: defaultValue);
        expect(actual, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating StringBinding adds property");
        expect(temporaryDocument.changeList.length, 1,
            reason: "default is createIfAbsent=true");
      });

      test(
          "read with no default value, value does not exist, allowNull is false",
              () {
            final String expected = "";
            final actual = rootBinding
                .stringBinding(property: "no item")
                .read(allowNullReturn: false);
            expect(actual, expected);
            expect(changeListener.changeCount, 1,
                reason: "creating StringBinding adds property");
            expect(temporaryDocument.changeList.length, 1,
                reason: "default is createIfAbsent=true");
          });

      test(
          "read with no default value, value does not exist, allowNull is false",
              () {
            final String expected = null;
            final actual = rootBinding
                .stringBinding(property: "no item")
                .read(allowNullReturn: true);
            expect(actual, expected);
            expect(changeListener.changeCount, 1,
                reason: "creating StringBinding adds property");
            expect(temporaryDocument.changeList.length, 0,
                reason: "successful read, no changes made");
          });
    });
    group("Write", () {
      test("updates value correctly", () {
        final itemBinding = rootBinding.stringBinding(property: property);
        String expected = updateValue;
        itemBinding.write(expected);
        String result = itemBinding.read();
        expect(result, expected);
        expect(changeListener.changeCount, 1,
            reason: "creating StringBinding adds property");
        expect(temporaryDocument.changeList.length, 1, reason: "value updated");
      });

      /// Example: property added to map, but map was previously non-existent
      test("parent map created when needed", () {
        String expected = updateValue;
        final map = rootBinding.modelBinding(property: "theMap");
        expect(map.read(allowNullReturn: true), isNull);
        final StringBinding sb = map.stringBinding(property: "mapEntry");
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating StringBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });

      test("parent list created when needed", () {
        String expected = updateValue;
        final list = rootBinding.listBinding<String>(property: "theList");
        expect(list.read(allowNullReturn: true), isNull);
        final StringBinding sb = list.stringBinding(index: 0);
        sb.write(expected);
        expect(sb.read(allowNullReturn: true), expected);
        expect(changeListener.changeCount, 1,
            reason: "creating StringBinding adds property");
        expect(temporaryDocument.changeList.length, 2,
            reason: "value updated, parent created");
      });
    });
  });
}
