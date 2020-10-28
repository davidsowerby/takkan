import 'package:flutter/foundation.dart';
import 'package:precept/common/exceptions.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/listBinding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';
import 'package:precept/precept/part/string/stringBinding.dart';

class MapBinding<K, V> extends CollectionBinding<Map<K, V>> {
  const MapBinding.private(
      {@required CollectionBinding parent,
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

  BooleanBinding booleanBinding({@required String property, int index}) {
    assert(property != null);
    return BooleanBinding.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  DoubleBinding doubleBinding({@required String property, int index}) {
    assert(property != null);
    return DoubleBinding.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  IntBinding intBinding({@required String property, int index}) {
    assert(property != null);
    return IntBinding.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  StringBinding stringBinding({@required String property, int index}) {
    assert(property != null);
    return StringBinding.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  TableBinding tableBinding({@required String property, int index}) {
    assert(property != null);
    return TableBinding.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  ListBinding<T> listBinding<T>({@required String property, int index}) {
    assert(property != null);
    return ListBinding.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  ModelBinding modelBinding({@required String property, int index}) {
    assert(property != null);
    return ModelBinding.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  MapBinding<K, V> mapBinding<K, V>({@required String property, int index}) {
    assert(property != null);
    return MapBinding<K, V>.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  DynamicBinding dynamicBinding({@required String property, int index}) {
    assert(property != null);
    return DynamicBinding.private(
        parent: this,
        property: property,
        firstLevelKey: this.firstLevelKey ?? property,
        editHost: this.editHost);
  }

  // TimestampBinding timestampBinding({@required String property, int index}) {
  //   assert(property != null);
  //   return TimestampBinding.private(
  //       parent: this, property: property, firstLevelKey: this.firstLevelKey ?? property, editHost: this.editHost);
  // }

  @override
  Map<K, V> emptyValue() {
    return Map<K, V>();
  }

  /// returns the values of  the map, effectively ignoring the keys
  List toList() {
    throw NYIException();
  }
}

/// Binds to [data], which is typically either from a [TemporaryDocument] for editing, or from a [DocumentSnapshot] in a read only situation.
/// If data is to be written back to a [TemporaryDocument], [editHost] must not be null.
/// Bindings can then make the [TemporaryDocument] aware of changes at level below that of the first level keys.
/// [id] is primarily used for debugging, to ensure bindings are associated with the correct source
/// [createIfAbsent] will create a value if not present, but only if [editHost] is not null (because a null [editHost] indicates a read only binding)
class RootBinding extends ModelBinding {
  final Map<String, dynamic> data;
  final String id;
  final instance = DateTime.now();

  RootBinding(
      {@required this.data, TemporaryDocument editHost, @required this.id})
      : super.private(
            editHost: editHost,
            property: "-root-",
            firstLevelKey: null,
            parent: null);

  @override
  Map<String, dynamic> read(
      {Map<String, dynamic> defaultValue,
      bool allowNullReturn = false,
      bool createIfAbsent = true}) {
    return data;
  }

  /// Does not write at the root level - writing is done by lower level bindings
  /// The data represented by the root binding just captures data changes
  @override
  write(value) {
    throw BindingException("Root level binding should not call write directly");
  }

  @override
  updateDocument() {
    throw NYIException();
  }

  @override
  emptyValue() {
    throw BindingException("Root level binding should not use emptyValue()");
  }
}

class ModelBinding extends MapBinding<String, dynamic> {
  const ModelBinding.private(
      {@required CollectionBinding parent,
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
  Map<String, dynamic> emptyValue() {
    return Map<String, dynamic>();
  }
}
