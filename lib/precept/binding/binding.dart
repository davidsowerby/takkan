import 'package:flutter/material.dart';
import 'package:precept/common/exceptions.dart';
import 'package:precept/precept/binding/listBinding.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';
import 'package:precept/precept/part/string/stringBinding.dart';

/// [T] is model
/// All the static constructors ensure that the [editHost] and [firstLevelKey] are propagated down the document tree.
/// If this binding is looked up from a [MapBinding], [property] is used
/// If this binding is looked up from a [ListBinding], [index] is used
/// Either [property] or [index] may be null, but not both.  If both are specified, [property] takes precedence
abstract class Binding<T> {
  final TemporaryDocument editHost;
  final String firstLevelKey;
  final CollectionBinding parent;
  final String property;
  final int index;

  const Binding.private(
      {@required this.parent,
      this.property,
      this.index,
      @required this.firstLevelKey,
      this.editHost})
      : assert((property != null) || (index != null),
            "There must be either a property or an index");

  T read(
      {T defaultValue,
      bool allowNullReturn = false,
      bool createIfAbsent = true}) {
    T readValue;

    if (property != null) {
      readValue = rValue();
    } else {
      // if a row is missing create only if equivalent to add
      if (createIfAbsent && (parent as ListBinding).count() == index) {
        final value = (defaultValue ?? emptyValue());
        (parent as ListBinding).addRow(value);
        return value;
      }
      readValue = parent.read()[index];
    }
    if (readValue == null) {
      if (allowNullReturn && defaultValue == null) return null;
      if (createIfAbsent) {
        final value = (defaultValue ?? emptyValue());
        if (editHost != null) {
          write(value);
        }
        return value;
      }
      if (defaultValue == null) {
        return (allowNullReturn) ? null : emptyValue();
      } else {
        return defaultValue;
      }
    } else {
      return readValue;
    }
  }

  T rValue() {
    final Map<String, dynamic> parentValue = parent.read();
    return parentValue[property];
  }

  T emptyValue();

  updateDocument() {}

  write(T value) {
    if (editHost == null) {
      throw ConfigurationException(
          "If Bindings are used to write data, the RootBinding must have a valid 'editHost'");
    } else {
      if (parent.read(allowNullReturn: true) == null) {
        parent.create();
      }
      if (property != null) {
        parent.read()[property] = value;
      } else {
        List<T> list = parent.read() as List<T>;
        if (index >= list.length) {
          list.insert(index, value);
        } else {
          list[index] = value;
        }
      }
    }
    editHost.nestedChange(firstLevelKey);
  }
}

abstract class CollectionBinding<T> extends Binding<T> {
  const CollectionBinding.private(
      {@required CollectionBinding parent,
      String property,
      int index,
      @required String firstLevelKey,
      TemporaryDocument editHost})
      : super.private(
            parent: parent,
            firstLevelKey: firstLevelKey,
            editHost: editHost,
            property: property,
            index: index);

  BooleanBinding booleanBinding({String property, int index});

  DoubleBinding doubleBinding({String property, int index});

  IntBinding intBinding({String property, int index});

  StringBinding stringBinding({String property, int index});

  TableBinding tableBinding({String property, int index});

  ListBinding<T> listBinding<T>({String property, int index});

  ModelBinding modelBinding({String property, int index});

  MapBinding<K, V> mapBinding<K, V>({String property, int index});

  DynamicBinding dynamicBinding({String property, int index});

  // TimestampBinding timestampBinding({String property, int index});  TODO How do we handle backend specific bindings?

  /// Creates an empty value in its parent
  /// Invoked when a child binding writes to this binding, but this binding does not actually exist yet in its own parent
  create() {
    write(emptyValue());
  }
}


class DynamicBinding extends Binding<dynamic> {
  const DynamicBinding.private(
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
  String emptyValue() {
    return "";
  }
}

class BooleanBinding extends Binding<bool> {
  const BooleanBinding.private(
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
  bool emptyValue() {
    return false;
  }
}

class DoubleBinding extends Binding<double> {
  const DoubleBinding.private(
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
  double emptyValue() {
    return 0.0;
  }

  @override
  double rValue() {
    final r = parent.read()[property];
    if (r is int) {
      return r.toDouble();
    } else {
      return r;
    }
  }
}

class IntBinding extends Binding<int> {
  const IntBinding.private(
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
  int emptyValue() {
    return 0;
  }
}

/// [T] is the data type of the map value
class TableBinding<T> extends ListBinding<Map<String, T>> {
  const TableBinding.private(
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
  List<Map<String, T>> emptyValue() {
    return List<Map<String, T>>();
  }
}

/// When representing data as a dropdown selection, if the field has an existing value which is not a valid selection, or null, then an exception will occur.
/// This often happens when the field's value has been set to an empty string instead of null (assuming an empty string is invalid).
///
/// This binding wrapper simply corrects for that situation.
///
/// If other cases occur, it may be necessary to check the value against the selection before returning it, though that would leave the data incorrect in the database.class SingleSelectBindingWrapper {

class SingleSelectBindingWrapper {
  final Binding itemBinding;

  SingleSelectBindingWrapper(this.itemBinding);

  read() {
    final itemRead = itemBinding.read();
    if (itemRead == '') {
      return null;
    } else {
      return itemRead;
    }
  }
}

class BindingException implements Exception {
  final String msg;
  final Exception exception;
  final Error error;

  BindingException(this.msg, {this.exception, this.error});

  String errMsg() => msg;
}
