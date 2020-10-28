import 'package:flutter/material.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/listBinding.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/part/string/stringBinding.dart';

import 'dataModel.dart';

/// Base class for presenting a list of models, which themselves are most easily represented as subclasses of [ListItemModel]
abstract class ListModel<MODEL extends ListItemModel> {
  final MODEL Function({@required ModelBinding baseBinding}) itemBuilder;

  final ListBinding baseBinding;

  const ListModel({
    @required this.baseBinding,
    this.itemBuilder,
  }) : assert(itemBuilder != null);

  MODEL item(int index) {
    return itemBuilder(baseBinding: baseBinding.modelBinding(index: index));
  }

  int get count => baseBinding.count();

  List<MODEL> items() {
    List<MODEL> list = List();
    int c = count;
    for (int i = 0; i < c; i++) {
      list.add(item(i));
    }
    return list;
  }

  bool get isNotEmpty => baseBinding.count() > 0;

  bool get isEmpty => baseBinding.count() == 0;

  MODEL findByKey(String key) {
    final items = baseBinding.read();
    int c = 0;
    for (Map<String, dynamic> entry in items) {
      if (entry["key"] == key) {
        return item(c);
      }
      c++;
    }
    throw BindingException("ListItemModel Key '$key' does not exist");
  }
}

/// Base classes for those models which are used as an item in a [ListModel]
mixin ListItemModel on DataModel {
//  const ListItemModel({@required ModelBinding baseBinding}) : super(baseBinding: baseBinding);

  /// Properties

  String get fullName => fullNameBinding.read();

  String get key => keyBinding.read();

  String get shortName => shortNameBinding.read();

  /// Bindings

  StringBinding get keyBinding => baseBinding.stringBinding(property: "key");

  StringBinding get fullNameBinding =>
      baseBinding.stringBinding(property: "fullName");

  StringBinding get shortNameBinding =>
      baseBinding.stringBinding(property: "shortName");
}
