import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/binding/list_binding.dart';
import 'package:takkan_client/data/binding/string_binding.dart';
import 'package:takkan_client/common/exceptions.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_script/script/constants.dart';

class MapBinding<K, V> extends CollectionBinding<Map<K, V>> {
  const MapBinding.private(
      {CollectionBinding? parent,
      String property = notSet,
      int index = Binding.noValue,
      required String firstLevelKey,
      required super.getEditHost,
      })
      : super.private(
            parent: parent,
            property: property,
            index: index,
            firstLevelKey: firstLevelKey,
  );

  BooleanBinding booleanBinding({required String property}) {
    return BooleanBinding.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  DoubleBinding doubleBinding({required String property}) {
    return DoubleBinding.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  IntBinding intBinding({required String property}) {
    return IntBinding.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  StringBinding stringBinding({required String property}) {
    return StringBinding.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  TableBinding tableBinding({required String property}) {
    return TableBinding.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  ListBinding<T> listBinding<T>({required String property}) {
    return ListBinding.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  ModelBinding modelBinding({required String property}) {
    return ModelBinding.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  MapBinding<K, V> mapBinding<K, V>({required String property}) {
    return MapBinding<K, V>.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  DynamicBinding dynamicBinding({required String property}) {
    return DynamicBinding.private(
        parent: this,
        property: property,
        firstLevelKey: (this.firstLevelKey==notSet) ? property : this.firstLevelKey,
        getEditHost: this.getEditHost);
  }

  // TimestampBinding timestampBinding({required String property}) {
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

/// Binds to [data], which is typically either from a [MutableDocument] for editing, or from a [DocumentSnapshot] in a read only situation.
/// If data is to be written back to a [MutableDocument], [getEditHost] must not be null.
/// Bindings can then make the [MutableDocument] aware of changes at level below that of the first level keys.
/// [id] is primarily used for debugging, to ensure bindings are associated with the correct source
/// [createIfAbsent] will create a value if not present, but only if [getEditHost] is not null (because a null [getEditHost] indicates a read only binding)
class RootBinding extends ModelBinding {
  final Map<String, dynamic> data;
  final String id;
  final instance = DateTime.now();

  RootBinding({required this.data, required MutableDocument? Function() getEditHost, required this.id})
      : super.private(getEditHost: getEditHost, property: "-root-", firstLevelKey: notSet, parent: null);

  @override
  Map<String, dynamic> read(
      {Map<String, dynamic>? defaultValue,
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
      {CollectionBinding? parent,
        String property=notSet,
        int index=Binding.noValue,
      required String firstLevelKey,
        required super.getEditHost,
      })
      : super.private(
            parent: parent,
            property: property,
            index: index,
            firstLevelKey: firstLevelKey,
  );

  @override
  Map<String, dynamic> emptyValue() {
    return Map<String, dynamic>();
  }
}
