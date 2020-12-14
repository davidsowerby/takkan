import 'package:flutter/foundation.dart';
import 'package:precept_script/script/preceptItem.dart';

class ValidationMessage {
  final String type;
  final String itemId;
  final String msg;

  ValidationMessage({@required PreceptItem item, @required this.msg})
      : type = item.runtimeType.toString(),
        itemId = item.id;

  @override
  String toString() {
    return "$type : $itemId : $msg";
  }
}