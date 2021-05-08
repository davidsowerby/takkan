import 'package:flutter/foundation.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/data/temporaryDocument.dart';

class StringBinding extends Binding<String> {
  const StringBinding.private(
      {@required CollectionBinding parent,
      String property,
      int index,
      @required String firstLevelKey,
      MutableDocument editHost})
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
