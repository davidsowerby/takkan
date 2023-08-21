import 'package:json_annotation/json_annotation.dart';

import '../common/constants.dart';
import '../common/log.dart';



class DataTypeConverter<T>
    implements JsonConverter<T, Map<String, dynamic>> {
  @override
  T fromJson(Map<String, dynamic> json) {
    final elementType = json[jsonClassKey];
    switch (elementType) {
      case 'int':
      case 'double':
      case 'String':
        return json[jsonValueKey] as T;

      default:
        final msg = 'SchemaElement type $elementType not recognised';
        logType(runtimeType).e(msg);
        throw Exception(msg);
    }

  }

  @override
  Map<String, dynamic> toJson(T value) {
    final type = value.runtimeType;
    final outputMap = <String, dynamic>{};
    outputMap[jsonClassKey] = type.toString();
    switch (type) {
      case double:
      case int:
      case String:
        outputMap[jsonValueKey] = value;
        break;
    }
    return outputMap;
  }

  const DataTypeConverter();
}
