import 'package:takkan_script/script/precept_item.dart';

class ValidationMessage {
  final String type;
  final String? debugId;
  final String msg;

  ValidationMessage({required PreceptItem item, required this.msg})
      : type = item.runtimeType.toString(),
        debugId = item.debugId;

  @override
  String toString() {
    return "$type : $debugId : $msg";
  }
}