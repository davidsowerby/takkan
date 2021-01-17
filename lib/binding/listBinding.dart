import 'package:flutter/foundation.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/binding/stringBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_script/common/log.dart';

/// [T] is the data type of the list items
class ListBinding<T> extends CollectionBinding<List<T>> {
  const ListBinding.private(
      {@required Binding parent,
      String property,
      int index,
      @required String firstLevelKey,
      TemporaryDocument editHost})
      : super.private(
            parent: parent,
            property: property,
            index: index,
            firstLevelKey: firstLevelKey,
            editHost: editHost);

  @override
  List<T> emptyValue() {
    return List<T>();
  }

  BooleanBinding booleanBinding({String property, @required int index}) {
    assert(index != null);
    return BooleanBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  DoubleBinding doubleBinding({String property, @required int index}) {
    assert(index != null);
    return DoubleBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  // TimestampBinding timestampBinding({String property, @required int index}) {
  //   assert(index != null);
  //   return TimestampBinding.private(
  //       parent: this, index: index, firstLevelKey: this.firstLevelKey ?? property, editHost: this.editHost);
  // }

  IntBinding intBinding({String property, @required int index}) {
    assert(index != null);
    return IntBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  StringBinding stringBinding({String property, @required int index}) {
    assert(index != null);
    return StringBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  TableBinding tableBinding({String property, @required int index}) {
    assert(index != null);
    return TableBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  ListBinding<T> listBinding<T>({String property, @required int index}) {
    assert(index != null);
    return ListBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  ModelBinding modelBinding({String property, @required int index}) {
    assert(index != null);
    return ModelBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  MapBinding<K, V> mapBinding<K, V>({String property, @required int index}) {
    assert(index != null);
    return MapBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  DynamicBinding dynamicBinding({String property, @required int index}) {
    assert(index != null);
    return DynamicBinding.private(
        parent: this,
        index: index,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  /// Reading a list from Firebase can cause some casting issues.  Connecting individual bindings to it - for example,
  /// a StringBinding, works fine, but reading a whole list can be a problem
  List<String> readStringList(
      {List<String> defaultValue, bool allowNullReturn = false}) {
    List readValue;
    if (property != null) {
      readValue = parent.read()[property];
    } else {
      readValue = parent.read()[index];
    }
    if (readValue == null) {
      if (defaultValue == null) {
        return (allowNullReturn) ? null : List<String>();
      } else {
        return defaultValue;
      }
    } else {
      return readValue.map((s) => s.toString()).toList();
    }
  }

  void sortAscending() {
    read().sort();
    editHost.nestedChange(firstLevelKey);
  }

  int count() {
    final List rows = read();
    return rows.length;
  }

  void sortDescending() {
    read().sort();
    parent.read()[property] =
        parent.read()[property].reversed.toList(growable: true);
    editHost.nestedChange(firstLevelKey);
  }

  /// changes the index of an element from [oldIndex] to [newIndex]
  /// throws a [BindingException] if either index is out of bounds
  /// returns -1 if no change is made or [newIndex] if a change is made
  int changeOrder({int oldIndex, int newIndex}) {
    if (oldIndex < 0 || oldIndex >= read().length) {
      logType(this.runtimeType).d("old index=$oldIndex");
      throw BindingException("oldIndex must be within range, it is $oldIndex");
    }
    if (newIndex < 0 || newIndex >= read().length) {
      logType(this.runtimeType)
          .d("new index=$newIndex, list length: ${read().length}");
      throw BindingException("newIndex must be within range, it is $newIndex");
    }
    if (oldIndex == newIndex) {
      return -1;
    } else {
      _doChangeOrder(oldIndex, newIndex);
      editHost.nestedChange(firstLevelKey);
      return newIndex;
    }
  }

  void _doChangeOrder(int oldIndex, int newIndex) {
    final List rows = List.from(read(), growable: true);
    final element = rows.removeAt(oldIndex);
    rows.insert(newIndex, element);
    write(rows);
  }

  /// behaves in the same way as the underlying [List.insertRow], and will throw the same errors
  /// A copy is made of the original list, because it is often not growable.
  void insertRow(int index, dynamic value) {
    List<dynamic> rows = List();
    rows.addAll(parent.read()[property]);
    rows.insert(index, value);
    logType(this.runtimeType)
        .d("inserted new item at index $index in list $property");
    parent.read()[property] = rows;
    editHost.nestedChange(firstLevelKey);
  }

  /// behaves in the same way as the underlying [List.addRow], and will throw the same errors
  /// A copy is made of the original list, because it is often not growable.
  void addRow(dynamic value) {
    List<dynamic> rows = List();
    if ((parent.read()[property] != null)) {
      rows.addAll(parent.read()[property]);
    }
    rows.add(value);
    logType(this.runtimeType).d("added new item list $property");
    parent.read()[property] = rows;
    editHost.nestedChange(firstLevelKey);
  }

  /// New list needs to be created, because by default lists are not growable
  void deleteRow(int index) {
    List<dynamic> rows = List();
    rows.addAll(read());
    if (index >= 0 && index < rows.length) {
      rows.removeAt(index);
      parent.read()[property] = rows;
      editHost.nestedChange(firstLevelKey);
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
    List rows = read();
    if (index == rows.length - 1) return;
    changeOrder(oldIndex: index, newIndex: index + 1);
  }
}

List<T> mergeLists<T>(List<T> list1, List<T> list2) {
  if (list2 != null) {
    list1.addAll(list2);
  }
  return list1;
}
