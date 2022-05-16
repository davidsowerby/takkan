import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/field/string.dart';
import 'package:takkan_script/validation/result.dart';

abstract class V {
  Map<String, dynamic> toJson();
}

VResult validate(V v, dynamic value) {
  if (v is VInteger) {
    return VInteger.validate(v, value);
  }
  if (v is VString) {
    return VString.validate(v, value);
  }
  String msg = '${v.runtimeType} is missing';
  logName('validate in validate.dart').e(msg);
  throw PreceptException(msg);
}

VResultRef validationRef(V v) {
  if (v is VInteger) {
    return VInteger.ref(v);
  }
  if (v is VString) {
    return VString.ref(v);
  }
  String msg = '${v.runtimeType} is missing';
  logName('validationRef in validate.dart').e(msg);
  throw PreceptException(msg);
}
