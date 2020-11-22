import 'package:flutter/foundation.dart';
import 'package:precept_client/precept/binding/binding.dart';
import 'package:precept_client/precept/mutable/temporaryDocument.dart';

class StringBinding extends Binding<String> {
  const StringBinding.private(
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
