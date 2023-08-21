import 'package:json_annotation/json_annotation.dart';
import '../../common/constants.dart';

import '../../common/exception.dart';
import '../../common/log.dart';
import '../field/field.dart';



class FieldConverter
    implements JsonConverter<Field<dynamic>, Map<String, dynamic>> {
  const FieldConverter();

  @override
  Field<dynamic> fromJson(Map<String, dynamic> json) {
    final elementType = json[jsonClassKey];
    switch (elementType) {
      case 'Field':
        return Field.fromJson(json);


      default:
        final msg = 'SchemaElement type $elementType not recognised';
        logType(runtimeType).e(msg);
        throw SchemaException(msg);
    }
  }

  @override
  Map<String, dynamic> toJson(Field<dynamic> object) {
    final type = object.runtimeType;
    final Map<String, dynamic> jsonMap = object.toJson();
    jsonMap[jsonClassKey] = _simpleClassName(object);
    return jsonMap;
  }

  /// Returns the class name of [object] with any generics removed
  String _simpleClassName(dynamic object) {
    String className = object.runtimeType.toString();
    int genericIndex = className.indexOf('<');
    if (genericIndex != -1) {
      className = className.substring(0, genericIndex);
    }
    return className;
  }
}

