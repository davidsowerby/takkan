import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:precept_client/precept/binding/binding.dart';
import 'package:precept_client/precept/mutable/temporaryDocument.dart';

class TimestampBinding extends Binding<Timestamp> {
  const TimestampBinding.private(
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
  Timestamp emptyValue() {
    return Timestamp.fromMicrosecondsSinceEpoch(0);
  }
}
