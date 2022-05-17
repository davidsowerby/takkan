import 'package:takkan_script/script/takkan_item.dart';

class ValidationMessage {
  final String type;
  final String? debugId;
  final String msg;

  ValidationMessage({required TakkanItem item, required this.msg})
      : type = item.runtimeType.toString(),
        debugId = item.debugId;

  @override
  String toString() {
    return "$type : $debugId : $msg";
  }
}