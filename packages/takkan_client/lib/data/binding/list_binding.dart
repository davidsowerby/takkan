import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/binding/string_binding.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/script/constants.dart';

/// [T] is the data type of the list items
class ListBinding<T> extends CollectionBinding<List<T>> {
  const ListBinding.private({
    CollectionBinding? parent,
    String property = notSet,
    int index = Binding.noValue,
    required String firstLevelKey,
    required super.getEditHost,
  }) : super.private(
          parent: parent,
          property: property,
          index: index,
          firstLevelKey: firstLevelKey,
        );

  @override
  List<T> emptyValue() {
    return List<T>.empty(growable: true);
  }

  BooleanBinding booleanBinding({required int index}) {
    return BooleanBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost
    );
  }

  DoubleBinding doubleBinding({required int index}) {
    return DoubleBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  // TimestampBinding timestampBinding({required int index}) {
  //   assert(index != null);
  //   return TimestampBinding.private(
  //       parent: this, index: index, firstLevelKey: this.firstLevelKey ?? property, getEditHost: this.editHost);
  // }

  IntBinding intBinding({required int index}) {
    return IntBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  StringBinding stringBinding({required int index}) {
    return StringBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  TableBinding tableBinding({required int index}) {
    return TableBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  ListBinding<T> listBinding<T>({required int index}) {
    return ListBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  ModelBinding modelBinding({required int index}) {
    return ModelBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  MapBinding<K, V> mapBinding<K, V>({required int index}) {
    return MapBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  DynamicBinding dynamicBinding({required int index}) {
    return DynamicBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  /// Reading a list from Firebase can cause some casting issues.  Connecting individual bindings to it - for example,
  /// a StringBinding, works fine, but reading a whole list can be a problem
  List<String>? readStringList(
      {List<String>? defaultValue, bool allowNullReturn = false}) {
    List? readValue;
    // if (property != null) {
    readValue = parent?.read()[property];
    // } else {
    //   readValue = parent?.read()[index];
    // }
    if (readValue == null) {
      if (defaultValue == null) {
        return (allowNullReturn) ? null : List<String>.empty(growable: true);
      } else {
        return defaultValue;
      }
    } else {
      return readValue.map((s) => s.toString()).toList();
    }
  }

  void sortAscending() {
    read()?.sort();
    final editHost=getEditHost();
    if (editHost!=null) {
      editHost.nestedChange(firstLevelKey);
    }
  }

  int count() {
    final List? rows = read();
    return (rows == null) ? 0 : rows.length;
  }

  void sortDescending() {
    read()?.sort();
    parent?.read()[property] =
        parent?.read()[property].reversed.toList(growable: true);
    final editHost=getEditHost();
    if (editHost!=null) {
      editHost.nestedChange(firstLevelKey);
    }
  }

  /// changes the index of an element from [oldIndex] to [newIndex]
  /// throws a [BindingException] if either index is out of bounds
  /// returns -1 if no change is made or [newIndex] if a change is made
  int changeOrder({required int oldIndex, required int newIndex}) {
    final readValue = read();
    int readLength = (readValue == null) ? 0 : readValue.length;
    if (oldIndex < 0 || oldIndex >= readLength) {
      logType(this.runtimeType).d("old index=$oldIndex");
      throw BindingException("oldIndex must be within range, it is $oldIndex");
    }
    if (newIndex < 0 || newIndex >= readLength) {
      logType(this.runtimeType)
          .d("new index=$newIndex, list length: $readLength");
      throw BindingException("newIndex must be within range, it is $newIndex");
    }
    if (oldIndex == newIndex) {
      return -1;
    } else {
      _doChangeOrder(oldIndex, newIndex);
      final editHost=getEditHost();
      if (editHost!=null) {
        editHost.nestedChange(firstLevelKey);
      }
      return newIndex;
    }
  }

  void _doChangeOrder(int oldIndex, int newIndex) {
    final List<T>? readValue = read();
    if (readValue == null) return;
    final List<T> rows = List.from(readValue, growable: true);
    final element = rows.removeAt(oldIndex);
    rows.insert(newIndex, element);
    write(rows);
  }

  /// behaves in the same way as the underlying [List.insertRow], and will throw the same errors
  /// A copy is made of the original list, because it is often not growable.
  void insertRow(int index, dynamic value) {
    List<dynamic> rows = List.empty(growable: true);
    rows.addAll(parent?.read()[property]);
    rows.insert(index, value);
    logType(this.runtimeType)
        .d("inserted new item at index $index in list $property");
    parent?.read()[property] = rows;
    final editHost=getEditHost();
    if (editHost!=null) {
      editHost.nestedChange(firstLevelKey);
    }
  }

  /// behaves in the same way as the underlying [List.addRow], and will throw the same errors
  /// A copy is made of the original list, because it is often not growable.
  void addRow(dynamic value) {
    List<dynamic> rows = List.empty(growable: true);
    if ((parent?.read()[property] != null)) {
      rows.addAll(parent?.read()[property]);
    }
    rows.add(value);
    logType(this.runtimeType).d("added new item list $property");
    parent?.read()[property] = rows;
    final editHost=getEditHost();
    if (editHost!=null) {
      editHost.nestedChange(firstLevelKey);
    }
  }

  /// New list needs to be created, because by default lists are not growable
  void deleteRow(int index) {
    List<dynamic> rows = List.empty(growable: true);
    final List<dynamic>? readValue = read();
    if (readValue != null) rows.addAll(readValue);
    if (index >= 0 && index < rows.length) {
      rows.removeAt(index);
      parent?.read()[property] = rows;
      final editHost=getEditHost();
      if (editHost!=null) {
        editHost.nestedChange(firstLevelKey);
      }
    } else {
      logType(this.runtimeType)
          .d("Index $index is out of range, cannot be deleted");
    }
  }

  /// push a row up (towards 0).  If already at 0, this call is just ignored
  void promote(int index) {
    if (index <= 0) return;
    changeOrder(oldIndex: index, newIndex: index - 1);
  }

  /// push a row down (away from 0).  If already at the end of the list, this call is just ignored
  /// if the index is out of bounds (high) a [BindingException] is thrown

  void demote(int index) {
    List? rows = read();
    if (rows != null) {
      if (index == rows.length - 1) return;
      changeOrder(oldIndex: index, newIndex: index + 1);
    }
  }
}
