import 'package:flutter/foundation.dart';
import 'package:precept_script/script/preceptItem.dart';

class ValidationMessage {
  final String type;
  final String itemId;
  final String msg;
  final int index;

  ValidationMessage({@required PreceptItem item, @required this.msg, this.index=-1})
      : type = item.runtimeType.toString(),
        itemId = item.id;

  @override
  String toString() {
    final indexString = (index <0) ? '' : ' at index $index ';
    return "$type $indexString: $itemId : $msg";
  }
}