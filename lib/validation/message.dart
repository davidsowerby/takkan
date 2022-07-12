import 'package:equatable/equatable.dart';
import '../script/takkan_element.dart';

class ValidationMessage extends Equatable{

  ValidationMessage({required TakkanElement item, required this.msg})
      : type = item.runtimeType.toString(),
        debugId = item.debugId;
  final String type;
  final String? debugId;
  final String msg;

  @override
  String toString() {
    return '$type : $debugId : $msg';
  }

  @override
  List<Object?> get props => [type,debugId,msg];
}
